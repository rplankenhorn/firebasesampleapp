//
//  DrawingViewController.m
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "DrawingViewController.h"
#import "FDDrawView.h"

@interface DrawingViewController ()
@property (strong, nonatomic) FDDrawView *drawView;
@end

@implementation DrawingViewController

#pragma mark - Property Overrides

- (NSString *)headerButtonText {
    return @"press";
}

- (UIView *)detailView {
    return self.drawView;
}

#pragma mark - Properties

- (FDDrawView *)drawView {
    if (!_drawView) {
        _drawView = [[FDDrawView alloc] initWithFrame:CGRectZero];
        _drawView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _drawView;
}

#pragma mark - MainViewControllerHeaderViewDelegate

- (void)headerButtonPressedWithMainViewControllerHeaderView:(MainViewControllerHeaderView *)headerView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end