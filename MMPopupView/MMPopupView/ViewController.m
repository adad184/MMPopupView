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
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UIButton *btnAlert;
@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, strong) UIButton *btnInput;
@property (nonatomic, strong) UIButton *btnSheet;
@property (nonatomic, strong) UIButton *btnPin;
@property (nonatomic, strong) UIButton *btnDate;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
//    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
    MMSheetViewConfig *sheetConfig = [MMSheetViewConfig globalConfig];
    
    alertConfig.defaultTextOK = @"OK";
    alertConfig.defaultTextCancel = @"Cancel";
    alertConfig.defaultTextConfirm = @"Confirm";
    
    sheetConfig.defaultTextCancel = @"Cancel";
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = @[@"Alert - Default", @"Alert - Confirm", @"Alert - Input", @"Sheet - Default", @"Custom - PinView", @"Custom - DateView"][indexPath.row];
    cell.textLabel.textColor = [UIColor redColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelect");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self action:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)action:(NSUInteger)index;
{
    MMPopupItemHandler block = ^(NSInteger index){
        NSLog(@"clickd %@ button",@(index));
    };
    
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        NSLog(@"animation complete");
    };
    
    switch ( index ) {
        case 0:
        {
            NSArray *items =
            @[MMItemMake(@"Done", MMItemTypeNormal, block),
              MMItemMake(@"Save", MMItemTypeHighlight, block),
              MMItemMake(@"Cancel", MMItemTypeNormal, block)];
            
            MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"AlertView"
                                         detail:@"each button take one row if there are more than 2 items"
                                          items:items];
//            alertView.attachedView = self.view;
            alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleLight;
            
            [alertView show];
            
            break;
        }
        case 1:
        {
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"AlertView" detail:@"Confirm Dialog"];
            alertView.attachedView = self.view;
            alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
            [alertView showWithBlock:completeBlock];
            break;
        }
        case 2:
        {
            MMAlertView *alertView = [[MMAlertView alloc] initWithInputTitle:@"AlertView" detail:@"Input Dialog" placeholder:@"Your placeholder" handler:^(NSString *text) {
                NSLog(@"input:%@",text);
            }];
            alertView.attachedView = self.view;
            alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
            alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleExtraLight;
            [alertView showWithBlock:completeBlock];
            
            break;
        }
        case 3:
        {
            NSArray *items =
            @[MMItemMake(@"Normal", MMItemTypeNormal, block),
              MMItemMake(@"Highlight", MMItemTypeHighlight, block),
              MMItemMake(@"Disabled", MMItemTypeDisabled, block)];
            
            MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"SheetView"
                                                                  items:items];
            sheetView.attachedView = self.view;
            sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
            [sheetView showWithBlock:completeBlock];
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
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MMDateView hideAll];
            });
            
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
