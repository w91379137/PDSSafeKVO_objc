//
//  ViewController.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    IBOutlet UILabel *titleStringLabel;
    IBOutlet UILabel *titleStringLabel2;
}

@end

@implementation ViewController

#pragma mark - Init
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"VC Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)self));
    [self registerKVO];
}

- (void)registerKVO
{
    //一般寫法 請看 UIButton+Connect.m
    
    {//複雜寫法
        weakMake(titleStringLabel,label)
        PDSKVOOption *kvoOption = [[PDSKVOOption alloc] init];
        
        {//排除相同text修改 可有可無
            NSString *modifyID = NSStringFromSelector(@selector(text));
            [kvoOption.nonNullInfoDict setObject:modifyID
                                          forKey:ModifyIDKey];
            [titleStringLabel removeSafeObserverWithModifyID:modifyID];
        }
        
        {//設定動作
            [kvoOption setActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                
                UIButton *button =
                maybe([object valueForKey:keyPath], UIButton);
                
                label.text =
                button ? NSStringFromCGRect(button.frame) : @"No Button";
                
                NSLog(@"Object Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)object));
            }];
        }
        
        [self addSafeObserver:titleStringLabel
                   forKeyPath:NSStringFromSelector(@selector(button))
                PDSKVOOptions:kvoOption];
    }
    
    {//簡便寫法
        weakMake(titleStringLabel2,label)
        [self addSafeObserver:titleStringLabel2
                   forKeyPath:NSStringFromSelector(@selector(button))
               UniqueModifyID:NSStringFromSelector(@selector(text))
                  ActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                      
                      UIButton *button =
                      maybe([object valueForKey:keyPath], UIButton);
                      
                      label.text =
                      button ? [button titleForState:UIControlStateNormal] : @"No Button";
                  }];
    }
}

#pragma mark - IBAction
- (IBAction)clear:(id)sender
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (IBAction)buttonAction:(UIButton *)sender
{
    self.button = (self.button == sender) ? nil : sender;
}

@end
