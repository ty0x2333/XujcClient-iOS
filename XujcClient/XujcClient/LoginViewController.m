//
//  ViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 15/10/30.
//  Copyright © 2015年 luckytianyiyan. All rights reserved.
//

#import "LoginViewController.h"
#import "XujcAPI.h"
#import "TyLog_Objc.h"
#import "DynamicData.h"

#import "XujcUser.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#ifdef DEBUG
    self.APIKeyTextField.text = @"swe12023-szyufvxh";
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Response

- (IBAction)onLoginButtonClicked:(id)sender
{
    NSString* apiKey = self.APIKeyTextField.text;
    ResponseSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject){
        TyLogDebug(@"Success Response: %@", responseObject);
        XujcUser *user = [[XujcUser alloc] initWithJSONResopnse:responseObject];
        TyLogDebug(@"User Infomation: %@", [user description]);
        DYNAMIC_DATA.APIKey = apiKey;
        DYNAMIC_DATA.user = user;
        [DYNAMIC_DATA flush];
    };
    ResponseFailureBlock failure = ^(AFHTTPRequestOperation *operation, NSError *error) {
        TyLogFatal(@"Failure:\n\tstatusCode: %ld,\n\tdetail: %@", operation.response.statusCode, error);
    };
    
    [XujcAPI userInfomation:apiKey successBlock:success failureBlock:failure];
}


@end
