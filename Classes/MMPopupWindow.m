//
//  MMPopupWindow.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupWindow.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import "MMPopupView.h"

@interface MMPopupWindow()

@property (nonatomic, strong) UIWindow   *mainWindow;

@property (nonatomic, assign) NSUInteger shownCount;

@property (nonatomic, assign) BOOL       backgroundAnimating;

@property (nonatomic, assign) CGRect     keyboardRect;

@end

@implementation MMPopupWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyKeyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    }
    return self;
}

+ (MMPopupWindow *)sharedWindow
{
    static MMPopupWindow *window;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        window = [[MMPopupWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
    });
    
    return window;
}

- (void)showDimBackground
{
    ++self.shownCount;
    
    if ( self.shownCount > 1 )
    {
        return;
    }
    
    self.hidden = NO;
    self.backgroundAnimating = YES;
    self.mainWindow = [UIApplication sharedApplication].keyWindow;
    [self makeKeyAndVisible];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
        self.backgroundColor = MMHexColor(0x0000007F);
                         
    } completion:^(BOOL finished) {
        
        if ( finished )
        {
            self.backgroundAnimating = NO;
        }
        
    }];
}

- (void)hideDimBackground
{
    --self.shownCount;
    
    if ( self.shownCount > 0 )
    {
        return;
    }
    
    self.backgroundAnimating = YES;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
        self.backgroundColor = MMHexColor(0x00000000);
                         
    } completion:^(BOOL finished) {
        
        if ( finished )
        {
            self.hidden = YES;
            self.backgroundAnimating = NO;
            [self.mainWindow makeKeyWindow];
        }
        
    }];
}

- (void)cacheWindow
{
    self.mainWindow = [UIApplication sharedApplication].keyWindow;
    [self makeKeyAndVisible];
    [self.mainWindow makeKeyWindow];
    
    self.hidden = YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    
    if ( (view == self) && self.touchWildToHide && !self.backgroundAnimating )
    {
        if ( !CGRectContainsPoint(self.keyboardRect, point))
        {
            for ( UIView *v in self.subviews )
            {
                if ( [v isKindOfClass:[MMPopupView class]] )
                {
                    MMPopupView *popupView = (MMPopupView*)v;
                    [popupView hide];
                }
            }
        }
    }
    
    return view;
}

- (void)notifyKeyboardChangeFrame:(NSNotification *)n
{
    NSValue *keyboardBoundsValue = [[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    self.keyboardRect = [keyboardBoundsValue CGRectValue];
}

@end
