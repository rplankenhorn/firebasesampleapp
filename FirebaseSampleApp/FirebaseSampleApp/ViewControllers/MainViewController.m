//
//  MainCollectionViewController.m
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewControllerHeaderView.h"
#import "SimpleButtonCollectionViewCell.h"
#import "FirebaseBusinessService.h"

static NSUInteger const kNumberOfButtons = 12;
//static CGFloat const kHeaderViewHeight = 50.0;
static CGSize const kCellSize = {100.0, 50.0};

#define TOP_PADDING (IS_IPHONE ? 20.0 : 40.0)
#define HEADER_VIEW_HEIGHT (IS_IPHONE ? 50.0 : 100.0)

static NSString * const kSimpleButtonCollectionViewCellReuseIdentifier = @"SimpleButtonCollectionViewCellReuseIdentifier";

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FirebaseBusinessServiceDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewLayout *layout;
@property (strong, nonatomic) MainViewControllerHeaderView *headerView;

@property (strong, nonatomic) NSMutableArray *activeButtons;
@property (strong, nonatomic) FirebaseBusinessService *firebaseBusinessService;

@end

@implementation MainViewController

#pragma mark - Properties

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _collectionView;
}

- (UICollectionViewLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

- (MainViewControllerHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MainViewControllerHeaderView alloc] init];
        _headerView.headerText = @"draw";
        _headerView.connectionActive = YES;
        _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headerView;
}

- (NSArray *)activeButtons {
    if (!_activeButtons) {
        _activeButtons = [[NSMutableArray alloc] init];
        
        for (NSUInteger i = 0; i < kNumberOfButtons; i++) {
            [_activeButtons addObject:[NSNumber numberWithBool:NO]];
        }
    }
    return _activeButtons;
}

- (FirebaseBusinessService *)firebaseBusinessService {
    if (!_firebaseBusinessService) {
        _firebaseBusinessService = [[FirebaseBusinessService alloc] initWithFirebaseUrl:@"https://plank-firebase-sample.firebaseio.com"];
        _firebaseBusinessService.delegate = self;
    }
    return _firebaseBusinessService;
}

#pragma mark - Lifecycle

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/0xff green:240.0/0xff blue:240.0/0xff alpha:1.0];
    self.headerView.backgroundColor = self.view.backgroundColor;
    self.collectionView.backgroundColor = self.headerView.backgroundColor;
    
    NSDictionary *viewsDictionary = @{@"headerView": self.headerView,
                                      @"collectionView": self.collectionView};
    NSDictionary *metrics = @{@"topPadding": @(TOP_PADDING),
                              @"padding": @(10),
                              @"headerViewHeight": @(HEADER_VIEW_HEIGHT)};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[headerView]-padding-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[collectionView]-padding-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topPadding-[headerView(==headerViewHeight)]-padding-[collectionView]-padding-|" options:0 metrics:metrics views:viewsDictionary]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[SimpleButtonCollectionViewCell class] forCellWithReuseIdentifier:kSimpleButtonCollectionViewCellReuseIdentifier];
    
    [self.firebaseBusinessService startMonitoringConnection];
    [self.firebaseBusinessService startObservingButtonStates];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.activeButtons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SimpleButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSimpleButtonCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = self.collectionView.backgroundColor;
    
    BOOL active = [[self.activeButtons objectAtIndex:indexPath.row] boolValue];
    
    [cell setActive:active];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (self.firebaseBusinessService.isConnected) {
        BOOL active = [[self.activeButtons objectAtIndex:indexPath.row] boolValue];
        active = !active;
        
        [self.activeButtons setObject:[NSNumber numberWithBool:active] atIndexedSubscript:indexPath.row];
        
        [self.firebaseBusinessService postButtonStateValues:self.activeButtons];
        
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kCellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (IS_IPHONE) {
        return UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0);
    } else {
        return UIEdgeInsetsMake(0.0, 100.0, 0.0, 100.0);
    }
}

#pragma mark - FirebaseBusinessServiceDelegate

- (void)firebaseBusinessService:(FirebaseBusinessService *)firebaseBusinessService buttonStateValues:(NSArray *)buttonStateValues {
    self.activeButtons = [NSMutableArray arrayWithArray:buttonStateValues];
    [self.collectionView reloadData];
}

- (void)firebaseBusinessService:(FirebaseBusinessService *)firebaseBusinessService connectionDidChange:(BOOL)connectionActive {
    self.headerView.connectionActive = connectionActive;
}

@end