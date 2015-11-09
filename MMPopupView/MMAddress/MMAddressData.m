//
//  MMAddressModel.m
//  MMPopupView
//
//  Created by Jone on 15/10/24.
//  Copyright © 2015年 LJC. All rights reserved.
//

#import "MMAddressData.h"

@implementation MMAddress

- (instancetype)initWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district
{
    self = [super init];
    
    if (self) {
        _aProvince = province;
        _aCity     = city;
        _aDistrict = district;
    }
    
    return self;
}

@end



@interface MMAddressData()

@property (nonatomic, strong) NSDictionary *chinaAddressDict;

@property (nonatomic, readwrite) NSArray *provinces;
@property (nonatomic, readwrite) NSArray *citys;
@property (nonatomic, readwrite) NSArray *districts;

@property (nonatomic, readwrite) MMAddress *selectedAddress;

@end

@implementation MMAddressData

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self configureInitializationData];
    }
    
    return self;
}

- (void)configureInitializationData
{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"china_address" ofType:@"plist"];
    self.chinaAddressDict = [[NSDictionary alloc] initWithContentsOfFile:filePath]; // 获取到地址字典
    
    NSArray *components = [self.chinaAddressDict allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[self.chinaAddressDict objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    self.provinces = [[NSArray alloc] initWithArray: provinceTmp];// 获取初始省列表
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [self.provinces objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[self.chinaAddressDict objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    NSArray *cityKeys = [cityDic allKeys];
    self.citys = [[NSArray alloc] initWithArray:cityKeys]; // 获取初始市列表
    
    
    NSString *selectedCity = [self.citys objectAtIndex: 0];
    NSArray *dictricts = [cityDic objectForKey:selectedCity];
    self.districts = [[NSArray alloc] initWithArray:dictricts]; // 获取选中县
    
    // 初始化选中的地址
    self.selectedAddress           = [[MMAddress alloc] init];
    self.selectedAddress.aProvince = _provinces.firstObject;
    self.selectedAddress.aCity     = _citys.firstObject;
    self.selectedAddress.aDistrict = _districts.firstObject;
}

- (void)reloadCityAndDistrictAtRow:(NSInteger)row
{
    self.selectedAddress.aProvince = _provinces[row];
    
    NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [self.chinaAddressDict objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey:_selectedAddress.aProvince]];
    NSArray *cityArray = [dic allKeys];
    if (cityArray.count == 0) {
        return;
    }
    NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *temp = [dic[index] allKeys];
        [array addObject:temp[0]];
    }
    
    self.citys = [[NSArray alloc] initWithArray:array];
    self.selectedAddress.aCity     = _citys.firstObject;
    
    NSDictionary *cityDic = [dic objectForKey:sortedArray[0]];
    self.districts = [[NSArray alloc] initWithArray: [cityDic objectForKey:self.citys[0]]];
    self.selectedAddress.aDistrict = _districts.firstObject;
}

- (void)reloadCityAtRow:(NSInteger)row
{
    NSString *provinceIndex = [NSString stringWithFormat:@"%ld", (unsigned long)[self.provinces indexOfObject:_selectedAddress.aProvince]];
    NSDictionary *tmp = [NSDictionary dictionaryWithDictionary:[self.chinaAddressDict objectForKey: provinceIndex]];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey:_selectedAddress.aProvince]];
    NSArray *dicKeyArray = [dic allKeys];
    NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey:[sortedArray objectAtIndex:row]]];
    NSArray *cityKeyArray = [cityDic allKeys];
    
    if (cityKeyArray.count == 0) {
        return;
    }
    
    self.districts = [[NSArray alloc] initWithArray: [cityDic objectForKey:cityKeyArray[0]]];
    
    // 更新选中的市、县
    self.selectedAddress.aCity     = cityKeyArray[0];
    self.selectedAddress.aDistrict = _districts.firstObject;
}

- (void)reloadDistrictAtRow:(NSInteger)row
{
    self.selectedAddress.aDistrict = _districts[row]; // 更新选中的县
}
@end
