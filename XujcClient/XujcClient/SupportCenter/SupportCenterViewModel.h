//
//  SupportCenterViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/21.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewCellViewModel.h"
#import "ServiceProtocolViewModel.h"

@interface SupportCenterViewModel : NSObject

@property (assign, nonatomic) BOOL shakingReportStatus;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (NSString *)versionDescription;

- (TableViewCellViewModel *)tableViewCellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath;

- (ServiceProtocolViewModel *)serviceProtocolViewModel;

@end
