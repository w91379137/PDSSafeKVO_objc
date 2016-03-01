//
//  UILabel+bug.h
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (bug)

@property (nonatomic, strong) IBInspectable NSString *listenKey;
@property (nonatomic, weak) IBOutlet id delegate;


@end
