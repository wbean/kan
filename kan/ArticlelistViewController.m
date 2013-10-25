//
//  ArticlelistViewController.m
//  kan
//
//  Created by w on 13-6-9.
//  Copyright (c) 2013年 w. All rights reserved.
//

#import "ArticlelistViewController.h"
#import "ASIHTTPRequest/ASIHTTPRequest.h"
#import "JSONKit/JSONKit.h"

@interface ArticlelistViewController ()

@end

@implementation ArticlelistViewController
@synthesize table;
@synthesize array;
@synthesize photos = _photos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil kid:(NSString *)kid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->kid=kid;
        self->page=1;
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wbean.sinaapp.com/api/kan.php?type=article&page=1&count=20&kid=%@",kid]]];
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
        self.table = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        
        [self.table setDelegate:self];
        [self.table setDataSource:self];
        [self.table setAllowsSelection:YES];
        
        [self.view addSubview:self.table];
        
        self.title=@"文章列表";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:@selector(refreashTable)];
        
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
    return 100	;
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
    NSString *name = [dic objectForKey:@"title"];
    NSString *imgstr =[dic objectForKey:@"coverimg"];
    // Configure the cell.
    cell.textLabel.text=name;
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgstr]]];
    cell.imageView.image = img;
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        int row = indexPath.row;
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        MWPhoto *photo;
        
        NSArray *imgarray = [[self.array objectAtIndex:row] objectForKey:@"content"];
        for (NSString * imgstr in imgarray) {
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imgstr]]];
        }
        
        self.photos = photos;
        
        // Create browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = YES;
        //browser.wantsFullScreenLayout = NO;
        //[browser setInitialPageIndex:2];
        
        // Show
        [self.navigationController pushViewController:browser animated:YES];
                
        
        // Deselect
        [self.table deselectRowAtIndexPath:indexPath animated:YES];

    }
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

- (void) refreashTable{
    self->page=self->page + 1;
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wbean.sinaapp.com/api/kan.php?type=article&page=%d&count=20&kid=%@",self->page,self->kid]]];
    [request setRequestMethod:@"GET"];
    
    [request setTimeOutSeconds:30];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        int length = [[request responseString]length];
        const unsigned char *response = [[request responseString]UTF8String];
        JSONDecoder *jd = [[JSONDecoder alloc] init];
        self.array = [jd objectWithUTF8String:response length:length];
        [self.table reloadData];
    }

}

@end
