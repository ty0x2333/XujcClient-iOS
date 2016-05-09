//
//  EditableAvatarImageView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/5/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "EditableAvatarImageView.h"
#import "EditableAvatarImageViewModel.h"
#import "AppUtils.h"
#import <MMSheetView.h>

@interface EditableAvatarImageView()

@property (nonatomic, strong) EditableAvatarImageViewModel *viewModel;

@end

@implementation EditableAvatarImageView

- (instancetype)initWithViewModel:(EditableAvatarImageViewModel *)viewModel
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        _viewModel = viewModel;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        @weakify(self);
        [tapGestureRecognizer.rac_gestureSignal subscribeNext:^(id x) {
            @strongify(self);
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
        [self addGestureRecognizer:tapGestureRecognizer];
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
        self.image = userInfo[UIImagePickerControllerEditedImage];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
        [[self.viewModel updateAvatarSignalWithImage:self.image] subscribeNext:^(NSNumber *progress) {
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
