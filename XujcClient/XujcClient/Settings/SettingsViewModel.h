//
//  SettingsViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/18.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsViewModel : NSObject

@property (strong, nonatomic) RACCommand *executeLoginout;
@property (strong, nonatomic) RACCommand *executeCleanCache;

- (NSString *)localizedTextForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (RACCommand *)executeCommandForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
