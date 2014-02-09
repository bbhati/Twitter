//
//  HomeViewController.m
//  TwitterlClient
//
//  Created by Bhagyashree Shekhawat on 2/1/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import "HomeViewController.h"

#import "STTwitter.h"
#import "MyTwitterClient.h"
#import "TimeLineViewController.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
//#define TWITTER_CONSUMER_KEY @"biYAqubJD0rK2cRatIQTZw"
//#define TWITTER_CONSUMER_SECRET @"2cygl2irBgMQVNuWJwMn6vXiyDnWtht7gSyuRnf0Fg"

#define TWITTER_CONSUMER_KEY @"zEJYWAw0xppbZ41wSKgaA"
#define TWITTER_CONSUMER_SECRET @"J2Gz5mhsXbMR4ywJT8J7HnTuzACQGVFx3ghmBsXaA"

NSString * const applicationLaunchedWithURLNotification = @"applicationLaunchedWithURLNotification";
#if __IPHONE_OS_VERSION_MIN_REQUIRED
NSString * const applicationLaunchOptionsURLKey = @"UIApplicationLaunchOptionsURLKey";
#else
NSString * const applicationLaunchOptionsURLKey = @"NSApplicationLaunchOptionsURLKey";
#endif
static NSString * const kAccessTokenKey = @"kAccessTokenKey";


@interface HomeViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *mainImage;
@property (nonatomic, weak) IBOutlet UIView *signUpBar;
@property (nonatomic, strong) MyTwitterClient *client;
- (IBAction)onSignIn:(id)sender;


@end



@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"InitWithCoder called");
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //self.client = [MyTwitterClient instance];
        UIImage *img1 = [UIImage imageNamed:@"twitter.png"];
        UIImage* img2 = [self resizeImage:img1];
        [self.mainImage setImage:img2];

           }
    return self;
}

- (void)viewDidLoad
{
    NSDictionary *data = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kAccessTokenKey];
    
    if(data != nil){
        
        NSString *token = [data valueForKey:@"token"];
        
        NSString *verifier = [data valueForKey:@"secret"];
        if(token != nil && verifier != nil) {
            self.client = [MyTwitterClient instancewithoAuthToken:token secret:verifier];
            TimeLineViewController *controller = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            self.client = [MyTwitterClient instancewithoAuthToken:nil secret:nil];
            
            [super viewDidLoad];
            UIImage *img1 = [UIImage imageNamed:@"twitter.png"];
            UIImage* img2 = [self resizeImage:img1];
            [self.mainImage setImage:img2];
        }
        
    } else {
        self.client = [MyTwitterClient instancewithoAuthToken:nil secret:nil];
        
        [super viewDidLoad];
        UIImage *img1 = [UIImage imageNamed:@"twitter.png"];
        UIImage* img2 = [self resizeImage:img1];
        [self.mainImage setImage:img2];
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSignIn:(id)sender {
    //load xib
    NSDictionary *data = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kAccessTokenKey];
    
    if(data != nil){
        
        NSString *token = [data valueForKey:@"token"];
        
        NSString *verifier = [data valueForKey:@"secret"];
  
        if(token == nil || verifier == nil) {
            self.client = [MyTwitterClient instancewithoAuthToken:nil secret:nil];
        }
    } else{
        self.client = [MyTwitterClient instancewithoAuthToken:nil secret:nil];
    }
    
    [self.client loginInSafari:sender callback:@"ex-twitter://twitter_access_tokens/" success:^(NSURL *url, NSString *oauthToken) {
        NSLog(@"opening %@", url);
        
            [[UIApplication sharedApplication] openURL:url];
        
            [[NSNotificationCenter defaultCenter] addObserverForName:applicationLaunchedWithURLNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
            
            NSLog(@"notification %@", notification);
            
            NSDictionary *d = notification.object;
            
            NSString *token = d[@"oauth_token"];
            NSString *verifier = d[@"oauth_verifier"];
            [self.client setOAuthToken:token oauthVerifier:verifier success:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
                NSLog(@"-- screenName: %@", screenName);
                //Store the access token.
                TimeLineViewController *controller = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
                [self.navigationController pushViewController:controller animated:YES];
                
            } failure:^(NSError *error) {
                NSLog(@"Error first");
                [self onError];
            }];
        }];
//        } else{
//            NSString *token = [data valueForKey:@"oauth_token"];
//            NSString *verifier = [data valueForKey:@"oauth_verifier"];
//            [self.client setOAuthToken:token oauthVerifier:verifier success:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
//                NSLog(@"-- screenName: %@", screenName);
//                //Store the access token.
//                //set user
//                
//                TimeLineViewController *controller = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
//                [self.navigationController pushViewController:controller animated:YES];
//                
//            } failure:^(NSError *error) {
//                NSLog(@"Error first");
//                [self onError];
//            }];
//        }
//        
    }  failure:^(NSError *error) {
        NSLog(@"Error:", error);
        NSLog(@"Error second");
        [self onError];
    }];
    
    
}

- (UIImage*)resizeImage:(UIImage*)image{

    UIGraphicsBeginImageContextWithOptions( CGSizeMake( 300, 300 ),
                                           NO,
                                           0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextRestoreGState(context);
    
    [image drawInRect:CGRectMake(50,50,200,200)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void)onError {
    [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't log in with Twitter, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}
@end
