MMPopupView
=============
[![Total views](https://sourcegraph.com/api/repos/github.com/adad184/MMPopupView/.counters/views.png)](https://sourcegraph.com/github.com/adad184/MMPopupView)
[![Views in the last 24 hours](https://sourcegraph.com/api/repos/github.com/adad184/MMPopupView/.counters/views-24h.png)](https://sourcegraph.com/github.com/adad184/MMPopupView)
[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/MMPopupView/badge.png)](http://cocoapods.org/?q=MMPopupView)

A basic Pop-Up Kit allows you to easily create Pop-Up view. You can focus on the only view you want to show. 

Besides, it comes with 2 common Pop-Up view, **AlertView* &  **SheetView**. You can easily use & customize it.

![demo](https://github.com/adad184/MMPopupView/blob/master/Images/0.gif)


Installation
============

The preferred way of installation is via [CocoaPods](http://cocoapods.org). Just add

```ruby
pod 'MMPopupView'
```

and run `pod install`. It will install the most recent version of MMPopupView.

If you would like to use the latest code of MMPopupView use:

```ruby
pod 'MMPopupView', :head
```

Usage
===============

If you want to create your own Pop-Up view,simply you only need to subclass from **MMPopupView**.

```objc

@interface YourCustomView : MMPopupView

@end

```

after you customize it, you can simply use it.

```objc


[YourCustomView show];
[YourCustomView showWithBlock:completionBlock];

[YourCustomView hide];
[YourCustomView hideWithBlock:completionBlock];

```

===============



	

Changelog
===============

v1.0  you can custom or simply use it by

```objc

@interface MMParallaxCell : UITableViewCell

@property (nonatomic, strong) UIImageView *parallaxImage;

@property (nonatomic, assign) CGFloat parallaxRatio; //ratio of cell height, should between [1.0f, 2.0f], default is 1.5f;

@end
```


