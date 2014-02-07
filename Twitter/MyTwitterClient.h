//
//  MyTwitterClient.h
//  Twitter
//
//  Created by Bhagyashree Shekhawat on 2/3/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STTwitter/STTwitterAPI.h>

@interface MyTwitterClient : NSObject

@property (nonatomic, strong) STTwitterAPI *twitter;

//+ (MyTwitterClient *)instance;
+ (MyTwitterClient *)instancewithoAuthToken: (NSString*)token secret:(NSString*)secret;

-(void)loginInSafari:(id)sender;
// Users API

-(void)loginInSafari:(id)sender callback:(NSString*)url success:(void (^)(NSURL *callback, NSString *oauthToken))success failure:(void(^)(NSError* error))failure;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier success: (void(^)(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName))success failure:(void(^)(NSError* error))failure;

// Statuses API

//- (void)homeTimelineWithCount:(int)count sinceId:(int)sinceId maxId:(int)maxId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//

@end
