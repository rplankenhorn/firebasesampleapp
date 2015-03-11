//
//  FDDrawView.h
//  Firebase Drawing
//
//  Created by Jonny Dimond on 8/14/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDPath.h"

@class FDDrawView;

@protocol FDDrawViewDelegate <NSObject>

// called when a user finished drawing a line/path
- (void)drawView:(FDDrawView *)view didFinishDrawingPath:(FDPath *)path;
- (void)drawView:(FDDrawView *)view didEraseDrawingPath:(FDPath *)path;

@end

@interface FDDrawView : UIView

@property (nonatomic, assign, getter=isErasingModeEnabled) BOOL erasingModeEnabled;

// the color that is used to draw lines
@property (nonatomic, strong) UIColor *drawColor;

// the delegate that is notified about any drawing by the user
@property (nonatomic, weak) id<FDDrawViewDelegate> delegate;

// adds a path to display to this view
- (void)addPath:(FDPath *)path;


@end
