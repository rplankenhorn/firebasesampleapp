//
//  DrawingViewController.m
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "DrawingViewController.h"
#import "FDDrawView.h"
#import "FirebaseBusinessService.h"

@interface DrawingViewController () <FDDrawViewDelegate>
@property (strong, nonatomic) FDDrawView *drawView;
@property (strong, nonatomic) NSMutableArray *paths;
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
        _drawView.delegate = self;
        _drawView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _drawView;
}

- (NSMutableArray *)paths {
    if (!_paths) {
        _paths = [[NSMutableArray alloc] init];
    }
    return _paths;
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.firebaseBusinessService startObservingDrawing];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.firebaseBusinessService stopObservingDrawing];
    [super viewDidDisappear:animated];
}

#pragma mark - FirebaseBusinessServiceDelegate

- (void)firebaseBusinessService:(FirebaseBusinessService *)firebaseBusinessService pathValue:(FDPath *)pathValue {
    [self.drawView addPath:pathValue];
    [self.paths addObject:pathValue];
}

#pragma mark - MainViewControllerHeaderViewDelegate

- (void)headerButtonPressedWithMainViewControllerHeaderView:(MainViewControllerHeaderView *)headerView {
    [self.delegate shouldDismissDrawingViewController:self];
}

#pragma mark - FDDrawViewDelegate

- (void)drawView:(FDDrawView *)view didFinishDrawingPath:(FDPath *)path {
    [self.firebaseBusinessService postPath:path];
}

@end