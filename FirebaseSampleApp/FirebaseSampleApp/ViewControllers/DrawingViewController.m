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
#import "UIView+AutoLayout.h"

@interface DrawingViewController () <FDDrawViewDelegate>
@property (strong, nonatomic) FDDrawView *drawView;
@property (strong, nonatomic) UIButton *eraserButton;
@property (strong, nonatomic) NSMutableArray *paths;
@property (assign, nonatomic, getter=isErasing) BOOL erasing;
@end

@implementation DrawingViewController

@synthesize detailView = _detailView;

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
        [_drawView addSubview:self.eraserButton];
        
        NSDictionary *viewsDictionary = @{@"eraserButton": self.eraserButton};
        [_drawView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[eraserButton]-0-|" options:0 metrics:nil views:viewsDictionary]];
        [_drawView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[eraserButton]-0-|" options:0 metrics:nil views:viewsDictionary]];
        
        [self.eraserButton constrainToSize:CGSizeMake(200.0, 50.0)];
        
        _drawView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _drawView;
}

- (UIButton *)eraserButton {
    if (!_eraserButton) {
        _eraserButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_eraserButton setTitle:@"Enable Eraser" forState:UIControlStateNormal];
        [_eraserButton addTarget:self action:@selector(eraserButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_eraserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _eraserButton.adjustsImageWhenHighlighted = NO;
        _eraserButton.backgroundColor = [UIColor colorWithRed:91.0/0xff green:149.0/0xff blue:214.0/0xff alpha:1.0];
        _eraserButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _eraserButton;
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

#pragma mark - Actions

- (void)eraserButtonTapped:(id)sender {
    self.erasing = !self.isErasing;
    self.drawView.erasingModeEnabled = self.isErasing;
    NSString *buttonText = (self.isErasing ? @"Disable Eraser" : @"Enable Eraser");
    [self.eraserButton setTitle:buttonText forState:UIControlStateNormal];
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

- (void)drawView:(FDDrawView *)view didEraseDrawingPath:(FDPath *)path {
    [self.firebaseBusinessService removePath:path];
}

- (void)firebaseBusinessService:(FirebaseBusinessService *)firebaseBusinessService pathRemoved:(FDPath *)pathValue {
    [self.drawView removePath:pathValue];
}

@end