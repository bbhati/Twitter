//
//  ComposeViewController.m
//  TwitterlClient
//
//  Created by Bhagyashree Shekhawat on 1/31/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import "ComposeViewController.h"
#import "MyTwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "GlobalStore.h"

@interface ComposeViewController ()
- (IBAction)onCancel:(id)sender;
- (IBAction)onDone:(id)sender;
@property (nonatomic, strong) MyTwitterClient *client;
@property (nonatomic, strong) GlobalStore* global;
@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //get image and set
        NSDictionary *data = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"kAccessTokenKey"];
        NSString *token = [data valueForKey:@"oauth_token"];
        
        NSString *verifier = [data valueForKey:@"oauth_verifier"];
        self.client = [MyTwitterClient instancewithoAuthToken:token secret:verifier];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDictionary *data = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"kAccessTokenKey"];
        NSString *token = [data valueForKey:@"oauth_token"];
        
        NSString *verifier = [data valueForKey:@"oauth_verifier"];
        self.client = [MyTwitterClient instancewithoAuthToken:token secret:verifier];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.global = [GlobalStore instance];
    self.tweet.delegate = self;
    [self.tweet becomeFirstResponder];
	// Do any additional setup after loading the view.
    [self.client.twitter getAccountSettingsWithSuccessBlock:^(NSDictionary *settings) {
        NSLog(@"Settings: %@", settings);
        [self.client.twitter getUserInformationFor:[settings objectForKey:@"screen_name"] successBlock:^(NSDictionary *user) {
        NSLog(@"User: %@", user);
            [self.photo setImageWithURL:[NSURL URLWithString:[user objectForKey:@"profile_image_url"]]];
            self.name.text = [user objectForKey:@"name"];
            self.handle.text = [user objectForKey:@"screen_name"];
            self.tweet.text=@"";
            self.charRemaining.text=@"140";
            
        } errorBlock:^(NSError *error) {
                    NSLog(@"Error: %@", error);
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    if(newLength > 140){
        return NO;
    }

    self.charRemaining.text = [NSString stringWithFormat:@"%d", 140 - newLength];

    return YES;
    
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 NSLog(@"dismiss");
                             }];

}

- (IBAction)onDone:(id)sender {
    //tweet
    NSString* status = self.tweet.text;
    [self.client.twitter postStatusUpdate:status inReplyToStatusID:nil latitude:nil longitude:nil placeID:nil displayCoordinates:nil trimUser:nil successBlock:^(NSDictionary *status) {
        NSLog(@"updated status");
        Tweet* tweet = [[Tweet alloc] initWithDictionary:status];
        self.global.tweet = tweet;
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     NSLog(@"dismiss");
                                 }];
    } errorBlock:^(NSError *error) {
        NSLog(@"failed  status");
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     NSLog(@"dismiss");
                                 }];
    }];
    
}

@end
