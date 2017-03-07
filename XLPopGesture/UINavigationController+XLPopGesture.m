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

#import "UINavigationController+XLPopGesture.h"
#import <objc/runtime.h>

@interface XLPopGestureDelegate : NSObject <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation XLPopGestureDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    UIViewController *topViewController = [self.navigationController.viewControllers lastObject];
    if (topViewController.xl_prefersDisablePop) {
        return NO;
    }
    
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}

@end

@interface XLViewControllerAnimatedTransitioningDelegate : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation operation;

@property (nonatomic, weak) UIViewController *fromViewController;

@property (nonatomic, weak) UIViewController *toViewController;

- (instancetype)initWithNavigationControllerOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end

@implementation XLViewControllerAnimatedTransitioningDelegate

- (instancetype)initWithNavigationControllerOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    self = [super init];
    if (self) {
        self.operation = operation;
        self.fromViewController = fromViewController;
        self.toViewController = toViewController;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (self.operation == UINavigationControllerOperationPush) {
        [[transitionContext containerView] addSubview:fromViewController.xl_snapshot];
        fromViewController.view.hidden = YES;
        
        CGRect frame = [transitionContext finalFrameForViewController:toViewController];
        toViewController.view.frame = CGRectOffset(frame, CGRectGetWidth(frame), 0);
        [[transitionContext containerView] addSubview:toViewController.view];
        
        [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            fromViewController.xl_snapshot.alpha = 0.0;
            fromViewController.xl_snapshot.frame = CGRectInset(fromViewController.view.frame, 20, 20);
            toViewController.view.frame = CGRectOffset(toViewController.view.frame, -CGRectGetWidth(toViewController.view.frame), 0);
        } completion:^(BOOL finished) {
            fromViewController.view.hidden = NO;
            [fromViewController.xl_snapshot removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    } else if (self.operation == UINavigationControllerOperationPop) {
        [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor blackColor];
        
        [fromViewController.view addSubview:fromViewController.xl_snapshot];
        
        BOOL tabBarHidden = fromViewController.tabBarController.tabBar.hidden;
        
        fromViewController.navigationController.navigationBar.hidden = YES;
        fromViewController.tabBarController.tabBar.hidden = YES;
        
        toViewController.xl_snapshot.alpha = 0.5;
        toViewController.xl_snapshot.transform = CGAffineTransformMakeScale(0.95, 0.95);
        
        UIView *toViewWrapperView = [[UIView alloc] initWithFrame:[transitionContext containerView].bounds];
        [toViewWrapperView addSubview:toViewController.view];
        toViewWrapperView.hidden = YES;
        
        [[transitionContext containerView] addSubview:toViewWrapperView];
        [[transitionContext containerView] addSubview:toViewController.xl_snapshot];
        [[transitionContext containerView] bringSubviewToFront:fromViewController.view];
        
        [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, CGRectGetWidth(fromViewController.view.frame), 0);
            toViewController.xl_snapshot.alpha = 1.0;
            toViewController.xl_snapshot.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
            toViewController.navigationController.navigationBar.hidden = NO;
            toViewController.tabBarController.tabBar.hidden = tabBarHidden;
            [fromViewController.xl_snapshot removeFromSuperview];
            [toViewController.xl_snapshot removeFromSuperview];
            [toViewWrapperView removeFromSuperview];
            if (![transitionContext transitionWasCancelled]) {
                for (UIView *subView in toViewWrapperView.subviews) {
                    [[transitionContext containerView] addSubview:subView];
                }
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end

@interface XLPopNavgationDelegate : NSObject<UINavigationControllerDelegate>

@end

@implementation XLPopNavgationDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(XLViewControllerAnimatedTransitioningDelegate *)animationController
{
    return animationController.fromViewController.navigationController.xl_interactivePopTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (fromVC.navigationController.xl_interactivePopTransition) {
        return [[XLViewControllerAnimatedTransitioningDelegate alloc] initWithNavigationControllerOperation:operation fromViewController:fromVC toViewController:toVC];
    }
    return nil;
}

@end

typedef void (^XLViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (XLPrivate)

@property (nonatomic, copy) XLViewControllerWillAppearInjectBlock xl_willAppearInjectBlock;

@end

@implementation UIViewController (XLPrivate)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(xl_viewWillAppear:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    Method disOriginalMethod = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    Method disSwizzledMethod = class_getInstanceMethod(self, @selector(xl_viewWillDisappear:));
    method_exchangeImplementations(disOriginalMethod, disSwizzledMethod);
}

- (void)xl_viewWillDisappear:(BOOL)animated
{
    [self xl_viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController]) {
        self.xl_snapshot = [self.navigationController.view snapshotViewAfterScreenUpdates:NO];
    }
}

- (void)xl_viewWillAppear:(BOOL)animated
{
    [self xl_viewWillAppear:animated];
    
    if (self.xl_willAppearInjectBlock) {
        self.xl_willAppearInjectBlock(self, animated);
    }
}

- (XLViewControllerWillAppearInjectBlock)xl_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXl_willAppearInjectBlock:(XLViewControllerWillAppearInjectBlock)xl_willAppearInjectBlock
{
    objc_setAssociatedObject(self, @selector(xl_willAppearInjectBlock), xl_willAppearInjectBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UINavigationController (XLPopGesture)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(xl_pushViewController:animated:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)xl_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!self.delegate) {
        self.delegate = self.xl_popTransitionDelegate;
    }
    
    UIViewController *lastController = [self.viewControllers lastObject];
    if (lastController.tabBarController) {
        lastController.xl_snapshot = [lastController.tabBarController.view snapshotViewAfterScreenUpdates:NO];
        [viewController setHidesBottomBarWhenPushed:YES];
    } else {
        if (lastController.navigationController) {
            lastController.xl_snapshot = [lastController.navigationController.view snapshotViewAfterScreenUpdates:NO];
        } else {
            lastController.xl_snapshot = [lastController.view snapshotViewAfterScreenUpdates:NO];
        }
    }
    
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.xl_popRecoginzer]) {
        
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.xl_popRecoginzer];
        
        self.xl_popRecoginzer.delegate = self.xl_popGestureDelegate;
        [self.xl_popRecoginzer addTarget:self action:@selector(handlePopRecognizer:)];
        
        self.interactivePopGestureRecognizer.enabled = NO;
        
    }
    
    [self xl_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    [self xl_pushViewController:viewController animated:animated];
}

- (void)xl_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.xl_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    XLViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.xl_prefersNavigationBarHidden animated:animated];
        }
    };
    
    appearingViewController.xl_willAppearInjectBlock = block;
    UIViewController *disapperingViewController = self.viewControllers.lastObject;
    if (disapperingViewController && !disapperingViewController.xl_willAppearInjectBlock) {
        disapperingViewController.xl_willAppearInjectBlock = block;
    }
}

