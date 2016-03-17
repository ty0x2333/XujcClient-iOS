//
//  PersonalHeaderView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/16.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalHeaderView.h"
#import <MMSheetView.h>
#import <MMPopupItem.h>
#import "AppUtils.h"

static CGFloat const kAvatarImageViewMarginTop = 10.f;

static CGFloat const kNicknameLabelMarginVertical = 5.f;

static CGFloat const kAvatarImageViewHeight = 100.f;

static CGFloat const kAvatarImageViewCornerRadius = kAvatarImageViewHeight / 2.f;

@interface PersonalHeaderView()

@property (strong, nonatomic) PersonalHeaderViewModel *viewModel;

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nicknameLabel;

@end

@implementation PersonalHeaderView

- (instancetype)initWithFrame:(CGRect)frame andViewModel:(PersonalHeaderViewModel *)viewModel
{
    if (self = [super initWithFrame:frame]) {
        _viewModel = viewModel;
        self.backgroundColor = [UIColor whiteColor];
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = kAvatarImageViewCornerRadius;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        [self addSubview:_avatarImageView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        @weakify(self);
        [tapGestureRecognizer.rac_gestureSignal subscribeNext:^(id x) {
            NSArray *items = @[
                               MMItemMake(NSLocalizedString(@"Take a picture", nil), MMItemTypeNormal, ^(NSInteger index){}),
                               MMItemMake(NSLocalizedString(@"From photo library", nil), MMItemTypeNormal, ^(NSInteger index){
                                   UIViewController *viewController = [AppUtils viewController:self];
                                   
                                   UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
                                   pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                   pickerController.allowsEditing = YES;
                                   
                                   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
                                   [pickerController.rac_imageSelectedSignal subscribeNext:^(NSDictionary *userInfo) {
                                       @strongify(self);
                                       self.avatarImageView.image = userInfo[UIImagePickerControllerEditedImage];
//                                       TyLogDebug(@"userInfo: %@", userInfo);
                                       [[self.viewModel updateAvatarSignalWithImage:self.avatarImageView.image] subscribeNext:^(NSNumber *progress) {
                                           hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
                                           hud.progress = [progress floatValue];
                                       } error:^(NSError *error) {
                                           hud.mode = MBProgressHUDModeText;
                                           hud.detailsLabelText = [error localizedDescription];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [hud hide:YES afterDelay:kErrorHUDShowTime];
                                           });
                                       } completed:^{
                                           hud.mode = MBProgressHUDModeText;
                                           hud.detailsLabelText = NSLocalizedString(@"Upload to complete", nil);
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [hud hide:YES afterDelay:kSuccessHUDShowTime];
                                           });
                                       }];
                                       [pickerController dismissViewControllerAnimated:YES completion:nil];
                                   }];
                                   [viewController presentViewController:pickerController animated:NO completion:nil];
                               })
                               ];
            [[[MMSheetView alloc] initWithTitle:nil items:items] showWithBlock:^(MMPopupView * view, BOOL finished){
                
            }];
        }];
        [_avatarImageView addGestureRecognizer:tapGestureRecognizer];
        
        _nicknameLabel = [[UILabel alloc] init];
        [self addSubview:_nicknameLabel];
        
        [_avatarImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(kAvatarImageViewMarginTop);
            make.centerX.equalTo(self);
            make.width.height.equalTo(@(kAvatarImageViewHeight));
        }];
        
        [_nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(kNicknameLabelMarginVertical);
            make.centerX.equalTo(self.avatarImageView);
        }];
        
        [self makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.nicknameLabel).with.offset(kNicknameLabelMarginVertical);
        }];
        
        RAC(self.nicknameLabel, text) = RACObserve(self.viewModel, nickname);
        
#warning test
        _avatarImageView.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end
