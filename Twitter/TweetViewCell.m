//
//  TweetViewCell.m
//  Twitter
//
//  Created by Bhagyashree Shekhawat on 2/6/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import "TweetViewCell.h"
#import "Utils.h"
#import "GlobalStore.h"
#import "MyTwitterClient.h"

@interface TweetViewCell()
@property (nonatomic, strong) GlobalStore* global;
@property (nonatomic, strong) MyTwitterClient *client;
@end
@implementation TweetViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.global = [GlobalStore instance];
        NSLog(@"Global: %@", self.global);
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self != nil){
        self.global = [GlobalStore instance];
        NSLog(@"Global: %@", self.global);
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self != nil){
        self.global = [GlobalStore instance];
        NSLog(@"Global: %@", self.global);
        NSDictionary *data = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"kAccessTokenKey"];
        NSString *token = [data valueForKey:@"oauth_token"];
        
        NSString *verifier = [data valueForKey:@"oauth_verifier"];
        self.client = [MyTwitterClient instancewithoAuthToken:token secret:verifier];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onStar:(id)sender {
    //change color
    self.global.updateFavorite = YES;
    UIImage* favIcon =[UIImage imageNamed:@"star.png"];
    UIColor *color;
    NSMutableString * result = [[NSMutableString alloc] initWithString:@""];
    if(self.tweetObj.favorited){
        color = [UIColor grayColor];
        self.global.favorited = NO;
        self.tweetObj.favorited = NO;
        [result appendString: [NSString stringWithFormat:@"%d",self.tweetObj.favCount - 1 ]];
        [result appendString: @" favorites"];
        
        [self.client.twitter postFavoriteState:NO forStatusID:self.tweetObj.id
                                  successBlock:^(NSDictionary *status) {
                                      NSLog(@"Favorited!!");
                                  } errorBlock:^(NSError *error) {
                                      NSLog(@"Error favoriting");
                                  }];
    }
    
    else {
        color = [UIColor blueColor];
        self.tweetObj.favorited = YES;
        [result appendString: [NSString stringWithFormat:@"%d",self.tweetObj.favCount + 1 ]];
        [result appendString: @" favorites"];

        self.global.favorited = YES;
        //fav
        [self.client.twitter postFavoriteCreateWithStatusID:self.tweetObj.id includeEntities:nil successBlock:^(NSDictionary *status) {
                                                  NSLog(@"Favorited!!");
                                  } errorBlock:^(NSError *error) {
                                      NSLog(@"Error favoriting");
                                  }];
       
        
    }
    self.favorites.text = result;
    [sender setImage:[Utils maskWithColor:color image:favIcon] forState:UIControlStateNormal];
    //call api
}

- (IBAction)onRetweet:(id)sender{
    //change color
    self.global.updateRetweet = YES;
    if(self.tweetObj.retweeted){
        self.global.retweeted = NO;
    }
    else{
        UIColor *color = [UIColor blueColor];
        UIImage* favIcon =[UIImage imageNamed:@"retweet.png"];
        [sender setImage:[Utils maskWithColor:color image:favIcon] forState:UIControlStateNormal];
        NSLog(@"%@", self.tweetObj);
        self.tweetObj.retweeted = YES;
        NSMutableString * result = [[NSMutableString alloc] initWithString:@""];
        [result appendString: [NSString stringWithFormat:@"%d",self.tweetObj.rtCount + 1 ]];
        [result appendString: @" retweets"];
        self.retweets.text = result;
        
        self.global.retweeted = YES;
        [self.client.twitter postStatusRetweetWithID:self.tweetObj.id successBlock:^(NSDictionary *status) {
            NSLog(@"Retweeted");
            self.global.tweet = [[Tweet alloc]initWithDictionary:status];
        } errorBlock:^(NSError *error) {
            NSLog(@"Failed retweet");
        }];
    }
    
    //call api
};
- (IBAction)onReply:(id)sender{
    //change color
    self.global.updateReplied = YES;
    if(!self.tweetObj.replied){
        self.tweetObj.replied = YES;
        NSLog(@"%@", sender);
        UIColor *color = [UIColor blueColor];
        UIImage* favIcon =[UIImage imageNamed:@"Comment.png"];
        [sender setImage:[Utils maskWithColor:color image:favIcon] forState:UIControlStateNormal];
        self.global.replied = YES;
    }
    //call api
};

@end
