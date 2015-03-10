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
#import "DrawingViewController.h"

static NSUInteger const kNumberOfButtons = 12;
static CGSize const kCellSize = {100.0, 50.0};

static NSString * const kSimpleButtonCollectionViewCellReuseIdentifier = @"SimpleButtonCollectionViewCellReuseIdentifier";

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DrawingViewControllerDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewLayout *layout;
@property (strong, nonatomic) NSMutableArray *activeButtons;
@end

@implementation MainViewController

#pragma mark - Property Overrides

- (NSString *)headerButtonText {
    return @"draw";
}

- (UIView *)detailView {
    return self.collectionView;
}

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

- (NSArray *)activeButtons {
    if (!_activeButtons) {
        _activeButtons = [[NSMutableArray alloc] init];
        
        for (NSUInteger i = 0; i < kNumberOfButtons; i++) {
            [_activeButtons addObject:[NSNumber numberWithBool:NO]];
        }
    }
    return _activeButtons;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[SimpleButtonCollectionViewCell class] forCellWithReuseIdentifier:kSimpleButtonCollectionViewCellReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.firebaseBusinessService startObservingButtonStates];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.firebaseBusinessService stopObservingButtonStates];
    [super viewDidDisappear:animated];
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

#pragma mark - MainViewControllerHeaderViewDelegate

- (void)headerButtonPressedWithMainViewControllerHeaderView:(MainViewControllerHeaderView *)headerView {
    DrawingViewController *drawingViewController = [[DrawingViewController alloc] init];
    drawingViewController.delegate = self;
    drawingViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:drawingViewController animated:YES completion:nil];
}

#pragma mark - DrawingViewControllerDelegate

- (void)shouldDismissDrawingViewController:(DrawingViewController *)drawingViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end