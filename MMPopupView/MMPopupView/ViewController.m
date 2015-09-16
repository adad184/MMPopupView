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
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btnAlert   = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnInput   = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSheet   = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnPin     = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnDate    = [UIButton buttonWithType:UIButtonTypeCustom];

    NSArray *arrayButton = @[self.btnAlert, self.btnConfirm, self.btnInput, self.btnSheet, self.btnPin, self.btnDate];
    NSArray *arrayTitle  = @[@"Alert - Default", @"Alert - Confirm", @"Alert - Input", @"Sheet - Default", @"Custom - PinView", @"Custom - DateView"];
    
    for ( int i = 0 ; i < arrayButton.count; ++i )
    {
        UIButton *btn = arrayButton[i];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(100 + i*60);
            make.size.mas_equalTo(CGSizeMake(180, 40));
        }];
        
        [btn setTitle:arrayTitle[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        btn.tag = i;
    }
    
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
    MMSheetViewConfig *sheetConfig = [MMSheetViewConfig globalConfig];
    
    alertConfig.defaultTextOK = @"OK";
    alertConfig.defaultTextCancel = @"Cancel";
    alertConfig.defaultTextConfirm = @"Confirm";
    
    sheetConfig.defaultTextCancel = @"Cancel";
}

- (void)actionButton:(UIButton*)btn
{
    MMPopupItemHandler block = ^(NSInteger index){
        NSLog(@"clickd %@ button",@(index));
    };
    
    MMPopupBlock completeBlock = ^(MMPopupView *popupView){
        NSLog(@"animation complete");
    };
    
    switch ( btn.tag) {
        case 0:
        {
            NSArray *items =
            @[MMItemMake(@"Done", MMItemTypeNormal, block),
              MMItemMake(@"Save", MMItemTypeHighlight, block),
              MMItemMake(@"Cancel", MMItemTypeNormal, block)];
            
            MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"AlertView"
                                         detail:@"each button take one row if there are more than 2 items"
                                          items:items];
            alertView.attachedView = self.view;
            
            [alertView show];
            
            break;
        }
        case 1:
        {
            [[[MMAlertView alloc] initWithConfirmTitle:@"AlertView" detail:@"Confirm Dialog"] showWithBlock:completeBlock];
            break;
        }
        case 2:
        {
            [[[MMAlertView alloc] initWithInputTitle:@"AlertView" detail:@"Input Dialog" placeholder:@"Your placeholder" handler:^(NSString *text) {
                NSLog(@"input:%@",text);
            }] showWithBlock:completeBlock];
            break;
        }
        case 3:
        {
            NSArray *items =
            @[MMItemMake(@"Normal", MMItemTypeNormal, block),
              MMItemMake(@"Highlight", MMItemTypeHighlight, block),
              MMItemMake(@"Disabled", MMItemTypeDisabled, block)];
            
            [[[MMSheetView alloc] initWithTitle:@"SheetView"
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
