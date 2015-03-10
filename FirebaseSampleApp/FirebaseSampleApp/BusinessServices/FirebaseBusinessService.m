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
@property (strong, nonatomic) Firebase *firebase;
@property (strong, nonatomic) Firebase *firebaseConnectionReference;
@property (assign, nonatomic) FirebaseHandle connectionHandle;
@end

@implementation FirebaseBusinessService

#pragma mark - Properties

- (Firebase *)firebase {
    if (!_firebase) {
        _firebase = [[Firebase alloc] initWithUrl:self.firebaseUrl];
    }
    return _firebase;
}

#pragma mark - Init

- (id)initWithFirebaseUrl:(NSString *)firebaseUrl {
    if (self = [super init]) {
        self.firebaseUrl = firebaseUrl;
    }
    return self;
}

- (void)startMonitoringConnection {
    NSString *connectionUrl = [self.firebaseUrl stringByAppendingString:@"/.info/connected"];
    self.firebaseConnectionReference = [[Firebase alloc] initWithUrl:connectionUrl];
    
    __weak FirebaseBusinessService *weakSelf = self;
    
    self.connectionHandle = [self.firebaseConnectionReference observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        BOOL connected = [snapshot.value boolValue];
        [weakSelf.delegate firebaseBusinessService:weakSelf connectionDidChange:connected];
    }];
}

- (void)stopMonitoringConnection {
    [self.firebaseConnectionReference removeObserverWithHandle:self.connectionHandle];
}

@end