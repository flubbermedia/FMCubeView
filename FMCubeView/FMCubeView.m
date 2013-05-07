//
//  FMCubeView.m
//  FMCubeView
//
//  Created by Andrea Ottolina on 23/04/2013.
//  Copyright (c) 2013 Flubber Media. All rights reserved.
//

#import "FMCubeView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

static CGFloat const defaultShadowOpacity = 1.0;

@interface FMCubeView ()

@property (assign, nonatomic) CGSize faceSize;
@property (strong, nonatomic) CATransformLayer *baseLayer;

@property (strong, nonatomic) CALayer *frontLayer;
@property (strong, nonatomic) CALayer *leftLayer;
@property (strong, nonatomic) CALayer *rightLayer;

@property (strong, nonatomic) CALayer *frontContentLayer;
@property (strong, nonatomic) CALayer *leftContentLayer;
@property (strong, nonatomic) CALayer *rightContentLayer;

@property (strong, nonatomic) CALayer *frontShadowLayer;
@property (strong, nonatomic) CALayer *leftShadowLayer;
@property (strong, nonatomic) CALayer *rightShadowLayer;

@property (strong, nonatomic) CALayer *leftCoverLayer;
@property (strong, nonatomic) CALayer *leftCoverMaskLayer;
@property (strong, nonatomic) CALayer *leftCoverIconLayer;

@property (strong, nonatomic) CALayer *rightCoverLayer;
@property (strong, nonatomic) CALayer *rightCoverMaskLayer;
@property (strong, nonatomic) CALayer *rightCoverIconLayer;

@property (strong, nonatomic) UIImage *faceImageBW;

@end

@implementation FMCubeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Gesture
        UIPanGestureRecognizer *cubePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cubeDidPan:)];
		cubePan.delegate = self;
        [self addGestureRecognizer:cubePan];
        
        // Layers
        _baseLayer = [CATransformLayer layer];
        
        // Set up front face
		_frontLayer = [CALayer layer];
		_frontLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
		_frontLayer.masksToBounds = YES;
		_frontContentLayer = [CALayer layer];
		_frontContentLayer.contentsGravity = kCAGravityResizeAspectFill;
		_frontShadowLayer = [CALayer layer];
		_frontShadowLayer.backgroundColor = [UIColor blackColor].CGColor;
		_frontShadowLayer.opacity = 0;
		[_frontLayer addSublayer:_frontContentLayer];
		[_frontLayer addSublayer:_frontShadowLayer];
		
		// Set up left face
		_leftLayer = [CALayer layer];
		_leftLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
		_leftLayer.masksToBounds = YES;
		_leftContentLayer = [CALayer layer];
		_leftContentLayer.contentsGravity = kCAGravityResizeAspectFill;
		_leftCoverMaskLayer = [CALayer layer];
		_leftCoverMaskLayer.backgroundColor = [UIColor blackColor].CGColor;
		_leftCoverLayer = [CALayer layer];
		_leftCoverLayer.contentsGravity = kCAGravityResizeAspectFill;
		_leftCoverLayer.mask = _leftCoverMaskLayer;
		_leftCoverIconLayer = [CALayer layer];
		_leftCoverIconLayer.contentsGravity = kCAGravityResizeAspect;
		_leftShadowLayer = [CALayer layer];
		_leftShadowLayer.backgroundColor = [UIColor blackColor].CGColor;
		_leftShadowLayer.opacity = 0;
		[_leftLayer addSublayer:_leftContentLayer];
		[_leftLayer addSublayer:_leftCoverLayer];
		[_leftLayer addSublayer:_leftCoverIconLayer];
		[_leftLayer addSublayer:_leftShadowLayer];
		
		// Set up right face
		_rightLayer = [CALayer layer];
		_rightLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
		_rightLayer.masksToBounds = YES;
		_rightContentLayer = [CALayer layer];
		_rightContentLayer.contentsGravity = kCAGravityResizeAspectFill;
		_rightCoverMaskLayer = [CALayer layer];
		_rightCoverMaskLayer.backgroundColor = [UIColor blackColor].CGColor;
		_rightCoverLayer = [CALayer layer];
		_rightCoverLayer.contentsGravity = kCAGravityResizeAspectFill;
		_rightCoverLayer.mask = _rightCoverMaskLayer;
		_rightCoverIconLayer = [CALayer layer];
		_rightCoverIconLayer.contentsGravity = kCAGravityResizeAspect;
		_rightShadowLayer = [CALayer layer];
		_rightShadowLayer.backgroundColor = [UIColor blackColor].CGColor;
		_rightShadowLayer.opacity = 0;
		[_rightLayer addSublayer:_rightContentLayer];
		[_rightLayer addSublayer:_rightCoverLayer];
		[_rightLayer addSublayer:_rightCoverIconLayer];
		[_rightLayer addSublayer:_rightShadowLayer];
        
		// Add all faces
        [_baseLayer addSublayer:_frontLayer];
        [_baseLayer addSublayer:_leftLayer];
        [_baseLayer addSublayer:_rightLayer];
		
        [self.layer addSublayer:_baseLayer];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _faceSize = self.frame.size;
    
    _baseLayer.position = CGPointMake(_faceSize.width * 0.5, _faceSize.height * 0.5);
    
    _frontLayer.transform = CATransform3DIdentity;
    _frontLayer.frame = self.bounds;
    _frontLayer.position = CGPointMake(0.0, 0.0);
	_frontContentLayer.frame = _frontLayer.bounds;
	_frontShadowLayer.frame = _frontLayer.bounds;
    
    _leftLayer.transform = CATransform3DIdentity;
    _leftLayer.frame = self.bounds;
    _leftLayer.anchorPoint = CGPointMake(1.0, 0.0);
    _leftLayer.position = CGPointMake(-_faceSize.width * 0.5, -_faceSize.height * 0.5);
    _leftLayer.transform = CATransform3DMakeRotation(-M_PI_2, 0.0, 1.0, 0.0);
	_leftContentLayer.frame = _leftLayer.bounds;
    _leftCoverLayer.frame = _leftLayer.bounds;
    _leftCoverMaskLayer.frame = _leftLayer.bounds;
    _leftCoverIconLayer.frame = _leftLayer.bounds;
	_leftShadowLayer.frame = _leftLayer.bounds;
    
    _rightLayer.transform = CATransform3DIdentity;
    _rightLayer.frame = self.bounds;
    _rightLayer.anchorPoint = CGPointMake(0.0, 0.0);
    _rightLayer.position = CGPointMake(_faceSize.width * 0.5, -_faceSize.height * 0.5);
    _rightLayer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 0.0);
	_rightContentLayer.frame = _rightLayer.bounds;
	_rightCoverLayer.frame = _rightLayer.bounds;
    _rightCoverMaskLayer.frame = _rightLayer.bounds;
    _rightCoverIconLayer.frame = _rightLayer.bounds;
	_rightShadowLayer.frame = _rightLayer.bounds;
    
    [self updateBaselayerWithAngle:0 zoom:0 animated:NO];
}

