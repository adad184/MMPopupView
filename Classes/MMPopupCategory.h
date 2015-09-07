//
//  UIColor+MMPopup.h
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MMPopup)

+ (UIColor *) mm_colorWithHex:(NSUInteger)hex;

@end

@interface UIImage (MMPopup)

+ (UIImage *) mm_imageWithColor:(UIColor *)color;

+ (UIImage *) mm_imageWithColor:(UIColor *)color Size:(CGSize)size;

- (UIImage *) mm_stretched;

@end

@interface UIButton (MMPopup)

+ (id) mm_buttonWithTarget:(id)target action:(SEL)sel;

@end

@interface NSString (MMPopup)

- (NSString *)mm_truncateByCharLength:(NSUInteger)charLength;

@end

@interface UIView (MMPopup)

- (void) mm_distributeSpacingHorizontallyWith:(NSArray*)view;
- (void) mm_distributeSpacingVerticallyWith:(NSArray*)view;

@end