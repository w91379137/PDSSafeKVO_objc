//
//  ParallaxScrolling.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/10.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "ParallaxScrollingViewController.h"
#import "ParallaxScrollingTableViewCell.h"

static NSString *cellReuseIdentifier = @"CellReuseIdentifier";

@interface ParallaxScrollingViewController ()

@end

@implementation ParallaxScrollingViewController

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.mainTableView registerClass:[ParallaxScrollingTableViewCell class]
//               forCellReuseIdentifier:cellReuseIdentifier];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"ParallaxScrollingTableViewCell" bundle:nil]
             forCellReuseIdentifier:cellReuseIdentifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

-     (CGFloat)tableView:(UITableView *)tableView
 heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果更換高度 tableView 會壞掉
    //從下往上滑會 逐一更新高度 會瞬移
    //MIN(tableView.contentSize.width / 16 * 9, tableView.frame.size.height);
    CGSize size = [UIScreen mainScreen].bounds.size;
    return MIN(size.width, size.height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParallaxScrollingTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    NSString *name =
    [NSString stringWithFormat:@"image%03ld.jpg", indexPath.row % 2];
    
    cell.bgImageView.image = [UIImage imageNamed:name];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
