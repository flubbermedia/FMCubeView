//
//  FMCubeView.h
//  FMCubeView
//
//  Created by Andrea Ottolina on 23/04/2013.
//  Copyright (c) 2013 Flubber Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMCubeView : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImage *faceImage;
@property (strong, nonatomic) UIColor *faceColor;

@property (strong, nonatomic) UIImage *downloadImage;
@property (strong, nonatomic) UIImage *deleteImage;

@property (strong, nonatomic) UIColor *cubeBorderColor;
@property (assign, nonatomic) CGFloat cubeBorderWidth;
@property (assign, nonatomic) CGFloat cubeCornerRadius;

@end
