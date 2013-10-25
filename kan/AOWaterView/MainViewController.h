//
//  MainViewController.h
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "AOWaterView.h"
#import "MWPhotoBrowser.h"
@interface MainViewController : UIViewController
<EGORefreshTableDelegate,UIScrollViewDelegate,imageDelegate,MWPhotoBrowserDelegate>
{
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    NSString * _kid;
    int page;
    //
    BOOL _reloading;
    NSArray *_photos;
}
@property(nonatomic,strong)AOWaterView *aoView;
@property (nonatomic, retain) NSArray *photos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil kid:kid title:title;
@end
