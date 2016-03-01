/*
 * BlurDialogView
 *
 * Created by MMizogaki on 10/2/15.
 * Copyright (c) 2015 MMizogaki . All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "BlurDialogView.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

CGFloat const kBlurDefaultDelay = 0.125f;
CGFloat const kDefaultBlurScale = 0.2f;
CGFloat const kBlurDefaultDuration = 0.2f;
CGFloat const kBlurViewMaxAlpha = 1.f;
CGFloat const kBlurBounceOutDurationScale = 0.8f;

NSString * const kBlurDidShowNotification  = @"github.com/MMasahito.BlurModalView.show";
NSString * const kBlurDidHidewNotification = @"github.com/MMasahito.BlurModalView.hide";

typedef void (^RNNBlurCompletion)(void);


@interface UIView (Sizes)
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@end

@interface UIView (Screenshot)
- (UIImage*)screenshot;
@end

@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end

@interface RNNBlurView : UIImageView
- (id)initWithCoverView:(UIView*)view;
@end

@interface RNNCloseButton : UIButton
@end

@interface BlurDialogView ()
@property (assign, readwrite) BOOL isVisible;
@end

#pragma mark - RNNBlurModalView

@implementation BlurDialogView {
    UIViewController *_controller;
    UIView *_parentView;
    UIView *_contentView;
    RNNCloseButton *_dismissButton;
    RNNBlurView *_blurView;
    RNNBlurCompletion _completion;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        _dismissButton = [[RNNCloseButton alloc] init];
        _dismissButton.center = CGPointZero;
        [_dismissButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        
        [self.duringDraftSaveButton addTarget:self action:@selector(duringDraftSaveButtonTapped:)forControlEvents:UIControlEventTouchUpInside];
        [self.duringConsiderationButton addTarget:self action:@selector(duringConsiderationButtonTapped:)forControlEvents:UIControlEventTouchUpInside];
        
        
        self.alpha = 0.f;
        self.backgroundColor = [UIColor clearColor];
        
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight |
                                 UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleTopMargin);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChangeNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}



- (id)initWithViewController:(UIViewController*)viewController view:(UIView*)view {
    if (self = [self initWithFrame:(CGRect){CGPointZero, viewController.view.width, viewController.view.height}]) {
        [self addSubview:view];
        _contentView = view;
        _contentView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _controller = viewController;
        _parentView = nil;
        _contentView.clipsToBounds = YES;
        _contentView.layer.masksToBounds = YES;
        
        _dismissButton.center = CGPointMake(view.left, view.top);
        [self addSubview:_dismissButton];
    }
    return self;
}

- (id)initWithParentView:(UIView*)parentView view:(UIView*)view {
    if (self = [self initWithFrame:(CGRect){CGPointZero, parentView.width, parentView.height}]) {
        [self addSubview:view];
        _contentView = view;
        _contentView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _controller = nil;
        _parentView = parentView;
        _contentView.clipsToBounds = YES;
        _contentView.layer.masksToBounds = YES;
        
        _dismissButton.center = CGPointMake(view.left, view.top);
        [self addSubview:_dismissButton];
    }
    return self;
}


- (id)initWithView:(NSString*)title topButtonTitle:(NSString *)topTitle downButtonTile:(NSString*)downTitle backColor:(UIColor*)backC LineColor:(UIColor*)lineC {
    
    float viewheight = 4;
    float topPointY = 4;
    float duringDraftSaveButtonPointY = 3.87;
    float duringDraftSaveButtonHeight = 2.75;
    float duringConsiderationButtonPointY = 1.58;
    float duringConsiderationButtonHeight = 2.75;
    
    if ((topTitle == nil) ||(downTitle == nil)) {
        viewheight = 7.0;
        topPointY = 3;
        
        duringDraftSaveButtonPointY = 2.95;
        duringDraftSaveButtonHeight = 1.55;
        duringConsiderationButtonPointY = 2.95;
        duringConsiderationButtonHeight = 1.55;
    }
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            [[UIApplication sharedApplication].delegate window].rootViewController.view.frame.size.width/1.4,
                                                            [[UIApplication sharedApplication].delegate window].rootViewController.view.frame.size.height/viewheight)];
    view.backgroundColor = backC;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 7.0f;
    view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    view.layer.shadowRadius = 3.0f;
    view.layer.shadowOpacity = 1.5f;
    view.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    view.layer.shouldRasterize = YES;
    view.layer.borderColor = lineC.CGColor;
    view.layer.borderWidth = 1.0f;
    
    UIView *viewLineTop = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   view.frame.size.height/topPointY,
                                                                   view.frame.size.width,
                                                                   1)];
    viewLineTop.backgroundColor = lineC;
    [view addSubview:viewLineTop];
    
    
    
    UIView *viewLineDown = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    view.frame.size.height/1.60,
                                                                    view.frame.size.width,
                                                                    1)];
    viewLineDown.backgroundColor = lineC;
    [view addSubview:viewLineDown];
    
    if ((topTitle == nil) ||(downTitle == nil))  {
        [viewLineDown removeFromSuperview];
    }
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                              0,
                                                              view.frame.size.width,
                                                              view.frame.size.height/topPointY)];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    [label setFont:[UIFont systemFontOfSize:13]];
    label.textAlignment = UIBaselineAdjustmentAlignCenters;
    [view addSubview:label];
    
    UIImage *(^createImageFromUIColor)(UIColor *) = ^(UIColor *color)
    {
        CGRect rect = {CGPointZero, 1, 1};
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(contextRef, [color CGColor]);
        CGContextFillRect(contextRef, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    };
    
    UIImage *backImage = createImageFromUIColor([UIColor colorWithRed:0.7072 green:0.6962 blue:0.7396 alpha:0.49]);
    
    if (topTitle != nil) {
        self.duringDraftSaveButton = [[UIButton alloc]initWithFrame:CGRectMake(0,
                                                                           view.frame.size.height/duringDraftSaveButtonPointY,
                                                                           view.frame.size.width,
                                                                           view.frame.size.height/duringDraftSaveButtonHeight)];
        [self.duringDraftSaveButton setTitle:topTitle forState:UIControlStateNormal];
        [self.duringDraftSaveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.duringDraftSaveButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.duringDraftSaveButton setBackgroundImage:backImage forState:UIControlStateHighlighted];
        self.duringDraftSaveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.duringDraftSaveButton.titleLabel.numberOfLines = 2;
        self.duringDraftSaveButton.titleEdgeInsets = (UIEdgeInsets){0,self.duringConsiderationButton.imageEdgeInsets.left + 15,0,10};
        [view addSubview:self.duringDraftSaveButton];
    }
    
    if (downTitle != nil) {
        
        self.duringConsiderationButton = [[UIButton alloc]initWithFrame:CGRectMake(0,
                                                                               view.frame.size.height/duringConsiderationButtonPointY,
                                                                               view.frame.size.width,
                                                                               view.frame.size.height/duringConsiderationButtonHeight)];
        [self.duringConsiderationButton setTitle:downTitle forState:UIControlStateNormal];
        [self.duringConsiderationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.duringConsiderationButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.duringConsiderationButton setBackgroundImage:backImage forState:UIControlStateHighlighted];
        self.duringConsiderationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.duringConsiderationButton.titleLabel.numberOfLines = 2;
        self.duringConsiderationButton.titleEdgeInsets = (UIEdgeInsets){0,self.duringConsiderationButton.imageEdgeInsets.left + 15,0,10};
        [view addSubview:self.duringConsiderationButton];
    }
    self.duringDraftSaveButton.exclusiveTouch = YES;
    self.duringConsiderationButton.exclusiveTouch = YES;
    
    if (self = [self initWithParentView:[[UIApplication sharedApplication].delegate window].rootViewController.view view:view]) {
        // nothing to see here
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat centerX = self.dismissButtonRight ? _contentView.right : _contentView.left;
    _dismissButton.center = CGPointMake(centerX -15, _contentView.top +15);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        self.center = CGPointMake(CGRectGetMidX(newSuperview.frame), CGRectGetMidY(newSuperview.frame));
    }
}


- (void)orientationDidChangeNotification:(NSNotification*)notification {
    if ([self isVisible]) {
        [self performSelector:@selector(updateSubviews) withObject:nil afterDelay:0.3f];
    }
}


- (void)updateSubviews {
    self.hidden = YES;
    
    // get new screenshot after orientation
    [_blurView removeFromSuperview]; _blurView = nil;
    if (_controller) {
        _blurView = [[RNNBlurView alloc] initWithCoverView:_controller.view];
        _blurView.alpha = 1.f;
        [_controller.view insertSubview:_blurView belowSubview:self];
        
    }
    else if(_parentView) {
        _blurView = [[RNNBlurView alloc] initWithCoverView:_parentView];
        _blurView.alpha = 1.f;
        [_parentView insertSubview:_blurView belowSubview:self];
        
    }
    
    self.hidden = NO;
    
    _contentView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    _dismissButton.center = _contentView.origin;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)show {
    [self showWithDuration:kBlurDefaultDuration delay:0 options:kNilOptions completion:NULL];
}


- (void)showWithDuration:(CGFloat)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options completion:(void (^)(void))completion {
    self.animationDuration = duration;
    self.animationDelay = delay;
    self.animationOptions = options;
    _completion = [completion copy];
    
    [self performSelector:@selector(delayedShow) withObject:nil afterDelay:kBlurDefaultDelay];
}


- (void)delayedShow {
    if (! self.isVisible) {
        if (! self.superview) {
            if (_controller) {
                self.frame = (CGRect){CGPointZero, _controller.view.bounds.size.width, _controller.view.bounds.size.height};
                [_controller.view addSubview:self];
            }
            else if(_parentView) {
                self.frame = (CGRect){CGPointZero, _parentView.bounds.size.width, _parentView.bounds.size.height};
                
                [_parentView addSubview:self];
            }
            self.top = 0;
        }
        
        if (_controller) {
            _blurView = [[RNNBlurView alloc] initWithCoverView:_controller.view];
            _blurView.alpha = 0.f;
            self.frame = (CGRect){CGPointZero, _controller.view.bounds.size.width, _controller.view.bounds.size.height};
            
            [_controller.view insertSubview:_blurView belowSubview:self];
        }
        else if(_parentView) {
            _blurView = [[RNNBlurView alloc] initWithCoverView:_parentView];
            _blurView.alpha = 0.f;
            self.frame = (CGRect){CGPointZero, _parentView.bounds.size.width, _parentView.bounds.size.height};
            
            [_parentView insertSubview:_blurView belowSubview:self];
        }
        
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
        [UIView animateWithDuration:self.animationDuration animations:^{
            _blurView.alpha = 1.f;
            self.alpha = 1.f;
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, 1.f);
        } completion:^(BOOL finished) {
            if (finished) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kBlurDidShowNotification object:nil];
                self.isVisible = YES;
                if (_completion) {
                    _completion();
                }
            }
        }];
        
    }
    
}


- (void)hide {
    [self hideWithDuration:kBlurDefaultDelay delay:0 options:kNilOptions completion:self.defaultHideBlock];
}

- (void)duringDraftSaveButtonTapped:(UIButton*)button {
    
    [self hideWithDuration:kBlurDefaultDelay delay:0 options:kNilOptions completion:self.topButtonTappedBlock];
}

- (void)duringConsiderationButtonTapped:(UIButton*)button {
    
    [self hideWithDuration:kBlurDefaultDelay delay:0 options:kNilOptions completion:self.downButtonTappedBlock];
}



- (void)hideWithDuration:(CGFloat)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options completion:(void (^)(void))completion {
    if (self.isVisible) {
        [UIView animateWithDuration:duration
                              delay:delay
                            options:options
                         animations:^{
                             self.alpha = 0.f;
                             _blurView.alpha = 0.f;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [_blurView removeFromSuperview];
                                 _blurView = nil;
                                 [self removeFromSuperview];
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:kBlurDidHidewNotification object:nil];
                                 self.isVisible = NO;
                                 if (completion) {
                                     completion();
                                 }
                             }
                         }];
    }
}

-(void)hideCloseButton:(BOOL)hide {
    [_dismissButton setHidden:hide];
}

@end

#pragma mark - RNNBlurView

@implementation RNNBlurView {
    UIView *_coverView;
}

- (id)initWithCoverView:(UIView *)view {
    if (self = [super initWithFrame:(CGRect){CGPointZero, view.bounds.size.width, view.bounds.size.height}]) {
        _coverView = view;
        UIImage *blur = [_coverView screenshot];
        self.image = [blur boxblurImageWithBlur:kDefaultBlurScale];
    }
    return self;
}


@end



#pragma mark - UIView + Sizes

@implementation UIView (Sizes)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end

#pragma mark - RNNCloseButton

@implementation RNNCloseButton

- (id)init{
    if(!(self = [super initWithFrame:(CGRect){0, 0, 42, 42}])){
        return nil;
    }
    
    self.accessibilityTraits |= UIAccessibilityTraitButton;
    [self setTitle:@"×" forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:23]];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    return self;
}

@end

#pragma mark - UIView + Screenshot

@implementation UIView (Screenshot)

- (UIImage*)screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    if( [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)] ){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    }else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    image = [UIImage imageWithData:imageData];
    
    return image;
}

@end

#pragma mark - UIImage + Blur

@implementation UIImage (Blur)

-(UIImage *)boxblurImageWithBlur:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer2);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}


@end
