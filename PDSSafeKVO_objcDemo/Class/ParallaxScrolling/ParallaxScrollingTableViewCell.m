//
//  ParallaxScrollingTableViewCell.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/10.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "ParallaxScrollingTableViewCell.h"

@interface ParallaxScrollingTableViewCell()

@property(nonatomic, weak) UITableView *tableView;

@end

@implementation ParallaxScrollingTableViewCell

#pragma mark -
- (UITableView *)tryTableView
{
    id view = [self superview];
    while (view && ![view isKindOfClass:[UITableView class]]) {
        view = [view superview];
    }
    return view;
}

#pragma mark - OverWrite
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.tableView = [self tryTableView];
}

#pragma mark - Setter / Getter
- (void)setTableView:(UITableView *)tableView
{
    if (_tableView == tableView) return;
    
    _tableView = tableView;
    self.bgImageView.alpha = tableView ? 1 : 0;
    
    weakSelfMake(weakSelf);
    
    [tableView addSafeObserver:self
                    forKeyPath:NSStringFromSelector(@selector(contentOffset))
                UniqueModifyID:@"ParallaxScrolling" //會使之前的被移除
                   ActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                       [weakSelf adjustBgImageView];
                   }];
}

#pragma mark - Reload
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self adjustBgImageView];
}

- (void)adjustBgImageView
{
    if (!self.tableView) return;
    
    //影像高 - cell高
    float canShiftHeight =
    150 / 2.0; //請手動輸入 self.bgImageView.frame 可能是錯的
    //(self.bgImageView.frame.size.height - self.frame.size.height) / 2;
    
    //(cell底 - contentOffset.y) / tableView高
    float bottom =
    self.frame.origin.y + self.frame.size.height;
    
    float multiple =
    MAX(0, bottom - self.tableView.contentOffset.y) /
    MAX(1, self.tableView.frame.size.height);
    multiple = MIN(multiple, 1);
    multiple -= 0.5;
    //multiple 0.5 ~ -0.5
    
    //NSLog(@"%f",multiple);
    [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageView.superview.mas_centerY).offset(canShiftHeight * multiple);
    }];
}

@end
