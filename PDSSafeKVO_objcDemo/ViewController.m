//
//  ViewController.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Init
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - IBAction
- (IBAction)clear:(id)sender
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (IBAction)title:(UIButton *)sender
{
    self.titleString = [sender titleForState:UIControlStateNormal];
}

@end
