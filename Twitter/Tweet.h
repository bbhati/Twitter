//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestObject.h"
@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *handle;
@property (nonatomic, strong, readonly) NSString* createdDate;
@property (nonatomic, strong, readonly) NSString* imageUrl;
@property (nonatomic, strong, readonly) NSString* id;
@property (nonatomic) NSInteger favCount;
@property (nonatomic) NSInteger rtCount;
@property (nonatomic) BOOL favorited;
@property (nonatomic) BOOL retweeted;
@property (nonatomic) BOOL replied;

//"favorite_count"
//"retweet_count"
//favorited
//retweeted

//profile_image_url
//profile_background_image_url
//screen_name -> handle
//name
//        "created_at" = "Wed Feb 05 08:10:43 +0000 2014"; ->gmt
//"time_zone" = "Eastern Time (US & Canada)";

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;
-(void)toString;
-(NSString* )formattedHandle;
-(NSString *)timeElapsed;
@end
