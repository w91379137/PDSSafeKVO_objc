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
#import "LocalizeViewController.h"

static NSString *kTitleKey = @"TitleKey";
static NSString *kClassKey = @"ClassKey";

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
       kClassKey : NSStringFromClass([ButtonConnectController class])}];
    
    [actionArray addObject:
     @{kTitleKey : @"上拉下拉測試",
       kClassKey : NSStringFromClass([PullViewViewController class])}];
    
    [actionArray addObject:
     @{kTitleKey : @"多國語測試",
       kClassKey : NSStringFromClass([LocalizeViewController class])}];
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
    NSString *className =
    maybe(maybe(actionArray[indexPath.row], NSDictionary)[kClassKey], NSString);
    
    Class class = NSClassFromString(className);
    if ([class isSubclassOfClass:[UIViewController class]])
        [self.navigationController pushViewController:[[class alloc] init] animated:YES];
}

@end
