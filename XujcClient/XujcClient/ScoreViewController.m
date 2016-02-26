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
#import "ScoreTableViewCell.h"

static NSString* const kTableViewCellIdentifier = @"TableViewCellIdentifier";

@interface ScoreViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<XujcScore *> *scores;

@end

@implementation ScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"成绩查询";
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ScoreTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    
    _scores = [[NSMutableArray alloc] init];
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
    return _scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[UITableViewCell alloc] initWithStyle:<#(UITableViewCellStyle)#> reuseIdentifier:<#(nullable NSString *)#>]
    ScoreTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    XujcScore *score = _scores[indexPath.row];
    cell.textLabel.text = score.courseName;
    cell.score = score.score;
    return cell;
}

- (void)requestScores
{
    [_scores removeAllObjects];
#warning test
    [XujcAPI scores:DYNAMIC_DATA.APIKey termId:@"20142" successBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *scoreDatas = responseObject;
        [scoreDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XujcScore *xujcScore = [[XujcScore alloc] initWithJSONResopnse:obj];
            TyLogDebug(@"%@", xujcScore);
            [_scores addObject:xujcScore];
        }];
        [_tableView reloadData];
    } failureBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TyLogFatal(@"Failure:\n\tstatusCode: %ld,\n\tdetail: %@", ((NSHTTPURLResponse *)(task.response)).statusCode, error);
    }];
}

@end
