//
//  GlobalStore.h
//  Twitter
//
//  Created by Bhagyashree Shekhawat on 2/7/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@interface GlobalStore : NSObject

+(GlobalStore*)instance;
@property(nonatomic) BOOL favorited;
@property(nonatomic) BOOL retweeted;
@property(nonatomic) BOOL replied;
@property(nonatomic) NSInteger tweetIndex;
@property(nonatomic, retain, strong) Tweet* tweet;

@property(nonatomic)BOOL updateFavorite;
@property(nonatomic) BOOL updateRetweet;
@property(nonatomic) BOOL updateReplied;
@property(nonatomic)BOOL signout;

@end
