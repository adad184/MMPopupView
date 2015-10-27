//
//  MMAddressModel.h
//  MMPopupView
//
//  Created by Jone on 15/10/24.
//  Copyright © 2015年 LJC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  城市模型
 */
@interface MMAddress : NSObject

@property (nonatomic, copy) NSString *aProvince;
@property (nonatomic, copy) NSString *aCity;
@property (nonatomic, copy) NSString *aDistrict;

- (instancetype)initWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;

@end



@interface MMAddressModel : NSObject

/**
 * 当前选中的省、市、县列表
 */
@property (nonatomic, readonly) NSArray *provinces;
@property (nonatomic, readonly) NSArray *citys;
@property (nonatomic, readonly) NSArray *districts;

/**
 *  当前选中的省、市、县
 */
@property (nonatomic, readonly) MMAddress *selectedAddress;

/**
 *  滚动省，刷新市、县
 *
 *  @param row 当前省row
 */
- (void)reloadCityAndDistrictAtRow:(NSInteger)row;

/**
 *  滚动市，刷新县
 *
 *  @param row 当前市row
 */
- (void)reloadCityAtRow:(NSInteger)row;

/**
 *  滚动县
 *
 *  @param row 当前县row
 */
- (void)reloadDistrictAtRow:(NSInteger)row;

@end
