MMPopupView
=============
[![CocoaPods](https://img.shields.io/cocoapods/v/MMPopupView.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/p/MMPopupView.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/l/MMPopupView.svg)]()

[中文介绍](http://adad184.com/2015/09/08/opensource-mmpopupview/)

A basic Pop-Up Kit allows you to easily create Pop-Up view. You can focus on the only view you want to show.

Besides, it comes with 2 common Pop-Up view, **MMAlertView** &  **MMSheetView**. You can easily use & customize it.

![demo](https://github.com/adad184/MMPopupView/blob/master/Images/0.jpg)

or you can check the demo video below(click the image).

[![youtube](https://github.com/adad184/MMPopupView/blob/master/Images/7.jpg)](https://www.youtube.com/watch?v=GiesTuusKCY)


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
```objc
//MMAlertView
NSArray *items =
@[MMItemMake(@"Done", MMItemTypeNormal, block),
  MMItemMake(@"Save", MMItemTypeHighlight, block),
  MMItemMake(@"Cancel", MMItemTypeNormal, block)];

[[[MMAlertView alloc] initWithTitle:@"AlertView"
                             detail:@"each button take one row if there are more than 2 items"
                              items:items]
 showWithBlock:completeBlock];

//MMSheetView
NSArray *items =
@[MMItemMake(@"Normal", MMItemTypeNormal, block),
  MMItemMake(@"Highlight", MMItemTypeHighlight, block),
  MMItemMake(@"Disabled", MMItemTypeDisabled, block)];

[[[MMSheetView alloc] initWithTitle:@"SheetView"
              items:items] showWithBlock:completeBlock];
```

MMPopupView
===============

MMPopupView is a basic Pop-Up view designed to be subclassed.
It provide 3 kind of animations(alert, sheet, drop), or you can provide your own animation by override the **showAnimation** and **hideAnimation**.

```objc
typedef NS_ENUM(NSUInteger, MMPopupType) {
    MMPopupTypeAlert,
    MMPopupTypeSheet,
    MMPopupTypeCustom,
};

@class MMPopupView;

typedef void(^MMPopupBlock)(MMPopupView *);
typedef void(^MMPopupCompletionBlock)(MMPopupView *, BOOL);

@interface MMPopupView : UIView

@property (nonatomic, assign, readonly) BOOL           visible;             // default is NO.

@property (nonatomic, strong          ) UIView         *attachedView;       // default is MMPopupWindow. You can attach MMPopupView to any UIView.

@property (nonatomic, assign          ) MMPopupType    type;                // default is MMPopupTypeAlert.
@property (nonatomic, assign          ) NSTimeInterval animationDuration;   // default is 0.3 sec.
@property (nonatomic, assign          ) BOOL           withKeyboard;        // default is NO. When YES, alert view with be shown with a center offset (only effect with MMPopupTypeAlert).

@property (nonatomic, copy            ) MMPopupCompletionBlock   showCompletionBlock; // show completion block.
@property (nonatomic, copy            ) MMPopupCompletionBlock   hideCompletionBlock; // hide completion block

@property (nonatomic, copy            ) MMPopupBlock   showAnimation;       // custom show animation block.
@property (nonatomic, copy            ) MMPopupBlock   hideAnimation;       // custom hide animation block.

/**
 *  override this method to show the keyboard if with a keyboard
 */
- (void) showKeyboard;

/**
 *  override this method to hide the keyboard if with a keyboard
 */
- (void) hideKeyboard;


/**
 *  show the popup view
 */
- (void) show;

/**
 *  show the popup view with completiom block
 *
 *  @param block show completion block
 */
- (void) showWithBlock:(MMPopupBlock)block;

/**
 *  hide the popup view
 */
- (void) hide;

/**
 *  hide the popup view with completiom block
 *
 *  @param block hide completion block
 */
- (void) hideWithBlock:(MMPopupBlock)block;

@end

/**
 *  hide all popupview with current class, eg. [MMAlertview hideAll];
 */
+ (void) hideAll;
```

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

```objc
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
v1.7    Add blur effect.

```objc
@interface UIView (MMPopup)
@property (nonatomic, strong, readonly ) UIView            *mm_dimBackgroundBlurView;
@property (nonatomic, assign           ) BOOL              mm_dimBackgroundBlurEnabled;
@property (nonatomic, assign           ) UIBlurEffectStyle mm_dimBackgroundBlurEffectStyle;
@end
```
e.g.
```objc
alertView.attachedView = self.view;
alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleLight;
```

v1.6    Add '+ hideAll' method, improve code struct.

v1.5.3  Fixed touch problem with `touchWildToHide`

v1.5.2  Fixed touch problem when there are scrollviews in custom view

v1.5.1  Fixed showing problem

v1.5    Fixed rotation problem

v1.4    Adjust animation easing function. Rebuild the demo.(thx to @yoavlt)

v1.3    Bug fixed

v1.2    Now you could know whether MMPopupView is visible by using:

```
@property (nonatomic, assign, readonly) BOOL           visible;             // default is NO.
```


v1.1  Now you can attached MMPopupView to any UIView you want by using:

```objc
@property (nonatomic, strong          ) UIView         *attachedView; // default is MMPopupWindow. You can attach MMPopupView to any UIView.
```

v1.0  first version
