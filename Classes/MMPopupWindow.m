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

@property (nonatomic, assign) CGRect keyboardRect;

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

- (void)cacheWindow
{
    [self makeKeyAndVisible];
    [[UIApplication sharedApplication].keyWindow makeKeyWindow];
    
    self.hidden = YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    
    if ( (view == self) && self.touchWildToHide && !self.mm_dimBackgroundAnimating )
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
