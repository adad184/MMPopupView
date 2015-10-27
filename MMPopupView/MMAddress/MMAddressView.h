//
//  MMAdressView.h
//  MMPopupView
//
//  Created by Jone on 15/10/23.
//  Copyright © 2015年 LJC. All rights reserved.
//

#import "MMPopupView.h"
#import "MMAddressModel.h"

@interface MMAddressView : MMPopupView

@property (nonatomic, copy) void (^selectedAddress)(MMAddress *address);

/**
 *  初始化方法
 *
 *  @param address 初始选中的地址
 *
 *  @return MMAdressView实例
 */
- (instancetype)initWithAddress:(MMAddress *)address;

@end
