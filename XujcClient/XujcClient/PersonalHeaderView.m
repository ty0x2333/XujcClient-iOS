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
#import <UIImageView+WebCache.h>
#import "AvatarImageView.h"

static CGFloat const kAvatarImageViewMarginTop = 10.f;

static CGFloat const kNicknameLabelMarginVertical = 5.f;

static CGFloat const kAvatarImageViewHeight = 100.f;

@interface PersonalHeaderView()

@property (strong, nonatomic) PersonalHeaderViewModel *viewModel;

@property (strong, nonatomic) AvatarImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nicknameLabel;

@end

@implementation PersonalHeaderView

- (instancetype)initWithFrame:(CGRect)frame andViewModel:(PersonalHeaderViewModel *)viewModel
{
    if (self = [super initWithFrame:frame]) {
        _viewModel = viewModel;
        self.backgroundColor = [UIColor whiteColor];
        _avatarImageView = [[AvatarImageView alloc] init];
        _avatarImageView.userInteractionEnabled = YES;
        [self addSubview:_avatarImageView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        @weakify(self);
        [tapGestureRecognizer.rac_gestureSignal subscribeNext:^(id x) {
            NSArray *items = @[
                               MMItemMake(NSLocalizedString(@"Take a picture", nil), MMItemTypeNormal, ^(NSInteger index){
                                   [self p_presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                               }),
                               MMItemMake(NSLocalizedString(@"From photo library", nil), MMItemTypeNormal, ^(NSInteger index){
                                   [self p_presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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
            make.width.equalTo(@(kAvatarImageViewHeight));
        }];
        
        [_nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(kNicknameLabelMarginVertical);
            make.centerX.equalTo(self.avatarImageView);
        }];
        
        [self makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.nicknameLabel).with.offset(kNicknameLabelMarginVertical);
        }];
        
        RAC(self.nicknameLabel, text) = RACObserve(self.viewModel, nickname);
        [RACObserve(self.viewModel, avater) subscribeNext:^(NSString *avatarURL) {
            @strongify(self);
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        }];
    }
    return self;
}

- (void)p_presentImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIViewController *viewController = [AppUtils viewController:self];
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = sourceType;
    pickerController.allowsEditing = YES;
    
    RACSignal *imageSelectedSignal = pickerController.rac_imageSelectedSignal;
    @weakify(self);
    [imageSelectedSignal subscribeNext:^(NSDictionary *userInfo) {
        @strongify(self);
        self.avatarImageView.image = userInfo[UIImagePickerControllerEditedImage];
        //                                       TyLogDebug(@"userInfo: %@", userInfo);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
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
    } completed:^{
        [pickerController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [viewController presentViewController:pickerController animated:NO completion:nil];
}

@end
