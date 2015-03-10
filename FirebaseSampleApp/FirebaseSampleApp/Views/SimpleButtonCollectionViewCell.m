//
//  SimpleButtonCollectionViewCell.m
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import "SimpleButtonCollectionViewCell.h"

@interface SimpleButtonCollectionViewCell ()
@property (strong, nonatomic) UIColor *activeColor;
@property (strong, nonatomic) UIColor *inactiveColor;
@end

@implementation SimpleButtonCollectionViewCell

#pragma mark - Properties

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

- (void)setActive:(BOOL)active {
    if (active) {
        self.contentView.backgroundColor = self.activeColor;
    } else {
        self.contentView.backgroundColor = self.inactiveColor;
    }
}

#pragma mark - Init

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(7.0, 7.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
}

@end