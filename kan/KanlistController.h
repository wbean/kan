//
//  KanlistController.h
//  kan
//
//  Created by w on 13-6-9.
//  Copyright (c) 2013年 w. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KanlistController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *table;
@property(nonatomic) NSMutableArray *array;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
