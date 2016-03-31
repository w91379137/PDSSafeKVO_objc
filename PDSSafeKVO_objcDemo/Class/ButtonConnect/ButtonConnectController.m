//
//  ViewController.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "ButtonConnectController.h"

@interface ButtonConnectController ()
{
    IBOutlet UILabel *titleStringLabel;
    IBOutlet UILabel *titleStringLabel2;
}

@end

@implementation ButtonConnectController

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
    
    NSString *noButton = @"No Select Button";
    
    {//複雜寫法
        PDSKVOOption *kvoOption = [[PDSKVOOption alloc] init];
        
        {//排除相同text修改 可有可無
            NSString *modifyID = NSStringFromSelector(@selector(text));
            [kvoOption.nonNullInfoDict setObject:modifyID
                                          forKey:ModifyIDKey];
            [titleStringLabel removeSafeObserverWithModifyID:modifyID];
        }
        
        {//設定動作
            weakMake(titleStringLabel,label)
            
            [kvoOption setActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                
                UIButton *button =
                maybe([object valueForKey:keyPath], UIButton);
                
                label.text =
                button ? NSStringFromCGRect([button convertRect:button.frame
                                                         toView:button.window]) : noButton;
                
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
                      button ? [button titleForState:UIControlStateNormal] : noButton;
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
