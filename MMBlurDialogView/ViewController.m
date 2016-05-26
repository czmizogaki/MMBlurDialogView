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

#import "ViewController.h"
#import "MMBlurDialogView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDemoButton:(id)sender {
    
    MMBlurDialogView *dialogView;
    
    dialogView = [[MMBlurDialogView alloc] initWithView:@"Test"
                                         topButtonTitle:@"Top\nTop"
                                         downButtonTile:@"Down\nDown"
                                              backColor:[UIColor whiteColor]
                                              LineColor:[UIColor colorWithRed:0.7896 green:0.7896 blue:0.7896 alpha:1.0]];
    
    [dialogView.duringDraftSaveButton setBackgroundImage:[UIImage imageNamed:@"homeAlertArow"] forState:UIControlStateNormal];
    [dialogView.duringConsiderationButton setBackgroundImage:[UIImage imageNamed:@"homeAlertArow"] forState:UIControlStateNormal];
    
    dialogView.dismissButtonRight = YES;
    
    dialogView.defaultHideBlock = ^{
        NSLog(@"Code called after the modal view is hidden");
    };
    dialogView.topButtonTappedBlock = ^{
        NSLog(@"CallBack:TopButtn");
    };
    dialogView.downButtonTappedBlock = ^{
        NSLog(@"CallBack:DownButtn");
    };
    
    [dialogView show];
}


@end

