//
//  SimpleButtonCollectionViewCell.h
//  FirebaseSampleApp
//
//  Created by Robbie Plankenhorn on 3/9/15.
//  Copyright (c) 2015 Robbie Plankenhorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleButtonCollectionViewCell : UICollectionViewCell

@property (assign, nonatomic, getter=isActive) BOOL active;

@end