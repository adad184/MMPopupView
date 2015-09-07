MMPopupView
=============
[![Total views](https://sourcegraph.com/api/repos/github.com/adad184/MMPopupView/.counters/views.png)](https://sourcegraph.com/github.com/adad184/MMPopupView)
[![Views in the last 24 hours](https://sourcegraph.com/api/repos/github.com/adad184/MMPopupView/.counters/views-24h.png)](https://sourcegraph.com/github.com/adad184/MMPopupView)
[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/MMPopupView/badge.png)](http://cocoapods.org/?q=MMPopupView)

A basic Pop-Up Kit allows you to easily create Pop-Up view. You can focus on the only view you want to show. 

Besides, it comes with 2 common Pop-Up view, **AlertView* &  **SheetView**. You can easily use & customize it.

![demo](https://github.com/adad184/MMPopupView/blob/master/Images/0.jpg)


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

MMAlertView
===============
**MMAlertView** is based on **MMPopupView**. 

```objc
typedef void(^MMPopupInputHandler)(NSString *text);

@interface MMAlertView : MMPopupView

@property (nonatomic, assign) NSUInteger maxInputLength;    // default is 0. Means no length limit.

- (instancetype) initWithInputTitle:(NSString*)title
                             detail:(NSString*)detail
                        placeholder:(NSString*)inputPlaceholder
                            handler:(MMPopupInputHandler)inputHandler;

- (instancetype) initWithConfirmTitle:(NSString*)title
                               detail:(NSString*)detail;

- (instancetype) initWithTitle:(NSString*)title
                        detail:(NSString*)detail
                         items:(NSArray*)items;
@end
```

**MMAlertViewConfig** is the global configuration of **MMAlertView**, you can fully customize by adjust it.

```obcj
@interface MMAlertViewConfig : NSObject

+ (MMAlertViewConfig*) globalConfig;

@property (nonatomic, assign) CGFloat width;                // Default is 275.
@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 25.
@property (nonatomic, assign) CGFloat cornerRadius;         // Default is 5.

@property (nonatomic, assign) CGFloat titleFontSize;        // Default is 18.
@property (nonatomic, assign) CGFloat detailFontSize;       // Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize;       // Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          // Default is #333333.
@property (nonatomic, strong) UIColor *detailColor;         // Default is #333333.
@property (nonatomic, strong) UIColor *splitColor;          // Default is #CCCCCC.

@property (nonatomic, strong) UIColor *itemNormalColor;     // Default is #333333. effect with MMItemTypeNormal
@property (nonatomic, strong) UIColor *itemHighlightColor;  // Default is #E76153. effect with MMItemTypeHighlight
@property (nonatomic, strong) UIColor *itemPressedColor;    // Default is #EFEDE7.

@property (nonatomic, strong) NSString *defaultTextOK;      // Default is "好".
@property (nonatomic, strong) NSString *defaultTextCancel;  // Default is "取消".
@property (nonatomic, strong) NSString *defaultTextConfirm; // Default is "确定".

@end
```

MMSheetView
===============
**MMSheetView** is based on **MMPopupView**. 


```objc
@interface MMSheetView : MMPopupView

- (instancetype) initWithTitle:(NSString*)title
                         items:(NSArray*)items;

@end
```

**MMSheetViewConfig** is the global configuration of **MMAlertView**, you can fully customize by adjust it.

```objc
@interface MMSheetViewConfig : NSObject

+ (MMSheetViewConfig*) globalConfig;

@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 19.

@property (nonatomic, assign) CGFloat titleFontSize;        // Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize;       // Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          // Default is #666666.
@property (nonatomic, strong) UIColor *splitColor;          // Default is #CCCCCC.

@property (nonatomic, strong) UIColor *itemNormalColor;     // Default is #333333. effect with MMItemTypeNormal
@property (nonatomic, strong) UIColor *itemDisableColor;    // Default is #CCCCCC. effect with MMItemTypeDisabled
@property (nonatomic, strong) UIColor *itemHighlightColor;  // Default is #E76153. effect with MMItemTypeHighlight
@property (nonatomic, strong) UIColor *itemPressedColor;    // Default is #EFEDE7.

@property (nonatomic, strong) NSString *defaultTextCancel;  // Default is "取消"

@end
```
	

Changelog
===============

v1.0  first version
