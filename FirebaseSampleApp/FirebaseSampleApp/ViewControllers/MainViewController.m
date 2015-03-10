//
//  MainCollectionViewController.m
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewControllerHeaderView.h"

static NSUInteger const kNumberOfButtons = 12;
static CGFloat const kHeaderViewHeight = 50.0;

static NSString * const kSimpleButtonCollectionViewCellReuseIdentifier = @"SimpleButtonCollectionViewCellReuseIdentifier";

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewLayout *layout;
@property (strong, nonatomic) MainViewControllerHeaderView *headerView;
@property (strong, nonatomic) NSMutableArray *activeButtons;
@property (strong, nonatomic) UIColor *activeColor;
@property (strong, nonatomic) UIColor *inactiveColor;
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

- (UIColor *)activeColor {
    if (!_activeColor) {
        _activeColor = [UIColor colorWithRed:129.0/0xff green:188.0/0xff blue:103.0/0xff alpha:1.0];
    }
    return _activeColor;
}

- (UIColor *)inactiveColor {
    if (!_inactiveColor) {
        _inactiveColor = [UIColor colorWithRed:181.0/0xff green:99.0/0xff blue:143.0/0xff alpha:1.0];
    }
    return _inactiveColor;
}

#pragma mark - Lifecycle

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
    
    NSDictionary *viewsDictionary = @{@"headerView": self.headerView,
                                      @"collectionView": self.collectionView};
    NSDictionary *metrics = @{@"topPadding": @(20),
                              @"padding": @(10),
                              @"headerViewHeight": @(kHeaderViewHeight)};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[headerView]-padding-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[collectionView]-padding-|" options:0 metrics:metrics views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topPadding-[headerView(==headerViewHeight)]-padding-[collectionView]-padding-|" options:0 metrics:metrics views:viewsDictionary]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:240.0/0xff green:240.0/0xff blue:240.0/0xff alpha:1.0];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kSimpleButtonCollectionViewCellReuseIdentifier];
    
    // Do any additional setup after loading the view.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.activeButtons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSimpleButtonCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    BOOL active = [[self.activeButtons objectAtIndex:indexPath.row] boolValue];
    
    if (active) {
        cell.contentView.backgroundColor = self.activeColor;
    } else {
        cell.contentView.backgroundColor = self.inactiveColor;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    BOOL active = [[self.activeButtons objectAtIndex:indexPath.row] boolValue];
    active = !active;
    
    [self.activeButtons setObject:[NSNumber numberWithBool:active] atIndexedSubscript:indexPath.row];
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
