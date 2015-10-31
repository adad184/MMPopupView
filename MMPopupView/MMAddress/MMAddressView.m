//
//  MMAdressView.m
//  MMPopupView
//
//  Created by Jone on 15/10/23.
//  Copyright © 2015年 LJC. All rights reserved.
//

#import "MMAddressView.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import <Masonry/Masonry.h>


static NSInteger const kComponentCount    = 3;

static NSInteger const kProvinceComponent = 0;
static NSInteger const kCityComponent     = 1;
static NSInteger const kDistrComponent    = 2;

#define COMPONENT_WIDTH  100.0
#define COMPONENT_HEIGHT 30.0
#define FONT_SIZE 11.0


@interface MMAddressView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) MMAddressData *addressModel;

@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, strong) UIPickerView *addressPickerView;

@end

@implementation MMAddressView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self configureViews];
        
        MMAddressData *addressModel = [[MMAddressData alloc] init];
        self.addressModel = addressModel;
    }
    return self;
}

- (instancetype)initWithAddress:(MMAddress *)address
{
    self = [super init];
    
    if (self) {
        
        [self configureViews];
        
        if (address) {
            
            MMAddressData *addressModel = [[MMAddressData alloc] init];
            self.addressModel = addressModel;
            
            NSInteger provinceRow = [addressModel.provinces indexOfObject:address.aProvince];
            
            
            [addressModel reloadCityAndDistrictAtRow:provinceRow];
            NSInteger cityRow = [addressModel.citys indexOfObject:address.aCity];
            
            [addressModel reloadCityAtRow:cityRow];
            NSInteger districtRow = [addressModel.districts indexOfObject:address.aDistrict];
            
            [addressModel reloadDistrictAtRow:districtRow];
            
            [self.addressPickerView selectRow:provinceRow inComponent:kProvinceComponent animated:NO];
            [self.addressPickerView selectRow:cityRow inComponent:kCityComponent animated:NO];
            [self.addressPickerView selectRow:districtRow inComponent:kDistrComponent animated:NO];
            [self.addressPickerView reloadAllComponents];
        }else {
            MMAddressData *addressModel = [[MMAddressData alloc] init];
            self.addressModel = addressModel;
        }

    }
    
    return self;
}

- (void)configureViews
{
    self.type = MMPopupTypeSheet;
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo(216+50);
    }];
    
    self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(actionConfirm)];
    [self addSubview:self.btnConfirm];
    [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 50));
        make.right.top.equalTo(self);
    }];
    [self.btnConfirm setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.btnConfirm setTitleColor:MMHexColor(0xE76153FF) forState:UIControlStateNormal];
    
    self.addressPickerView = [UIPickerView new];
    self.addressPickerView.delegate = self;
    self.addressPickerView.dataSource = self;
    self.addressPickerView.showsSelectionIndicator = YES;
    [self addSubview:self.addressPickerView];
    [self.addressPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
}

#pragma mark - Action

- (void)actionConfirm
{
    MMAddress *selectedAddress = [[MMAddress alloc] initWithProvince:_addressModel.selectedAddress.aProvince
                                                                city:_addressModel.selectedAddress.aCity
                                                            district:_addressModel.selectedAddress.aDistrict];
    if (self.selectedAddress) {
        self.selectedAddress(selectedAddress);
        self.selectedAddress = nil;
    }
    
    [self hide];
}

#pragma mark - Picker view dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return kComponentCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case kProvinceComponent:
            return _addressModel.provinces.count;
            break;
        case kCityComponent:
            return _addressModel.citys.count;
            break;
        case kDistrComponent:
            return _addressModel.districts.count;
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return COMPONENT_WIDTH;
}

#pragma mark - Picker view delegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *componentView = [UILabel new];
    switch (component) {
        case kProvinceComponent:
        {
            componentView = [self viewLabelFormContents:_addressModel.provinces viewForRow:row];
            break;
        }
            
        case kCityComponent:
        {
            componentView = [self viewLabelFormContents:_addressModel.citys viewForRow:row];
            break;
        }
        case kDistrComponent:
        {
            componentView = [self viewLabelFormContents:_addressModel.districts viewForRow:row];
             break;
        }
    }
    
    return componentView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case kProvinceComponent:
        {
            [self.addressModel reloadCityAndDistrictAtRow:row];
            
            [pickerView selectRow:0 inComponent:kCityComponent animated:NO];
            [pickerView reloadComponent:kCityComponent];
            
            [pickerView selectRow:0 inComponent:kDistrComponent animated:NO];
            [pickerView reloadComponent:kDistrComponent];
            
             break;
        }
           
        case kCityComponent:
        {
            [self.addressModel reloadCityAtRow:row];
            
            [pickerView selectRow:0 inComponent:kDistrComponent animated:NO];
            [pickerView reloadComponent:kDistrComponent];
            
             break;
        }

        case kDistrComponent:
        {
            [self.addressModel reloadDistrictAtRow:row];
        }
    }
}

#pragma mark - Private Method

- (UILabel *)viewLabelFormContents:(NSArray *)contents viewForRow:(NSInteger)row
{
    UILabel *componentView = [UILabel new];
    componentView.frame = CGRectMake(0, 0, COMPONENT_WIDTH, COMPONENT_HEIGHT);
    componentView.textAlignment = NSTextAlignmentCenter;
    componentView.font = [UIFont systemFontOfSize:17.0];
    componentView.backgroundColor = [UIColor clearColor];
    componentView.text = [contents objectAtIndex:row];
    
    return componentView;
}
@end
