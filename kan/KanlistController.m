//
//  KanlistController.m
//  kan
//
//  Created by w on 13-6-9.
//  Copyright (c) 2013年 w. All rights reserved.
//
#define WIDTH_A [UIScreen mainScreen].bounds.size.width
#define HEIGHT_A [UIScreen mainScreen].bounds.size.height

#import "KanlistController.h"
#import "ASIHTTPRequest/ASIHTTPRequest.h"
#import "JSONKit/JSONKit.h"
#import "ArticlelistViewController.h"
#import "MainViewController.h"
#import "UIImageView+WebCache.h"
@interface KanlistController ()

@end

@implementation KanlistController
@synthesize table;
@synthesize array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://wbean.sinaapp.com/api/kan.php?type=kan&page=1&count=100"]];
        [request setRequestMethod:@"GET"];
        
        [request setTimeOutSeconds:30];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            int length = [[request responseString]length];
            const unsigned char *response = [[request responseString]UTF8String];
            JSONDecoder *jd = [[JSONDecoder alloc] init];
            array = [jd objectWithUTF8String:response length:length];
            
        }
        self.table = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, WIDTH_A, HEIGHT_A- 54) style:UITableViewStylePlain];
        
        [self.table setDelegate:self];	
        [self.table setDataSource:self];
        [self.table setAllowsSelection:YES];
        
        [self.view addSubview:self.table];
        
        self.title=@"微刊列表";
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回有多少个Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound) {
        return 100;
    }else{
        return 50;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * showKanInfoCellIdentifier = @"KanInfoCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showKanInfoCellIdentifier];
    if (cell == nil)
    {
        // Create a cell to display an ingredient.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:showKanInfoCellIdentifier];
    }
    int row = indexPath.row;
    NSDictionary *dic = [self.array objectAtIndex:row];
    NSString *name = [dic objectForKey:@"name"];
    //NSString *imgstr =[dic objectForKey:@"img"];
    // Configure the cell.
    cell.textLabel.text=name;
    
    //[cell.imageView setImageWithURL:[NSURL URLWithString:imgstr]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        int row = indexPath.row;
        NSString *kid = [[self.array objectAtIndex:row]objectForKey:@"kid"];
        NSString *title = [[self.array objectAtIndex:row]objectForKey:@"name"];

        MainViewController *ctrl = [[MainViewController alloc] initWithNibName:@"MainViewController_pid" bundle:nil kid:kid title:title];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

@end
