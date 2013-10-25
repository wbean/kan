//
//  MainViewController.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "MainViewController.h"
#import "../ASIHTTPRequest/ASIHTTPRequest.h"
#import "../JSONKit/JSONKit.h"
#import "DataAccess.h"
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize photos = _photos;
@synthesize aoView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil kid:kid title:title
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _kid = kid;
        self->page=1;
        self.title = title;
    }
    return self;
}
//初始化
- (void)viewDidLoad
{ 
    [super viewDidLoad];
    DataAccess *dataAccess= [[DataAccess alloc]init];
    NSMutableArray *dataArray = [dataAccess getDateArray:_kid page:self->page];

    self.aoView = [[AOWaterView alloc]initWithDataArray:dataArray delegate:self];
    self.aoView.delegate = self;
    [self.view addSubview:self.aoView];
    //[self setFooterView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)setFooterView{
    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.aoView.contentSize.height, self.aoView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.aoView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.aoView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.aoView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark-
#pragma mark force to show the refresh headerView

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }

	// overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//刷新调用的方法
-(void)refreshView{
    DataAccess *dataAccess= [[DataAccess alloc]init];
    NSMutableArray *dataArray = [dataAccess getDateArray:_kid page:self->page];
    [self.aoView refreshView:dataArray];
    [self testFinishedLoadData];

}
//加载调用的方法
-(void)getNextPageView{
    self->page=self->page+1;
    [self removeFooterView];
    DataAccess *dataAccess= [[DataAccess alloc]init];
    NSMutableArray *dataArray = [dataAccess getDateArray:_kid page:self->page];

    [self.aoView getNextPage:dataArray];
    [self testFinishedLoadData];
   
}-(void)testFinishedLoadData{

    [self finishReloadingData];
    [self setFooterView];
}
-(void)click:(DataInfo *)data{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    
    NSArray *imgarray = data.mess;
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

}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
}
@end