#pragma mark - Public setters

- (void)setDownloadImage:(UIImage *)downloadImage
{
	_downloadImage = downloadImage;
	_leftCoverIconLayer.contents = (id)_downloadImage.CGImage;
}

- (void)setDeleteImage:(UIImage *)deleteImage
{
	_deleteImage = deleteImage;
	_rightCoverIconLayer.contents = (id)_deleteImage.CGImage;
}

- (void)setFaceColor:(UIColor *)faceColor
{
	_faceColor = faceColor;
	_frontLayer.backgroundColor = _faceColor.CGColor;
	_leftLayer.backgroundColor = _faceColor.CGColor;
	_rightLayer.backgroundColor = _faceColor.CGColor;
}

- (void)setFaceImage:(UIImage *)faceImage
{
	_faceImage = faceImage;
	_faceImageBW = [self blackAndWhiteImage:_faceImage];
    _frontContentLayer.contents = (id)_faceImageBW.CGImage;
    _leftContentLayer.contents = (id)_faceImage.CGImage;
    _leftCoverLayer.contents = (id)_faceImageBW.CGImage;
}

- (void)setCubeBorderColor:(UIColor *)cubeBorderColor
{
	_cubeBorderColor = cubeBorderColor;
	_frontContentLayer.borderColor = _cubeBorderColor.CGColor;
	_leftCoverIconLayer.borderColor = _cubeBorderColor.CGColor;
	_rightCoverIconLayer.borderColor = _cubeBorderColor.CGColor;
}

- (void)setCubeBorderWidth:(CGFloat)cubeBorderWidth
{
	_cubeBorderWidth = cubeBorderWidth;
	_frontContentLayer.borderWidth = _cubeBorderWidth;
	_leftCoverIconLayer.borderWidth = _cubeBorderWidth;
	_rightCoverIconLayer.borderWidth = _cubeBorderWidth;
}

- (void)setCubeCornerRadius:(CGFloat)cubeCornerRadius
{
	_cubeCornerRadius = cubeCornerRadius;
	_frontLayer.cornerRadius = _cubeCornerRadius;
	_leftLayer.cornerRadius = _cubeCornerRadius;
	_rightLayer.cornerRadius = _cubeCornerRadius;
}

