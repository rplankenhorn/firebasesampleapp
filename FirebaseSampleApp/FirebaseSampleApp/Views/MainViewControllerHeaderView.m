//
//  MainViewControllerHeaderView.m
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "MainViewControllerHeaderView.h"
#import "UIView+AutoLayout.h"

static CGSize const kConnectionImageSize = {25.0, 25.0};

@interface MainViewControllerHeaderView ()
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UIImageView *connectionIndicatorImage;
@end

@implementation MainViewControllerHeaderView

#pragma mark - Properties

- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.textColor = [UIColor whiteColor];
        _headerLabel.backgroundColor = [UIColor colorWithRed:91.0/0xff green:149.0/0xff blue:214.0/0xff alpha:1.0];
        _headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headerLabel;
}

- (UIImageView *)connectionIndicatorImage {
    if (!_connectionIndicatorImage) {
        _connectionIndicatorImage = [[UIImageView alloc] init];
        _connectionIndicatorImage.backgroundColor = [UIColor purpleColor];
        _connectionIndicatorImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _connectionIndicatorImage;
}

- (NSString *)headerText {
    return self.headerLabel.text;
}

- (void)setHeaderText:(NSString *)headerText {
    self.headerLabel.text = headerText;
}

- (void)setConnectionActive:(BOOL)connectionActive {
    if (connectionActive) {
        self.connectionIndicatorImage.backgroundColor = [UIColor greenColor];
    } else {
        self.connectionIndicatorImage.backgroundColor = [UIColor redColor];
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
    
    [self addSubview:self.headerLabel];
    [self addSubview:self.connectionIndicatorImage];
    
    NSDictionary *viewsDictionary = @{@"headerLabel": self.headerLabel,
                                      @"image": self.connectionIndicatorImage};
    
    NSDictionary *metrics = @{@"padding": @(10)};
    
    [self.headerLabel constrainToSize:CGSizeMake(100.0, 33.0)];
    [self.connectionIndicatorImage constrainToSize:kConnectionImageSize];
    
    [self.headerLabel centerInView:self];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-padding-|" options:0 metrics:metrics views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[image]" options:0 metrics:metrics views:viewsDictionary]];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headerLabel.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(7.0, 7.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.headerLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headerLabel.layer.mask = maskLayer;
}

@end