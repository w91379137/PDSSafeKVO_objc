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
    {
        weakMake(titleStringLabel,label)
        [titleStringLabel addSafeKVOObject:self
                                SourcePath:NSStringFromSelector(@selector(button))
                                  ModifyID:NSStringFromSelector(@selector(text))
                               ActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                                   label.text =
                                   NSStringFromCGRect(maybe([object valueForKey:keyPath], UIButton).frame);
                                   NSLog(@"Object Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)object));
                               }];
    }
    
    {
        weakMake(titleStringLabel2,label)
        [titleStringLabel2 addSafeKVOObject:self
                                 SourcePath:NSStringFromSelector(@selector(button))
                                   ModifyID:NSStringFromSelector(@selector(text))
                                ActionBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
                                    label.text =
                                    [maybe([object valueForKey:keyPath], UIButton) titleForState:UIControlStateNormal];
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

- (IBAction)title:(UIButton *)sender
{
    self.button = sender;
}

@end
