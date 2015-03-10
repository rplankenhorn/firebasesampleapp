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

@property (weak, nonatomic) id<FirebaseBusinessServiceDelegate> delegate;

- (id)init __attribute__((unavailable("Must use initWithFirebaseUrl:")));
- (id)initWithFirebaseUrl:(NSString *)firebaseUrl;

- (void)startMonitoringConnection;
- (void)stopMonitoringConnection;

@end

@protocol FirebaseBusinessServiceDelegate <NSObject>

- (void)firebaseBusinessService:(FirebaseBusinessService *)firebaseBusinessService connectionDidChange:(BOOL)connectionActive;

@end