#pragma mark - Private utils

- (UIImage *)blackAndWhiteImage:(UIImage*)image
{
	CIImage *beginImage = [CIImage imageWithCGImage:image.CGImage];
	
	CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:-0.28], @"inputContrast", [NSNumber numberWithFloat:0.43], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.5], nil].outputImage;
	
	CIContext *context = [CIContext contextWithOptions:nil];
	CGImageRef cgImage = [context createCGImage:output fromRect:output.extent];
	UIImage *newImage = [UIImage imageWithCGImage:cgImage];
	
	CGImageRelease(cgImage);
	
	return newImage;
}

#pragma mark - Cube transformations

- (void)updateShadowsWithAngle:(CGFloat)angle
{
	CGFloat ratio = angle/M_PI_2;
	_frontShadowLayer.opacity = fabs(ratio) * defaultShadowOpacity;
	_leftShadowLayer.opacity = (1 - ratio) * defaultShadowOpacity;
	_rightShadowLayer.opacity = (1 + ratio) * defaultShadowOpacity;
}

- (void)updateBaselayerWithAngle:(CGFloat)angle zoom:(CGFloat)zoom animated:(BOOL)animated
{
    animated ? nil : [CATransaction setAnimationDuration:0];
    _baseLayer.anchorPointZ = zoom;
    _baseLayer.sublayerTransform = [self defaultTransform3DRotated:angle zoom:zoom];
	[self updateShadowsWithAngle:angle];
}

- (CATransform3D)defaultTransform3DRotated:(CGFloat)angle zoom:(CGFloat)zoom
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / (1.7 * _faceSize.width);
    transform = CATransform3DTranslate(transform, 0.0, 0.0, -_faceSize.width * 0.5 + zoom);
    transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
    transform = CATransform3DTranslate(transform, 0.0, 0.0, _faceSize.width * 0.5 + zoom);
    return transform;
}

- (void)resetCube
{
    self.layer.zPosition = 0;
    _leftCoverMaskLayer.transform = CATransform3DIdentity;
	_rightCoverMaskLayer.transform = CATransform3DIdentity;
    _frontContentLayer.contents = (id)_faceImageBW.CGImage;
    [self updateBaselayerWithAngle:0 zoom:0 animated:YES];
}

#pragma mark - Gesture handling

- (void)cubeDidPan:(UIPanGestureRecognizer *)gesture
{
    
    CGFloat angle = [(NSNumber *)[_baseLayer valueForKeyPath:@"sublayerTransform.rotation.y"] floatValue];
    CGPoint displacement = [gesture translationInView:self];
    CGFloat zoom = (_faceSize.width * 0.5 - sqrtf(2 * powf(_faceSize.width * 0.5, 2))) * (sinf(fabsf(angle) * 2));
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        
        CGFloat newAngle = angle + (displacement.x * M_PI_2 / _faceSize.width);
        
        newAngle = (newAngle < M_PI_2) ? newAngle : M_PI_2;
        newAngle = (newAngle > -M_PI_2) ? newAngle : -M_PI_2;
        
        // Set layer.zPosition to -1 to keep cube always behind.
        // Set duration to 0 to disable implicit animation.
        self.layer.zPosition = -1;
        
        [self updateBaselayerWithAngle:newAngle zoom:zoom animated:NO];
        
        [gesture setTranslation:CGPointZero inView:self];
        
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        CGFloat finalAngle = 0.0;
        void (^completitionBlock)(void) = ^{
            self.layer.zPosition = 0;
        };
        
        if (angle > M_PI_4)
        {
            finalAngle = M_PI_2;
            completitionBlock = ^{
                self.layer.zPosition = 0;
                [CATransaction setAnimationDuration:2];
                [CATransaction setCompletionBlock:^{
                    [self updateBaselayerWithAngle:0 zoom:0 animated:YES];
                    _frontContentLayer.contents = (id)_faceImage.CGImage;
                }];
                _leftCoverMaskLayer.transform = CATransform3DMakeTranslation(0.0, _leftCoverMaskLayer.bounds.size.height, 0.0);
            };
        }
        
        if (angle < -M_PI_4)
        {
            finalAngle = -M_PI_2;
            completitionBlock = ^{
                [self resetCube];
            };
        }
        
        // Set layer.zPosition to 0 on completition
        [CATransaction setCompletionBlock:completitionBlock];
        [self updateBaselayerWithAngle:finalAngle zoom:0 animated:YES];
    }
}

#pragma mark - Gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

@end
