//
//  TweetViewCell.h
//  Twitter
//
//  Created by Bhagyashree Shekhawat on 2/6/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* name;
@property (nonatomic, weak) IBOutlet UILabel* handle;
@property (nonatomic, weak) IBOutlet UILabel* timestamp;
@property (nonatomic, weak) IBOutlet UILabel* tweet;
@property (nonatomic, weak) IBOutlet UIImageView* photo;
@property (nonatomic, weak) IBOutlet UILabel* retweets; //attributed text
@property (nonatomic, weak) IBOutlet UILabel* favorites;
@property (nonatomic, weak) IBOutlet UIButton* favorite;
@property (nonatomic, weak) IBOutlet UIButton* retweet;
@property (nonatomic, weak) IBOutlet UIButton* reply;
@property (nonatomic) Tweet* tweetObj;

- (IBAction)onStar:(id)sender;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onReply:(id)sender;

@end