- (void)handlePopRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGFloat progress = [recognizer translationInView:recognizer.view].x / [UIScreen mainScreen].bounds.size.width;
    progress = MIN(1.0, MAX(0.0, progress));

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.xl_interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self popViewControllerAnimated:YES];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.xl_interactivePopTransition updateInteractiveTransition:progress];
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if (progress > 0.2) {
            [self.xl_interactivePopTransition finishInteractiveTransition];
        } else {
            [self.xl_interactivePopTransition cancelInteractiveTransition];
        }
        self.xl_interactivePopTransition = nil;
    }
}

- (UIPanGestureRecognizer *)xl_popRecoginzer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return panGestureRecognizer;
}

- (XLPopNavgationDelegate *)xl_popTransitionDelegate
{
    XLPopNavgationDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[XLPopNavgationDelegate alloc] init];

        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return delegate;
}

- (XLPopGestureDelegate *)xl_popGestureDelegate
{
    XLPopGestureDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[XLPopGestureDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return delegate;
}

- (BOOL)xl_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.xl_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setXl_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enable
{
    SEL key = @selector(xl_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPercentDrivenInteractiveTransition *)xl_interactivePopTransition
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXl_interactivePopTransition:(UIPercentDrivenInteractiveTransition *)interactivePopTransition
{
    objc_setAssociatedObject(self, @selector(xl_interactivePopTransition), interactivePopTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (XLPopGesture)

- (BOOL)xl_prefersDisablePop
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setXl_prefersDisablePop:(BOOL)disable
{
    objc_setAssociatedObject(self, @selector(xl_prefersDisablePop), @(disable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xl_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setXl_prefersNavigationBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(xl_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)xl_snapshot
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXl_snapshot:(UIView *)snapshot
{
    objc_setAssociatedObject(self, @selector(xl_snapshot), snapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
