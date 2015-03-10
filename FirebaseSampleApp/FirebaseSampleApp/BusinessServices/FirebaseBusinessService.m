//
//  FirebaseBusinessService.m
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "FirebaseBusinessService.h"
#import <Firebase/Firebase.h>

@interface FirebaseBusinessService ()
@property (strong, nonatomic) NSString *firebaseUrl;
@property (strong, nonatomic) Firebase *firebaseButtonStateObservingReference;
@property (strong, nonatomic) Firebase *firebaseConnectionReference;
@property (assign, nonatomic) FirebaseHandle connectionHandle;
@property (assign, nonatomic) FirebaseHandle buttonStateObservingHandle;
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

#pragma mark - Init

- (id)initWithFirebaseUrl:(NSString *)firebaseUrl {
    if (self = [super init]) {
        self.firebaseUrl = firebaseUrl;
    }
    return self;
}

#pragma mark - Firebase methods

- (void)startMonitoringConnection {
    NSString *connectionUrl = [self.firebaseUrl stringByAppendingString:@"/.info/connected"];
    self.firebaseConnectionReference = [[Firebase alloc] initWithUrl:connectionUrl];
    
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

@end