//
//  MMPopupView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupView.h"
#import "MMPopupWindow.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import <Masonry/Masonry.h>

static NSString * const MMPopupViewHideAllNotification = @"MMPopupViewHideAllNotification";

@implementation MMPopupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.type = MMPopupTypeAlert;
    self.animationDuration = 0.3f;
    self.attachedView = [MMPopupWindow sharedWindow].attachView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHideAll:) name:MMPopupViewHideAllNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMPopupViewHideAllNotification object:nil];
}

- (void)notifyHideAll:(NSNotification*)n
{
    if ( [self isKindOfClass:n.object] )
    {
        [self hide];
    }
}

+ (void)hideAll
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MMPopupViewHideAllNotification object:[self class]];
}

- (BOOL)visible
{
    if ( self.attachedView )
    {
        return !self.attachedView.mm_dimBackgroundView.hidden;
    }
    
    return NO;
}

- (void)setType:(MMPopupType)type
{
    _type = type;
    
    switch (type)
    {
        case MMPopupTypeAlert:
        {
            self.showAnimation = [self alertShowAnimation];
            self.hideAnimation = [self alertHideAnimation];
            break;
        }
        case MMPopupTypeSheet:
        {
            self.showAnimation = [self sheetShowAnimation];
            self.hideAnimation = [self sheetHideAnimation];
            break;
        }
        case MMPopupTypeCustom:
        {
            self.showAnimation = [self customShowAnimation];
            self.hideAnimation = [self customHideAnimation];
            break;
        }
            
        default:
            break;
    }
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    _animationDuration = animationDuration;
    
    self.attachedView.mm_dimAnimationDuration = animationDuration;
}

- (void)show
{
    [self showWithBlock:nil];
}

- (void)showWithBlock:(MMPopupCompletionBlock)block
{
    if ( block )
    {
        self.showCompletionBlock = block;
    }
    
    if ( !self.attachedView )
    {
        self.attachedView = [MMPopupWindow sharedWindow].attachView;
    }
    [self.attachedView mm_showDimBackground];
    
    MMPopupBlock showAnimation = self.showAnimation;
    
    NSAssert(showAnimation, @"show animation must be there");
    
    showAnimation(self);
    
    if ( self.withKeyboard )
    {
        [self showKeyboard];
    }
}

- (void)hide
{
    [self hideWithBlock:nil];
}

- (void)hideWithBlock:(MMPopupCompletionBlock)block
{
    if ( block )
    {
        self.hideCompletionBlock = block;
    }
    
    if ( !self.attachedView )
    {
        self.attachedView = [MMPopupWindow sharedWindow].attachView;
    }
    [self.attachedView mm_hideDimBackground];
    
    if ( self.withKeyboard )
    {
        [self hideKeyboard];
    }
    
    MMPopupBlock hideAnimation = self.hideAnimation;
    
    NSAssert(hideAnimation, @"hide animation must be there");
    
    hideAnimation(self);
}

- (MMPopupBlock)alertShowAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        if ( !self.superview )
        {
            [self.attachedView.mm_dimBackgroundView addSubview:self];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.withKeyboard?-216/2:0));
            }];
            [self layoutIfNeeded];
        }
        
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.layer.transform = CATransform3DIdentity;
                             self.alpha = 1.0f;
                             
                         } completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self, finished);
                             }
                         }];
    };
    
    return block;
}

- (MMPopupBlock)alertHideAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( finished )
                             {
                                 [self removeFromSuperview];
                             }
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)sheetShowAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        if ( !self.superview )
        {
            [self.attachedView.mm_dimBackgroundView addSubview:self];
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.attachedView);
                make.bottom.equalTo(self.attachedView.mas_bottom).offset(self.attachedView.frame.size.height);
            }];
            [self layoutIfNeeded];
        }
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(self.attachedView.mas_bottom).offset(0);
                             }];
                             
                             [self layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)sheetHideAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(self.attachedView.mas_bottom).offset(self.attachedView.frame.size.height);
                             }];
                             
                             [self layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( finished )
                             {
                                 [self removeFromSuperview];
                             }
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)customShowAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        if ( !self.superview )
        {
            [self.attachedView.mm_dimBackgroundView addSubview:self];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, -self.attachedView.bounds.size.height));
            }];
            [self layoutIfNeeded];
        }
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:1.5
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.withKeyboard?-216/2:0));
                             }];
                             
                             [self layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)customHideAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.attachedView.bounds.size.height));
                             }];
                             
                             [self layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             
                             if ( finished )
                             {
                                 [self removeFromSuperview];
                             }
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self, finished);
                             }
                         }];
    };
    
    return block;
}

- (void)showKeyboard
{
    
}

- (void)hideKeyboard
{
    
}

@end
