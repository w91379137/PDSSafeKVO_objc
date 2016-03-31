//
//  LocalizeViewController.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalizeViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableViewCell *cell;

@end
