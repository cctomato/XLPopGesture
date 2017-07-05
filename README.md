# XLPopGesture
An UINavigationController's category to enable fullscreen pop gesture in an iOS7+ system style with AOP.

# Overview

![snapshot](/Snapshots/1.gif)

Design ideas come from [FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture) and [MVVMReactiveCocoa](https://github.com/leichunfeng/MVVMReactiveCocoa)

Thanks for sharing.

# Usage

AOP, just add 2 files and no need for any setups, all navigation controllers will be able to use fullscreen pop gesture automatically.

To disable this pop gesture of a view controller:

```objc
viewController.xl_prefersDisablePop = YES;
```

To hidden the navigationBar of a view controller:

```objc
viewController.xl_prefersNavigationBarHidden = YES;
```

To close the Pop effects of a navigationController:

```objc
navigationController.xl_prefersOpenPopEffects = NO;
```

TabbarItem will be hidden when push ViewController,if you do not want this:

```objc
navigationController.xl_prefersHiddenTabBar = NO;
```

# Installation

Use CocoaPods

```ruby
pod 'XLPopGesture'
```

#License

MIT