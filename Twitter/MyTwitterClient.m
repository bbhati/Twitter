//
//  MyTwitterClient.m
//  Twitter
//
//  Created by Bhagyashree Shekhawat on 2/3/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import "MyTwitterClient.h"
#import <STTwitter/STTwitterOAuth.h>
#import "GlobalStore.h"

@interface MyTwitterClient()
+(GlobalStore*) global;
@end

@implementation MyTwitterClient

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
//#define TWITTER_CONSUMER_KEY @"biYAqubJD0rK2cRatIQTZw"
//#define TWITTER_CONSUMER_SECRET @"2cygl2irBgMQVNuWJwMn6vXiyDnWtht7gSyuRnf0Fg"

#define TWITTER_CONSUMER_KEY @"zEJYWAw0xppbZ41wSKgaA"
#define TWITTER_CONSUMER_SECRET @"J2Gz5mhsXbMR4ywJT8J7HnTuzACQGVFx3ghmBsXaA"


+ (MyTwitterClient *)instancewithoAuthToken: (NSString*)token secret:(NSString*)secret {
    
    static dispatch_once_t once;
    static MyTwitterClient *instance;

    dispatch_once(&once, ^{
        instance = [[MyTwitterClient alloc] init];
        if(token != nil && secret != nil) {
            instance.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET oauthToken:token oauthTokenSecret:secret];
        } else {
            instance.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
        }
    });
    
    return instance;
}


-(id) init{
    
    self = [super init];
    if(self != nil) {
    }
    return self;
}

-(void)loginInSafari:(id)sender callback:(NSString*)callback success:(void (^)(NSURL *callback, NSString *oauthToken))success failure:(void(^)(NSError* error))failure {
    
    [self.twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        NSLog(@"-- url: %@", url);
        NSLog(@"-- oauthToken: %@", oauthToken);
        success(url, oauthToken);
        
        [[UIApplication sharedApplication] openURL:url];
        
    } oauthCallback:callback
                    errorBlock:^(NSError *error) {
                        NSLog(@"-- error: %@", error);
                        failure(error);
                    }];
}


- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier success: (void(^)(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName))success failure:(void(^)(NSError* error))failure {
    NSLog(@"token: %@", token);
    NSLog(@"verifier %@", verifier);
    
    [self.twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);
        success(oauthToken, oauthTokenSecret, userID, screenName);
        NSLog(@"oauthToken %@", oauthToken);
        NSLog(@"oauthTokenSecret %@", oauthTokenSecret);
        //set user

        NSDictionary *data = @{     @"token" : oauthToken,
                                    @"secret" : oauthTokenSecret
                                    };
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"kAccessTokenKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } errorBlock:^(NSError *error) {
        NSLog(@"-- %@", [error localizedDescription]);
        // [self onError];
    }];
}



@end
