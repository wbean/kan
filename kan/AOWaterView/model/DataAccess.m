//
//  DataAccess.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//
#import "MainViewController.h"
#import "../../ASIHTTPRequest/ASIHTTPRequest.h"
#import "../../JSONKit/JSONKit.h"
#import "DataAccess.h"
#import "DataInfo.h"
@implementation DataAccess

//获取基础联系列表
-(NSMutableArray *)getDateArray:kid page:(int)page{
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wbean.sinaapp.com/api/kan.php?type=article&page=%d&count=20&kid=%@",page,kid]]];
    [request setRequestMethod:@"GET"];
    
    [request setTimeOutSeconds:30];
    [request startSynchronous];
    NSError *error = [request error];
    NSMutableArray *imageList = [[NSMutableArray alloc]init];
    if (!error) {
        int length = [[request responseString]length];
        const unsigned char *response = [[request responseString]UTF8String];
        JSONDecoder *jd = [[JSONDecoder alloc] init];
        NSArray *dicArray = [jd objectWithUTF8String:response length:length];
        
        for (NSDictionary *vdic in dicArray) {
            DataInfo *data=[[DataInfo alloc]init];
            NSNumber *hValue=[vdic objectForKey:@"height"];

            data.height= hValue.floatValue;
            NSNumber *wValue=[vdic objectForKey:@"width"];
        
            data.width= wValue.floatValue;
            data.url = [vdic objectForKey:@"coverimg"];
            data.title=[vdic objectForKey:@"title"];
            data.mess=[vdic objectForKey:@"content"];
            [imageList addObject:data];
        }
        
    }
    return imageList;

}
@end
