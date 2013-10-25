//
//  DataInfo.h
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataInfo : NSObject
@property float width;
@property float height;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSArray *mess;
@end