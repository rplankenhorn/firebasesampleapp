//
//  MainViewControllerHeaderView.h
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewControllerHeaderView : UIView

@property (strong, nonatomic) NSString *headerText;
@property (assign, nonatomic, getter=isConnectionActive) BOOL connectionActive;

@end