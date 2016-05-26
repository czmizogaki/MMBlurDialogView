# MMBlurDialogView
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
              )](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-Objective–C-brightgreen.svg?style=flat
             )](https://developer.apple.com/jp/documentation/)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
            )](http://mit-license.org)


## App Image
![Alt Text](https://github.com/Objective-C-MMizogaki/MMBlurDialogView/blob/master/Resouce/dev.gif)  


## With CocoaPods
Just add this line to your podfile.
```
pod 'MMBlurDialogView', '1.1.2'
```

## Manual installation

Super simple. Just drag & drop BlurDialogView.h/.m into your project.

QuartzCore.framework
Accelerate.framework
Additionally in your project, under the Build Phases tab, expand Compile Sources and add MMBlurDialogView.m.


## Usage
The simplest way to get up and running with MMBlurDialogView is to display a default view. Inside of your view controller, write the following code:

``` objective-c
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
```

## Memo
iOS9 correspondence.  
I support that until iPhone4S〜iPhone6S+.  

## Licence
MIT

Created by MMizogaki on 10/3/16.
Copyright (c) 2015 MMizogaki . All rights reserved.
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Author

[MizogakiMasahito](https://github.com/MMizogaki)
