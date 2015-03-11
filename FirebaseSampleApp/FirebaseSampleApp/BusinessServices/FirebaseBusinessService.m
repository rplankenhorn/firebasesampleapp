//
//  FirebaseBusinessService.m
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "FirebaseBusinessService.h"
#import <Firebase/Firebase.h>
#import "FDPath.h"

@interface FirebaseBusinessService ()
@property (strong, nonatomic) NSString *firebaseUrl;
@property (strong, nonatomic) Firebase *firebaseButtonStateObservingReference;
@property (strong, nonatomic) Firebase *firebaseDrawReference;
@property (strong, nonatomic) Firebase *firebaseConnectionReference;
@property (assign, nonatomic) FirebaseHandle connectionHandle;
@property (assign, nonatomic) FirebaseHandle buttonStateObservingHandle;
@property (assign, nonatomic) FirebaseHandle drawingHandle;
@property (assign, nonatomic) FirebaseHandle eraserHandle;
@property (strong, nonatomic) NSMutableSet *outstandingPaths;
@end

@implementation FirebaseBusinessService

#pragma mark - Properties

- (Firebase *)firebaseButtonStateObservingReference {
    if (!_firebaseButtonStateObservingReference) {
        NSString *url = [self.firebaseUrl stringByAppendingString:@"/ios/saving-data/buttonstates"];
        _firebaseButtonStateObservingReference = [[Firebase alloc] initWithUrl:url];
    }
    return _firebaseButtonStateObservingReference;
}

- (Firebase *)firebaseDrawReference {
    if (!_firebaseDrawReference) {
        NSString *url = [self.firebaseUrl stringByAppendingString:@"/ios/saving-data/drawing"];
        _firebaseDrawReference = [[Firebase alloc] initWithUrl:url];
    }
    return _firebaseDrawReference;
}

- (Firebase *)firebaseConnectionReference {
    if (!_firebaseConnectionReference) {
        NSString *url = [self.firebaseUrl stringByAppendingString:@"/.info/connected"];
        _firebaseConnectionReference = [[Firebase alloc] initWithUrl:url];
    }
    return _firebaseConnectionReference;
}

- (NSMutableSet *)outstandingPaths {
    if (!_outstandingPaths) {
        _outstandingPaths = [[NSMutableSet alloc] init];
    }
    return _outstandingPaths;
}

#pragma mark - Init

- (id)initWithFirebaseUrl:(NSString *)firebaseUrl {
    if (self = [super init]) {
        self.firebaseUrl = firebaseUrl;
    }
    return self;
}

#pragma mark - Firebase methods

- (void)startMonitoringConnection {
    __weak FirebaseBusinessService *weakSelf = self;
    
    self.connectionHandle = [self.firebaseConnectionReference observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        weakSelf.connected = [snapshot.value boolValue];
        if ([weakSelf.delegate respondsToSelector:@selector(firebaseBusinessService:connectionDidChange:)]) {
            [weakSelf.delegate firebaseBusinessService:weakSelf connectionDidChange:weakSelf.connected];
        }
    }];
}

- (void)stopMonitoringConnection {
    [self.firebaseConnectionReference removeObserverWithHandle:self.connectionHandle];
}

- (void)startObservingButtonStates {
    __weak FirebaseBusinessService *weakSelf = self;
    
    self.buttonStateObservingHandle = [self.firebaseButtonStateObservingReference observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if ([weakSelf.delegate respondsToSelector:@selector(firebaseBusinessService:buttonStateValues:)]) {
            NSArray *buttonValues = (NSArray *)snapshot.value;
            [weakSelf.delegate firebaseBusinessService:weakSelf buttonStateValues:buttonValues];
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (void)stopObservingButtonStates {
    [self.firebaseButtonStateObservingReference removeObserverWithHandle:self.buttonStateObservingHandle];
}

- (void)postButtonStateValues:(NSArray *)buttonStateValues {
    [self.firebaseButtonStateObservingReference setValue:buttonStateValues];
}

- (void)startObservingDrawing {
    __weak FirebaseBusinessService *weakSelf = self;
    
    self.drawingHandle = [self.firebaseDrawReference observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        if ([weakSelf.outstandingPaths containsObject:snapshot.key]) {
            // this was drawn by this device and already taken care of by our draw view, ignore
        } else {
            // parse the path into our internal format
            FDPath *path = [FDPath parse:snapshot.value];
            if (path != nil) {
                if ([weakSelf.delegate respondsToSelector:@selector(firebaseBusinessService:pathValue:)]) {
                    [weakSelf.delegate firebaseBusinessService:weakSelf pathValue:path];
                }
            } else {
                // there was an error parsing the snapshot, log an error
                NSLog(@"Not a valid path: %@ -> %@", snapshot.key, snapshot.value);
            }
        }
    }];
    
    self.eraserHandle = [self.firebaseDrawReference observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        // parse the path into our internal format
        FDPath *path = [FDPath parse:snapshot.value];
        if (path != nil) {
            if ([weakSelf.delegate respondsToSelector:@selector(firebaseBusinessService:pathRemoved:)]) {
                [weakSelf.delegate firebaseBusinessService:weakSelf pathRemoved:path];
            }
        } else {
            // there was an error parsing the snapshot, log an error
            NSLog(@"Not a valid path: %@ -> %@", snapshot.key, snapshot.value);
        }
    }];
}

- (void)stopObservingDrawing {
    [self.firebaseDrawReference removeObserverWithHandle:self.drawingHandle];
    [self.firebaseDrawReference removeObserverWithHandle:self.eraserHandle];
}

- (void)postPath:(FDPath *)path {
    // the user finished drawing a path
    Firebase *pathRef = [self.firebaseDrawReference childByAutoId];
    
    // get the name of this path which serves as a global id
    NSString *name = pathRef.key;
    
    path.firebaseName = name;
    
    // remember that this path was drawn by this user so it's not drawn twice
    [self.outstandingPaths addObject:name];
    
    __weak FirebaseBusinessService *weakSelf = self;
    
    // save the path to Firebase
    [pathRef setValue:[path serialize] withCompletionBlock:^(NSError *error, Firebase *ref) {
        // The path was successfully saved and can now be removed from the outstanding paths
        [weakSelf.outstandingPaths removeObject:name];
    }];
}

- (void)removePath:(FDPath *)path {
    Firebase *pathRef = [self.firebaseDrawReference childByAppendingPath:path.firebaseName];
    [pathRef removeValue];
}

@end