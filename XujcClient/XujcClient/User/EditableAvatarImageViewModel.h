//
//  EditableAvatarImageViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/5/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditableAvatarImageViewModel : NSObject

- (RACSignal *)updateAvatarSignalWithImage:(UIImage *)image;

@end
