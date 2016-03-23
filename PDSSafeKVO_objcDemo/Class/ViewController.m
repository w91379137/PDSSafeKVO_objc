//
//  ViewController.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/3/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "ViewController.h"
#import "PDSSafeKVO_objc.h"

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
    {
        weakMake(titleStringLabel,label)
        PDSKVOOption *kvoOption = [[PDSKVOOption alloc] init];
        
        {
            NSString *modifyID = NSStringFromSelector(@selector(text));
            [kvoOption.nonNullInfoDict setObject:modifyID
                                          forKey:ModifyIDKey];
            [titleStringLabel removeSafeObserverWithModifyID:modifyID];//排除相同text修改
            [kvoOption setActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                
                label.text =
                NSStringFromCGRect(maybe([object valueForKey:keyPath], UIButton).frame);
                
                NSLog(@"Object Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)object));
            }];
        }
        
        [self addSafeObserver:titleStringLabel
                   forKeyPath:NSStringFromSelector(@selector(button))
                PDSKVOOptions:kvoOption];
    }
    
    {
        weakMake(titleStringLabel2,label)
        PDSKVOOption *kvoOption = [[PDSKVOOption alloc] init];
        
        {
            NSString *modifyID = NSStringFromSelector(@selector(text));
            [kvoOption.nonNullInfoDict setObject:modifyID
                                          forKey:ModifyIDKey];
            [titleStringLabel2 removeSafeObserverWithModifyID:modifyID];//排除相同text修改
            
            [kvoOption setActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                
                label.text =
                [maybe([object valueForKey:keyPath], UIButton) titleForState:UIControlStateNormal];
            }];
        }
        
        [self addSafeObserver:titleStringLabel2
                   forKeyPath:NSStringFromSelector(@selector(button))
                PDSKVOOptions:kvoOption];
    }
}

#pragma mark - IBAction
- (IBAction)clear:(id)sender
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    [self removeSafeObserver:titleStringLabel
                  forKeyPath:NSStringFromSelector(@selector(button))];
}

- (IBAction)title:(UIButton *)sender
{
    self.button = sender;
}

@end
