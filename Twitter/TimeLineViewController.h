//
//  TimeLineViewController.h
//  TwitterlClient
//
//  Created by Bhagyashree Shekhawat on 1/31/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,retain) UIRefreshControl *refreshControl NS_AVAILABLE_IOS(6_0);
-(void)getTimeline:(int)count sinceId:(int)sinceId maxId:(int)maxId success:(void(^)(NSArray *statuses))success;
-(void)reload;
@end
