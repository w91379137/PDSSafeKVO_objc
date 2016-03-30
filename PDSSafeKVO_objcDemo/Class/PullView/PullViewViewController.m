//
//  PullViewViewController.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/31.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PullViewViewController.h"

@interface PullViewViewController ()

@end

@implementation PullViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(0, 1500);
    
    {//topBar
        static float xibTopBarHeight = 60.0f;
        
        weakMake(topBar, view);
        
        PDSKVOOption *option = [[PDSKVOOption alloc] init];
        [option setActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
            if (change[@"new"] && change[@"old"]) {
                
                float newY = maybe(change[@"new"], NSValue).CGPointValue.y;
                float oldY = maybe(change[@"old"], NSValue).CGPointValue.y;
                
                float oldHeight = view.frame.size.height;
                float newHeight = oldHeight + (oldY - newY) / 3; // 3 is speed
                newHeight = MIN( MAX(newHeight, 20), xibTopBarHeight);
                
                if (oldHeight != newHeight) {
                    view.alpha = newHeight / xibTopBarHeight;
                    [view mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@(newHeight));
                    }];
                }
            }
        }];
        
        [scrollView addSafeObserver:topBar
                         forKeyPath:NSStringFromSelector(@selector(contentOffset))
                      PDSKVOOptions:option];
    }
    
    
    {//bottomBar
        static float xibBottomBarHeight = 60.0f;
        
        weakMake(bottomBar, view);
        
        PDSKVOOption *option = [[PDSKVOOption alloc] init];
        [option setActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
            
            if (change[@"new"] && change[@"old"]) {
                
                float newY = maybe(change[@"new"], NSValue).CGPointValue.y;
                float oldY = maybe(change[@"old"], NSValue).CGPointValue.y;
                
                float oldHeight = view.frame.size.height;
                float newHeight = oldHeight - (oldY - newY);
                newHeight = MIN( MAX(newHeight, 0), xibBottomBarHeight);
                
                if (newHeight != oldHeight) {
                    view.alpha = newHeight / xibBottomBarHeight;
                    [view mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@(newHeight));
                    }];
                }
            }
        }];
        
        [scrollView addSafeObserver:bottomBar
                         forKeyPath:NSStringFromSelector(@selector(contentOffset))
                      PDSKVOOptions:option];
    }
}

@end
