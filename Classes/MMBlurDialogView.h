/*
 * MMBlurDialogView
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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

extern NSString *_Nonnull const kBlurDidShowNotification;
extern NSString *_Nonnull const kBlurDidHidewNotification;

@interface MMBlurDialogView : UIView

@property(assign, readonly) BOOL isVisible;

@property(nonatomic, strong) UIButton *_Nonnull duringDraftSaveButton;
@property(nonatomic, strong) UIButton *_Nonnull duringConsiderationButton;

@property(nonatomic, assign) CGFloat animationDuration;
@property(nonatomic, assign) CGFloat animationDelay;
@property(nonatomic, assign) UIViewAnimationOptions animationOptions;
@property(nonatomic, assign) BOOL dismissButtonRight;

@property(nonatomic, copy) void (^_Nonnull defaultHideBlock)(void);
@property(nonatomic, copy) void (^_Nonnull topButtonTappedBlock)(void);
@property(nonatomic, copy) void (^_Nonnull downButtonTappedBlock)(void);


- (_Nullable id)initWithViewController:(UIViewController *_Nonnull)viewController
                                  view:(UIView *_Nonnull)view;

- (_Nullable id)initWithParentView:(UIView *_Nonnull)parentView
                              view:(UIView *_Nonnull)view;

- (_Nullable id)initWithView:(NSString* _Nullable)title
              topButtonTitle:(NSString* _Nullable)topTitle
              downButtonTile:(NSString* _Nullable)downTitle
                   backColor:(UIColor* _Nullable)backC
                   LineColor:(UIColor* _Nullable)lineC;


- (void)show;

- (void)showWithDuration:(CGFloat)duration
                   delay:(NSTimeInterval)delay
                 options:(UIViewAnimationOptions)options
              completion:(void (^ _Nullable)(void))completion;

- (void)hide;

- (void)hideWithDuration:(CGFloat)duration
                   delay:(NSTimeInterval)delay
                 options:(UIViewAnimationOptions)options
              completion:(void (^ _Nullable)(void))completion;

- (void)hideCloseButton:(BOOL)hide;


@end