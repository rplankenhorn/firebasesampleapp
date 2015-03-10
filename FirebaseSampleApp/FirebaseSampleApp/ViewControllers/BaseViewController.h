//
//  BaseViewController.h
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "MainViewControllerHeaderView.h"

@class FirebaseBusinessService;

@interface BaseViewController : UIViewController <MainViewControllerHeaderViewDelegate>

@property (strong, nonatomic) FirebaseBusinessService *firebaseBusinessService;

/**
 *  Required overrides
 */
@property (strong, nonatomic, readonly) NSString *headerButtonText;
@property (strong, nonatomic) UIView *detailView;

@end