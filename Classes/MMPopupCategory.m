//
//  UIColor+MMPopup.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

@implementation UIColor (MMPopup)

+ (UIColor *) mm_colorWithHex:(NSUInteger)hex {
    
    float r = (hex & 0xff000000) >> 24;
    float g = (hex & 0x00ff0000) >> 16;
    float b = (hex & 0x0000ff00) >> 8;
    float a = (hex & 0x000000ff);
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

@end

@implementation UIImage (MMPopup)

+ (UIImage *) mm_imageWithColor:(UIColor *)color {
    return [UIImage mm_imageWithColor:color Size:CGSizeMake(4.0f, 4.0f)];
}

+ (UIImage *) mm_imageWithColor:(UIColor *)color Size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image mm_stretched];
}

- (UIImage *) mm_stretched
{
    CGSize size = self.size;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(truncf(size.height-1)/2, truncf(size.width-1)/2, truncf(size.height-1)/2, truncf(size.width-1)/2);
    
    return [self resizableImageWithCapInsets:insets];
}

@end

@implementation UIButton (MMPopup)

+ (id) mm_buttonWithTarget:(id)target action:(SEL)sel
{
    id btn = [self buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setExclusiveTouch:YES];
    return btn;
}

@end

@implementation NSString (MMPopup)

- (NSString *)mm_truncateByCharLength:(NSUInteger)charLength
{
    __block NSUInteger length = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              
                              if ( length+substringRange.length > charLength )
                              {
                                  *stop = YES;
                                  return;
                              }
                              
                              length+=substringRange.length;
                          }];
    
    return [self substringToIndex:length];
}

@end


static const void *mm_dimReferenceCountKey      = &mm_dimReferenceCountKey;

static const void *mm_dimBackgroundViewKey      = &mm_dimBackgroundViewKey;
static const void *mm_dimAnimationDurationKey   = &mm_dimAnimationDurationKey;
static const void *mm_dimBackgroundAnimatingKey = &mm_dimBackgroundAnimatingKey;

@interface UIView (MMPopupInner)

@property (nonatomic, assign, readwrite) NSInteger mm_dimReferenceCount;

@end

@implementation UIView (MMPopupInner)

@dynamic mm_dimReferenceCount;


- (NSInteger)mm_dimReferenceCount {
    return [objc_getAssociatedObject(self, mm_dimReferenceCountKey) integerValue];
}

- (void)setMm_dimReferenceCount:(NSInteger)mm_dimReferenceCount
{
    objc_setAssociatedObject(self, mm_dimReferenceCountKey, @(mm_dimReferenceCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation UIView (MMPopup)

@dynamic mm_dimBackgroundView;
@dynamic mm_dimAnimationDuration;
@dynamic mm_dimBackgroundAnimating;

- (UIView *)mm_dimBackgroundView
{
    UIView *dimView = objc_getAssociatedObject(self, mm_dimBackgroundViewKey);
    
    if ( !dimView )
    {
        dimView = [UIView new];
        [self addSubview:dimView];
        [dimView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        dimView.hidden = YES;
        
        self.mm_dimAnimationDuration = 0.3f;
        
        objc_setAssociatedObject(self, mm_dimBackgroundViewKey, dimView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dimView;
}

- (BOOL)mm_dimBackgroundAnimating
{
    return [objc_getAssociatedObject(self, mm_dimBackgroundAnimatingKey) boolValue];
}

- (void)setMm_dimBackgroundAnimating:(BOOL)mm_dimBackgroundAnimating
{
    objc_setAssociatedObject(self, mm_dimBackgroundAnimatingKey, @(mm_dimBackgroundAnimating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)mm_dimAnimationDuration
{
    return [objc_getAssociatedObject(self, mm_dimAnimationDurationKey) doubleValue];
}

- (void)setMm_dimAnimationDuration:(NSTimeInterval)mm_dimAnimationDuration
{
    objc_setAssociatedObject(self, mm_dimAnimationDurationKey, @(mm_dimAnimationDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mm_showDimBackground
{
    ++self.mm_dimReferenceCount;
    
    if ( self.mm_dimReferenceCount > 1 )
    {
        return;
    }
    
    self.mm_dimBackgroundView.hidden = NO;
    self.mm_dimBackgroundAnimating = YES;
    
    if ( [self isKindOfClass:[UIWindow class]] )
    {
        self.hidden = NO;
        [(UIWindow*)self makeKeyAndVisible];
    }
    else
    {
        [self bringSubviewToFront:self.mm_dimBackgroundView];
    }
    
    [UIView animateWithDuration:self.mm_dimAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.mm_dimBackgroundView.backgroundColor = MMHexColor(0x0000007F);
                         
                     } completion:^(BOOL finished) {
                         
                         if ( finished )
                         {
                             self.mm_dimBackgroundAnimating = NO;
                         }
                         
                     }];
}

- (void)mm_hideDimBackground
{
    --self.mm_dimReferenceCount;
    
    if ( self.mm_dimReferenceCount > 0 )
    {
        return;
    }
    
    self.mm_dimBackgroundAnimating = YES;
    [UIView animateWithDuration:self.mm_dimAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.mm_dimBackgroundView.backgroundColor = MMHexColor(0x00000000);
                         
                     } completion:^(BOOL finished) {
                         
                         if ( finished )
                         {
                             self.mm_dimBackgroundView.hidden = YES;
                             self.mm_dimBackgroundAnimating = NO;
                             
                             if ( [self isKindOfClass:[UIWindow class]] )
                             {
                                 self.hidden = YES;
                                 [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
                             }
                         }
                     }];
}

- (void) mm_distributeSpacingHorizontallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    UIView *v0 = spaces[0];
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastSpace.mas_right);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.mas_right);
            make.centerY.equalTo(obj.mas_centerY);
            make.width.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
    }];
    
}

- (void) mm_distributeSpacingVerticallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    UIView *v0 = spaces[0];
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(((UIView*)views[0]).mas_centerX);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastSpace.mas_bottom);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(obj.mas_bottom);
            make.centerX.equalTo(obj.mas_centerX);
            make.height.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

@end

