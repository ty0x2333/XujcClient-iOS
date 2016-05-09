//
//  EditableAvatarImageViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/5/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "EditableAvatarImageViewModel.h"
#import "OssService.h"

@implementation EditableAvatarImageViewModel

- (RACSignal *)updateAvatarSignalWithImage:(UIImage *)image
{
    return [OssService updateAvatarSignalWithImage:image];
}

@end
