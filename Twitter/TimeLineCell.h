//
//  TimeLineCell.h
//  TwitterlClient
//
//  Created by Bhagyashree Shekhawat on 2/1/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* name;
@property (nonatomic, weak) IBOutlet UILabel* handle;
@property (nonatomic, weak) IBOutlet UILabel* timestamp;
@property (nonatomic, weak) IBOutlet UILabel* tweet;
@property (nonatomic, weak) IBOutlet UIImageView* photo;

@property (nonatomic, weak) IBOutlet UIButton* favorite;
@property (nonatomic, weak) IBOutlet UIButton* retweet;
@property (nonatomic, weak) IBOutlet UIButton* reply;
@end
