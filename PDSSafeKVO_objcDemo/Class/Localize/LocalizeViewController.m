//
//  LocalizeViewController.m
//  PDSSafeKVO_objcDemo
//
//  Created by w91379137 on 2016/4/1.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "LocalizeViewController.h"
#import "UILabel+Language.h"
#import "LanguageCenter.h"

typedef NS_ENUM(NSUInteger, LocalizeViewSection) {
    LocalizeViewSectionDemo,
    LocalizeViewSectionSelect,
    LocalizeViewSectionEnd,
};

static NSString *kNameKey = @"NameKey";
static NSString *kLanguageCodeKey = @"LanguageCodeKey";

@interface LocalizeViewController ()
{
    NSMutableArray *languageArray;
}

@end

@implementation LocalizeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    languageArray = [NSMutableArray array];
    
    [languageArray addObject:
     @{kNameKey : @"Code"}];
    
    [languageArray addObject:
     @{kNameKey : @"English",
       kLanguageCodeKey : @"en"}];
    
    [languageArray addObject:
     @{kNameKey : @"Traditional Chinese#2",
       kLanguageCodeKey : @"zh-tw"}];
    
    [languageArray addObject:
     @{kNameKey : @"Korean",
       kLanguageCodeKey : @"ko"}];
    
    [languageArray addObject:
     @{kNameKey : @"Japanese",
       kLanguageCodeKey : @"ja"}];
    
    [languageArray addObject:
     @{kNameKey : @"German",
       kLanguageCodeKey : @"de"}];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return LocalizeViewSectionEnd;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == LocalizeViewSectionDemo) return 1;
    if (section == LocalizeViewSectionSelect) return languageArray.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == LocalizeViewSectionDemo) {
        return self.cell;
    }
    
    if (indexPath.section == LocalizeViewSectionSelect) {
        
        UITableViewCell *cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
        
        NSString *name = maybe(languageArray[indexPath.row], NSDictionary)[kNameKey];
        NSString *languageCode = maybe(languageArray[indexPath.row], NSDictionary)[kLanguageCodeKey];
        
        {
            NSMutableString *allText = [NSMutableString string];
            
            //以該語言 顯示
            [allText appendFormat:@"%@",
             [LanguageCenter translationOfString:name
                                    LanguageCode:languageCode]];
            
            //翻譯 顯示
            [allText appendFormat:@" ($%@$)",name];
            
            cell.textLabel.localText = allText;
        }
        
        cell.detailTextLabel.text =
        maybe(languageArray[indexPath.row], NSDictionary)[kLanguageCodeKey];
        
        return cell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@""];
}

#pragma mark - UITableViewDelegate
- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [LanguageCenter sharedInstance].currentLanguageCode =
    maybe(languageArray[indexPath.row], NSDictionary)[kLanguageCodeKey];
}

@end
