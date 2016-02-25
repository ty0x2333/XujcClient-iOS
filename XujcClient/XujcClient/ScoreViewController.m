//
//  ScoreViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScoreViewController.h"
#import "XujcAPI.h"
#import "DynamicData.h"
#import "XujcScore.h"

static NSString* const kTableViewCellIdentifier = @"TableViewCellIdentifier";

@interface ScoreViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"成绩查询";
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
#warning test
    [self requestScores];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.frame = [self.view bounds];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[UITableViewCell alloc] initWithStyle:<#(UITableViewCellStyle)#> reuseIdentifier:<#(nullable NSString *)#>]
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = @"课程名称";
    cell.detailTextLabel.text = @"分数";
    return cell;
}

- (void)requestScores
{
#warning test
    [XujcAPI scores:DYNAMIC_DATA.APIKey termId:@"20142" successBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *scoreDatas = responseObject;
        [scoreDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XujcScore *xujcScore = [[XujcScore alloc] initWithJSONResopnse:obj];
            TyLogDebug(@"%@", xujcScore);
        }];
    } failureBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TyLogFatal(@"Failure:\n\tstatusCode: %ld,\n\tdetail: %@", ((NSHTTPURLResponse *)(task.response)).statusCode, error);
    }];
}

@end
