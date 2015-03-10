//
//  MainViewControllerHeaderView.m
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "MainViewControllerHeaderView.h"
#import "UIView+AutoLayout.h"

static CGSize const kHeaderButtonSizeiPhone = {100.0, 33.0};
static CGSize const kHeaderButtonSizeiPad = {200.0, 66.0};
static CGSize const kConnectionImageSizeiPhone = {25.0, 25.0};
static CGSize const kConnectionImageSizeiPad = {75.0, 75.0};

#define HEADER_BUTTON_SIZE (IS_IPHONE ? kHeaderButtonSizeiPhone : kHeaderButtonSizeiPad)
#define CONNECTION_IMAGE_SIZE (IS_IPHONE ? kConnectionImageSizeiPhone : kConnectionImageSizeiPad)

@interface MainViewControllerHeaderView ()
@property (strong, nonatomic) UIButton *headerButton;
@property (strong, nonatomic) UIImageView *connectionIndicatorImage;
@end

@implementation MainViewControllerHeaderView

#pragma mark - Properties

- (UIButton *)headerButton {
    if (!_headerButton) {
        _headerButton = [[UIButton alloc] init];
        _headerButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        _headerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _headerButton.titleLabel.textColor = [UIColor whiteColor];
        _headerButton.backgroundColor = [UIColor colorWithRed:91.0/0xff green:149.0/0xff blue:214.0/0xff alpha:1.0];
        [_headerButton addTarget:self action:@selector(headerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _headerButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headerButton;
}

- (UIImageView *)connectionIndicatorImage {
    if (!_connectionIndicatorImage) {
        _connectionIndicatorImage = [[UIImageView alloc] init];
        _connectionIndicatorImage.image = [UIImage imageNamed:@"happy_face"];
        _connectionIndicatorImage.contentMode = UIViewContentModeScaleAspectFit;
        _connectionIndicatorImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _connectionIndicatorImage;
}

- (NSString *)headerText {
    return self.headerButton.titleLabel.text;
}

- (void)setHeaderText:(NSString *)headerText {
    [self.headerButton setTitle:headerText forState:UIControlStateNormal];
}

- (void)setConnectionActive:(BOOL)connectionActive {
    if (connectionActive) {
        self.connectionIndicatorImage.image = [UIImage imageNamed:@"happy_face"];
    } else {
        self.connectionIndicatorImage.image = [UIImage imageNamed:@"sad_face"];
    }
}

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // Make view some arbitrary size bigger than 0x0 so we don't get constraint errors.  It'll adjust when constraints are applied to the superview.
    if (self.frame.size.width == 0 &&
        self.frame.size.height == 0) {
        CGRect frame = self.frame;
        frame = CGRectMake(0, 0, 500.0, 500.0);
        self.frame = frame;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.headerButton];
    [self addSubview:self.connectionIndicatorImage];
    
    NSDictionary *viewsDictionary = @{@"headerButton": self.headerButton,
                                      @"image": self.connectionIndicatorImage};
    
    NSDictionary *metrics = @{@"padding": @(10)};
    
    [self.headerButton constrainToSize:HEADER_BUTTON_SIZE];
    [self.connectionIndicatorImage constrainToSize:CONNECTION_IMAGE_SIZE];
    
    [self.headerButton centerInView:self];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-padding-|" options:0 metrics:metrics views:viewsDictionary]];
    
    if (IS_IPHONE) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[image]" options:0 metrics:metrics views:viewsDictionary]];
    } else {
        [self.connectionIndicatorImage centerInContainerOnAxis:NSLayoutAttributeCenterY];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headerButton.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(7.0, 7.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.headerButton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headerButton.layer.mask = maskLayer;
}

#pragma mark - Actions

- (void)headerButtonTapped:(id)sender {
    [self.delegate headerButtonPressedWithMainViewControllerHeaderView:self];
}

@end