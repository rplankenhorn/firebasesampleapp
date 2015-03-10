//
//  FirebaseBusinessService.h
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FirebaseBusinessServiceDelegate;

@interface FirebaseBusinessService : NSObject

@property (assign, nonatomic, getter=isConnected) BOOL connected;
@property (weak, nonatomic) id<FirebaseBusinessServiceDelegate> delegate;

- (id)init __attribute__((unavailable("Must use initWithFirebaseUrl:")));
- (id)initWithFirebaseUrl:(NSString *)firebaseUrl;

- (void)startMonitoringConnection;
- (void)stopMonitoringConnection;

- (void)startObservingButtonStates;
- (void)stopObservingButtonStates;

- (void)postButtonStateValues:(NSArray *)buttonStateValues;

@end

@protocol FirebaseBusinessServiceDelegate <NSObject>

@optional
- (void)firebaseBusinessService:(FirebaseBusinessService *)firebaseBusinessService connectionDidChange:(BOOL)connectionActive;
- (void)firebaseBusinessService:(FirebaseBusinessService *)firebaseBusinessService buttonStateValues:(NSArray *)buttonStateValues;

@end