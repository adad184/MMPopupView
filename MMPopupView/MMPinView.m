//
//  MMPinView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPinView.h"
#import "MMPopupItem.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import "MMPopupWindow.h"
#import <Masonry/Masonry.h>

@interface MMPinView()

@property (nonatomic, strong) UIView      *backView;

@property (nonatomic, strong) UILabel     *lblStatus;
@property (nonatomic, strong) UILabel     *lblPhone;

@property (nonatomic, strong) UIView      *numberView;
@property (nonatomic, strong) NSArray     *numberArray;

@property (nonatomic, strong) UIButton    *btnCountDown;

@property (nonatomic, strong) UITextField *tfPin;

@property (nonatomic, strong) UIButton    *btnClose;

@property (nonatomic, assign) BOOL        pinLocked;
@property (nonatomic, strong) NSString    *pinLockValue;

@property (nonatomic, strong) NSDate      *dateCountdown;
@property (nonatomic, assign) NSUInteger  nCountdown;

@end

@implementation MMPinView

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeCustom;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(240, 200));
        }];
        
        self.withKeyboard = YES;
        
        self.backView = [UIView new];
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.backView.layer.cornerRadius = 5.0f;
        self.backView.clipsToBounds = YES;
        self.backView.backgroundColor = [UIColor whiteColor];
        
        self.btnClose = [UIButton mm_buttonWithTarget:self action:@selector(actionClose)];
        [self.backView addSubview:self.btnClose];
        [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.backView).insets(UIEdgeInsetsMake(0, 0, 0, 5));
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [self.btnClose setTitle:@"Close" forState:UIControlStateNormal];
        [self.btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnClose.titleLabel.font = [UIFont systemFontOfSize:14];
        
        self.lblStatus = [UILabel new];
        [self.backView addSubview:self.lblStatus];
        [self.lblStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.backView).insets(UIEdgeInsetsMake(0, 19, 0, 19));
            make.height.equalTo(@50);
        }];
        self.lblStatus.textColor = MMHexColor(0x333333FF);
        self.lblStatus.font = [UIFont boldSystemFontOfSize:17];
        self.lblStatus.text = @"You Pin Code";
        self.lblStatus.textAlignment = NSTextAlignmentCenter;
        
        UIView *split = [UIView new];
        [self.backView addSubview:split];
        [split mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.backView);
            make.bottom.equalTo(self.lblStatus.mas_bottom);
            make.height.mas_equalTo(MM_SPLIT_WIDTH);
        }];
        
        self.lblPhone = [UILabel new];
        [self.backView addSubview:self.lblPhone];
        [self.lblPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.backView).insets(UIEdgeInsetsMake(0, 19, 0, 19));
            make.top.equalTo(self.lblStatus.mas_bottom).offset(10);
        }];
        self.lblPhone.numberOfLines = 0;
        self.lblPhone.textAlignment = NSTextAlignmentCenter;
        self.lblPhone.font = [UIFont systemFontOfSize:14];
        self.lblPhone.textColor = MMHexColor(0x999999FF);
        [self.lblPhone setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        [self.lblPhone setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        self.lblPhone.text = @"The Code was sent to\n186 8877 8877";
        
        self.btnCountDown = [UIButton mm_buttonWithTarget:self action:@selector(actionResend)];
        [self.backView addSubview:self.btnCountDown];
        [self.btnCountDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.backView).insets(UIEdgeInsetsMake(0, 19, 0, 19));
            make.bottom.equalTo(self.backView.mas_bottom).offset(-20);
        }];
        self.btnCountDown.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.btnCountDown.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnCountDown setTitleColor:MMHexColor(0x999999FF) forState:UIControlStateDisabled];
        [self.btnCountDown setTitleColor:MMHexColor(0xE76153FF) forState:UIControlStateNormal];
        [self.btnCountDown setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        [self.btnCountDown setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        self.numberView = [UIView new];
        [self.backView addSubview:self.numberView];
        [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.lessThanOrEqualTo(self.lblPhone.mas_bottom);
            make.bottom.greaterThanOrEqualTo(self.btnCountDown.mas_top);
            make.centerX.equalTo(self.backView);
            make.width.equalTo(@150);
        }];
        [self.numberView setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        [self.numberView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        self.numberArray = @[[UILabel new],[UILabel new],[UILabel new],[UILabel new]];
        
        for ( UILabel *label in self.numberArray )
        {
            [self.numberView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.numberView);
                make.width.equalTo(@30);
            }];
            
            label.font = [UIFont boldSystemFontOfSize:40];
            label.textColor = MMHexColor(0xE76153FF);
            label.text = @"_";
        }
        [self.numberView mm_distributeSpacingHorizontallyWith:self.numberArray];
        
        self.tfPin = [UITextField new];
        [self addSubview:self.tfPin];
        self.tfPin.keyboardType = UIKeyboardTypeNumberPad;
        [self sendSubviewToBack:self.tfPin];
        
        [self startCountDown];
    }
    
    return self;
}

- (void)startCountDown
{
//    [self stopCountDown];
//    
//    self.nCountdown = 30;
//    
//    self.btnCountDown.enabled = NO;
//    
//    [self checkCountDown];
}

- (void)touchwildToHideHandler{
    
    NSLog(@"66666");
}

- (void)stopCountDown
{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkCountDown) object:nil];
}

- (void)checkCountDown
{
    if ( self.nCountdown == 0 )
    {
        self.btnCountDown.enabled = YES;
        [self.btnCountDown setTitle:@"Resent" forState:UIControlStateNormal];
    }
    else
    {
        NSString *text = [NSString stringWithFormat:@"Receive in %@ secs", [@(self.nCountdown) stringValue]];
        
        [self.btnCountDown setTitle:text forState:UIControlStateDisabled];
        
        --self.nCountdown;
        
        [self performSelector:@selector(checkCountDown) withObject:nil afterDelay:1 inModes:@[NSRunLoopCommonModes]];
    }
}

- (void)actionClose
{
    [self hide];
}

- (void)actionResend
{
    [self startCountDown];
}

- (void)showKeyboard
{
    [self.tfPin becomeFirstResponder];
}

- (void)hideKeyboard
{
    [self.tfPin resignFirstResponder];
}

@end
