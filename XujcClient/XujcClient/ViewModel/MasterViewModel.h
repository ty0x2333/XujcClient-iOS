//
//  MasterViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTabBarViewModel.h"

@interface MasterViewModel : NSObject

@property (copy, readonly, nonatomic) NSString *apiKey;

@property (copy, nonatomic) NSString *xujcKey;

@property (strong, nonatomic) RACSignal *apiKeyChangedSignal;

- (MainTabBarViewModel *)mainTabBarViewModel;

@end
