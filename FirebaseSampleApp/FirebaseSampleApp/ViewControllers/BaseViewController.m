//
//  BaseViewController.m
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "BaseViewController.h"
#import "FirebaseBusinessService.h"

static CGFloat const kTopPadding = 40.0;
static CGFloat const kPadding = 10.0;

#define HEADER_VIEW_HEIGHT (IS_IPHONE ? 50.0 : 100.0)

@interface BaseViewController () <FirebaseBusinessServiceDelegate>
@property (strong, nonatomic) MainViewControllerHeaderView *headerView;
@end

@implementation BaseViewController

#pragma mark - Required Property Overrides

- (NSString *)headerButtonText {
    NSAssert(NO, @"headerButtonText must be overridden in the child class!");
    return nil;
}

- (UIView *)detailView {
    NSAssert(NO, @"detailView must be overriden in the child class!");
    return nil;
}

#pragma mark - Properties

- (FirebaseBusinessService *)firebaseBusinessService {
    if (!_firebaseBusinessService) {
        _firebaseBusinessService = [[FirebaseBusinessService alloc] initWithFirebaseUrl:@"https://plank-firebase-sample.firebaseio.com"];
        _firebaseBusinessService.delegate = self;
    }
    return _firebaseBusinessService;
}

- (MainViewControllerHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MainViewControllerHeaderView alloc] init];
        _headerView.headerText = self.headerButtonText;
        _headerView.connectionActive = YES;
        _headerView.delegate = self;
        _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headerView;
}

#pragma mark - Lifecycle

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.detailView];
    
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/0xff green:240.0/0xff blue:240.0/0xff alpha:1.0];
    self.headerView.backgroundColor = self.view.backgroundColor;
    self.detailView.backgroundColor = self.headerView.backgroundColor;
    
    NSDictionary *viewsDictionary = @{@"headerView": self.headerView,
                                      @"detailView": self.detailView};
    NSDictionary *metrics = @{@"topPadding": @(kTopPadding),
                              @"padding": @(kPadding),
                              @"headerViewHeight": @(HEADER_VIEW_HEIGHT)};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[headerView]-padding-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[detailView]-padding-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topPadding-[headerView(==headerViewHeight)]-padding-[detailView]-padding-|" options:0 metrics:metrics views:viewsDictionary]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.firebaseBusinessService startMonitoringConnection];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.firebaseBusinessService stopMonitoringConnection];
    [super viewDidDisappear:animated];
}

#pragma mark - FirebaseBusinessServiceDelegate

- (void)firebaseBusinessService:(FirebaseBusinessService *)firebaseBusinessService connectionDidChange:(BOOL)connectionActive {
    self.headerView.connectionActive = connectionActive;
}

#pragma mark - MainViewControllerHeaderViewDelegate

- (void)headerButtonPressedWithMainViewControllerHeaderView:(MainViewControllerHeaderView *)headerView {
    NSAssert(NO, @"headerButtonPressedWithMainViewControllerHeaderView: must be implemented in the child class!");
}

@end