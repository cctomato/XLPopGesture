// The MIT License (MIT)
//
// Copyright (c) 2016-2017 cctomato ( https://github.com/cctomato )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <UIKit/UIKit.h>

@interface UIViewController (XLPopGesture)
/**
 *A snapshot view based on the contents of the current view
 **/
@property (nonatomic, strong) UIView *xl_snapshot;
/**
 *Default to NO, if you want to hidden navgationBar, Set YES
**/
@property (nonatomic, assign) BOOL xl_prefersNavigationBarHidden;
/**
 *Default to NO, if you want to disable the pop gesture, Set YES
 **/
@property (nonatomic, assign) BOOL xl_prefersDisablePop;

@end

@interface UINavigationController (XLPopGesture)
/**
 *A view controller is able to control navigation bar's appearance by itself,
 *rather than a global way, checking "xl_prefersNavigationBarHidden" property.
 *Default to YES, disable it if you don't want so.
 **/
@property (nonatomic, assign) BOOL xl_viewControllerBasedNavigationBarAppearanceEnabled;
/**
 *The gesture recognizer that actually handles interactive pop.
 **/
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *xl_popRecoginzer;
/**
 *Default to YES, if you do not want to hidden tabBar, set NO
 **/
@property (nonatomic, assign) BOOL xl_prefersHiddenTabBar;
/**
 *Default to YES, if you do not want to close the Pop effects, set NO
 **/
@property (nonatomic, assign) BOOL xl_prefersOpenPopEffects;
/**
 *The gesture percentage
 **/
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *xl_interactivePopTransition;
@end
