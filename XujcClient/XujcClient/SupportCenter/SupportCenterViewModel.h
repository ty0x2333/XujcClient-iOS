//
//  SupportCenterViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/21.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewCellViewModel.h"

@interface SupportCenterViewModel : NSObject

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (TableViewCellViewModel *)tableViewCellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
