//
//  ParallaxScrolling.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/10.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <UIKit/UIKit.h>

//參考網站
//https://github.com/mayuur/MJParallaxCollectionView

@interface ParallaxScrollingViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *mainTableView;

@end
