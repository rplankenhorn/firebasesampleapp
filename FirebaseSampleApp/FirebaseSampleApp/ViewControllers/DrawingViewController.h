//
//  DrawingViewController.h
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "BaseViewController.h"

@protocol DrawingViewControllerDelegate;

@interface DrawingViewController : BaseViewController

@property (weak, nonatomic) id<DrawingViewControllerDelegate> delegate;

@end

@protocol DrawingViewControllerDelegate <NSObject>

- (void)shouldDismissDrawingViewController:(DrawingViewController *)drawingViewController;

@end