//
//  ArticlelistViewController.h
//  kan
//
//  Created by w on 13-6-9.
//  Copyright (c) 2013年 w. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
@interface ArticlelistViewController : UIViewController<MWPhotoBrowserDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSArray *_photos;
    int page;
    NSString * kid;

}
@property(nonatomic,strong) UITableView *table;
@property(nonatomic) NSMutableArray *array;
@property (nonatomic, retain) NSArray *photos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil kid:(NSString *)kid;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
