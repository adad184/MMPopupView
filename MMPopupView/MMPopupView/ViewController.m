//
//  ViewController.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "MMPopupItem.h"
#import "MMAlertView.h"
#import "MMSheetView.h"
#import "MMPinView.h"
#import "MMDateView.h"
#import "MMPopupWindow.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *btnAlert;
@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, strong) UIButton *btnInput;
@property (nonatomic, strong) UIButton *btnSheet;
@property (nonatomic, strong) UIButton *btnPin;
@property (nonatomic, strong) UIButton *btnDate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.btnAlert   = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnInput   = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSheet   = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnPin     = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnDate    = [UIButton buttonWithType:UIButtonTypeCustom];

    NSArray *arrayButton = @[self.btnAlert, self.btnConfirm, self.btnInput, self.btnSheet, self.btnPin, self.btnDate];
    NSArray *arrayTitle  = @[@"Alert - Default", @"Alert - Confirm", @"Alert - Input", @"Sheet - Default", @"Custom - PinView", @"Custom - DateView"];
    [arrayButton enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = (UIButton*)obj;
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(100 + idx*60);
            make.size.mas_equalTo(CGSizeMake(180, 40));
        }];
        
        [btn setTitle:arrayTitle[idx] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        btn.tag = idx;
    }];
    
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
}

- (void)actionButton:(UIButton*)btn
{
    MMPopupItemHandler block = ^(NSInteger index){
        NSLog(@"你按了第%@个按钮",@(index));
    };
    
    MMPopupBlock completeBlock = ^(MMPopupView *popupView){
        NSLog(@"动画结束");
    };
    
    switch ( btn.tag) {
        case 0:
        {
            NSArray *items =
            @[MMItemMake(@"保存", MMItemTypeHighlight, block),
              MMItemMake(@"确定", MMItemTypeHighlight, block),
              MMItemMake(@"取消", MMItemTypeNormal, block)];
            
            [[[MMAlertView alloc] initWithTitle:@"测试" detail:@"自定义事件" items:items] showWithBlock:completeBlock];
            break;
        }
        case 1:
        {
            [[[MMAlertView alloc] initWithConfirmTitle:@"测试" detail:@"确认框"] showWithBlock:completeBlock];
            break;
        }
        case 2:
        {
            [[[MMAlertView alloc] initWithInputTitle:@"测试" detail:@"输入框" placeholder:@"输入您的用户名" handler:^(NSString *text) {
                NSLog(@"你输入的是:%@",text);
            }] showWithBlock:completeBlock];
            break;
        }
        case 3:
        {
            NSArray *items =
            @[MMItemMake(@"取消", MMItemTypeNormal, block),
              MMItemMake(@"保存", MMItemTypeHighlight, block),
              MMItemMake(@"退出", MMItemTypeDisabled, block)];
            
            [[[MMSheetView alloc] initWithTitle:@"测试"
                                          items:items] showWithBlock:completeBlock];
            break;
        }
        case 4:
        {
            MMPinView *pinView = [MMPinView new];
            
            [pinView showWithBlock:completeBlock];
            
            break;
        }
        case 5:
        {
            MMDateView *dateView = [MMDateView new];
            
            [dateView showWithBlock:completeBlock];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
