//
//  MainViewController.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/31.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "MainViewController.h"
#import "ButtonConnectController.h"
#import "PullViewViewController.h"

static NSString *kTitleKey = @"TitleKey";
static NSString *kBlockKey = @"BlockKey";

@interface MainViewController ()
{
    NSMutableArray *actionArray;
}

@end

@implementation MainViewController

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    actionArray = [NSMutableArray array];
    [actionArray addObject:
     @{kTitleKey : @"按鈕聯動系統",
       kBlockKey : ^{
        
        ButtonConnectController *vc =
        [[ButtonConnectController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }}];
    [actionArray addObject:
     @{kTitleKey : @"上拉下拉測試",
       kBlockKey : ^{
        
        PullViewViewController *vc =
        [[PullViewViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }}];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return actionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    
    cell.textLabel.text =
    maybe(actionArray[indexPath.row], NSDictionary)[kTitleKey];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    void (^action)(void) =
    maybe(actionArray[indexPath.row], NSDictionary)[kBlockKey];
    if (action) action();
}

@end
