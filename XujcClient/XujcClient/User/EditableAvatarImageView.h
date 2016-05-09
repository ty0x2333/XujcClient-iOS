//
//  EditableAvatarImageView.h
//  XujcClient
//
//  Created by 田奕焰 on 16/5/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AvatarImageView.h"
@class EditableAvatarImageViewModel;

@interface EditableAvatarImageView : AvatarImageView

- (instancetype)initWithViewModel:(EditableAvatarImageViewModel *)viewModel;

@end
