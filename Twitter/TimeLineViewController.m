//
//  TimeLineViewController.m
//  TwitterlClient
//
//  Created by Bhagyashree Shekhawat on 1/31/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import "TimeLineViewController.h"
#import "TweetViewController.h"
#import "ComposeViewController.h"
#import <STTwitterAPI.h>
#import "Tweet.h"
#import "User.h"
#import "MyTwitterClient.h"
#import "TimeLineCell.h"
#import "Utils.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "GlobalStore.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface TimeLineViewController ()

@property (nonatomic, strong) MyTwitterClient *client;
@property (nonatomic) NSMutableArray *statuses;
@property (nonatomic, weak) IBOutlet UITableView *view;
@property (nonatomic, strong) GlobalStore* global;

@end

@implementation TimeLineViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.tableView;
        
        NSDictionary *data = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"kAccessTokenKey"];
        NSString *token = [data valueForKey:@"oauth_token"];
        
        NSString *verifier = [data valueForKey:@"oauth_verifier"];
        self.client = [MyTwitterClient instancewithoAuthToken:token secret:verifier];

        [self.view registerNib:[UINib nibWithNibName:@"TimeLineViewCell" bundle:nil] forCellReuseIdentifier:@"TimeLineViewCell"];

        self.global = [GlobalStore instance];
        
        NSLog(@"Global: %@", self.global);
        self.statuses = [[NSMutableArray alloc] init];
        
        //TODO: keyboard notif registration
        //[self registerForKeyboardNotifications];
        
        self.view.delegate = self;
        self.view.dataSource = self;
        
        self.title = @"Twitter";
        
        [self reload];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:(UIBarButtonItemStylePlain) target:self action:@selector(onTweetButton)];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(setup) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;

    
    [self reload];
    
    
    // Uncomment the following line to preserve selection between presentations.
    //self.view.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"view did appear");
    NSLog(@"updating tweet %d", self.global.tweetIndex);
    if(self.global.tweet != nil){
        [self.statuses insertObject:self.global.tweet atIndex:0];
    }
    self.global.tweet = nil;
    [self.view reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell for row called!! %d", indexPath.row);
    static NSString *CellIdentifier = @"TimeLineViewCell";
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Tweet *tweet = self.statuses[indexPath.row];

    cell.tweet.text = tweet.text;
    cell.name.text = tweet.name;
    cell.handle.text = tweet.formattedHandle;
    cell.timestamp.text = [tweet timeElapsed];

    UIColor *color = [UIColor grayColor];
    NSLog(@"fav? %d",tweet.favorited);
    
    if(tweet.favorited) {
        color = [UIColor blueColor];
    }
    if(self.global.tweetIndex == indexPath.row && self.global.updateFavorite){
        if(self.global.favorited){
            color = [UIColor blueColor];
        } else {
            color = [UIColor grayColor];
        }
    }
    UIImage* favIcon =[UIImage imageNamed:@"star.png"];
    [cell.favorite setImage:[Utils maskWithColor:color image:favIcon] forState:UIControlStateNormal];

    if(tweet.retweeted) {
        color = [UIColor blueColor];
    } else {
        color = [UIColor grayColor];
    }
    favIcon =[UIImage imageNamed:@"retweet.png"];
    [cell.retweet setImage:[Utils maskWithColor:color image:favIcon] forState:UIControlStateNormal];
    

    if(tweet.replied) {
        color = [UIColor blueColor];
    } else {
        color = [UIColor grayColor];
    }
    favIcon =[UIImage imageNamed:@"Comment.png"];
    [cell.reply setImage:[Utils maskWithColor:color image:favIcon] forState:UIControlStateNormal];
    

    //[cell.imageView setImageWithURL:[NSURL URLWithString:tweet.imageUrl]];
    
    TimeLineCell* dummy = [[TimeLineCell alloc] init];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:tweet.imageUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10000];
    [request setHTTPMethod:@"GET"];
    
  
    //TODO resize image
    [dummy.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
////resize
        [cell.imageView setImage:[Utils imageByScalingAndCroppingForSize:(CGSize)CGSizeMake(50,50) source:image]];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load image");
    }];

    //set fav images
    
    
    NSLog(@"cell contents" );
    [tweet toString];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0f;
}

- (CGSize)textSize:(NSString *)text constrainedToSize:(CGSize)size
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGRect frame = [text boundingRectWithSize:size
                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                       attributes:attributes
                                          context:nil];
        NSLog(@"Bound size: height %f", size.height);
        NSLog(@"Bound size: width %f", size.width);
        NSLog(@"Frame size: height %f", frame.size.height);
        NSLog(@"Frame size: width %f", frame.size.width);
        return frame.size;
    }
    else
    {
        return [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSLog(@"Calculating height for content %@", [self.statuses objectAtIndex:indexPath.row]);
        
        Tweet* tweet = [self.statuses objectAtIndex:indexPath.row];
        float verticalPadding = 110;
        float horizontalPadding = 98;
        
        float widthOfTextView = self.view.bounds.size.width;
        widthOfTextView = widthOfTextView - horizontalPadding;
        
        float height = [self textSize:tweet.text constrainedToSize:CGSizeMake(widthOfTextView, FLT_MAX)].height;
    
//
//    float height =
//        
//        if(height < 35){
//            height = 35.0;
//        }
    
        NSLog(@"Content height: %f", height);
        
        return height + verticalPadding;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Tweet *tweet = self.statuses[indexPath.row];
    self.global.tweetIndex = indexPath.row;
    self.global.updateFavorite=NO;
    self.global.updateRetweet=NO;
    self.global.updateReplied=NO;
    TweetViewController *controller = [[TweetViewController alloc] init];
    controller.tweet = tweet;
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

- (void)getTimeline:(int)count sinceId:(int)sinceId maxId:(int)maxId success:(void(^)(NSArray *statuses))success {

    NSLog(@"TwitterAPI%@",self.client.twitter);
    NSLog(@"accessToken%@",self.client.twitter.oauthAccessToken);
    NSLog(@"oauthAccessTokenSecret%@",self.client.twitter.oauthAccessTokenSecret);
    //self.getTimelineStatusLabel.text = @"";
    NSLog(@"fetching tweets!!");
    [self.client.twitter getHomeTimelineSinceID:nil
                               count:count
                        successBlock:^(NSArray *statuses) {
                            
                            NSLog(@"-- statuses: %@", statuses);
                            NSLog(@"statuses count %d", [statuses count]);
                            //self.getTimelineStatusLabel.text = [NSString stringWithFormat:@"%lu statuses", (unsigned long)[statuses count]];
                            
                            success(statuses);
                            
                        } errorBlock:^(NSError *error) {
                            NSLog(@"Error occured");
                            //self.getTimelineStatusLabel.text = [error localizedDescription];
                        }];
}

- (void)onSignOutButton {
//    [User setCurrentUser:nil];
    //dismiss
    self.client = nil;

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onTweetButton {
    //new tweet modal
    ComposeViewController *controller = [[ComposeViewController alloc] init];

    [self.navigationController presentViewController:controller animated:YES completion:^{

    }];
}

- (void)reload {
    NSLog(@"Reloading tweets");
    [self getTimeline:20 sinceId:0 maxId:0  success: ^(NSArray *statuses){

        self.statuses = [Tweet tweetsWithArray:statuses];
        [self.view reloadData];
    }];
}

- (UIImage*)resizeImage:(UIImage*)image{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextRestoreGState(context);
    
    [image drawInRect:CGRectMake(0,0,85,85)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat actualPosition = scrollView_.contentOffset.y;
    CGFloat contentHeight = scrollView_.contentSize.height;
    Tweet* lastTweet = (Tweet*)self.statuses.lastObject;
    int lastId = [lastTweet.id integerValue];
    NSLog(@"actual pos %f", actualPosition);
        NSLog(@"contentHeight pos %f", contentHeight);
    if(actualPosition >= contentHeight -500) {
        NSLog(@"Scrolled to bottom!!!");
        [self getTimeline:20 sinceId:lastId maxId:nil success:^(NSArray *statuses) {
            
            NSLog(@"refresh table");
            
            [self.statuses addObjectsFromArray:[Tweet tweetsWithArray:statuses]];
            [self.view reloadData];
            
        }];
    }
}

-(void) setup {
    self.statuses = [[NSMutableArray alloc] initWithCapacity:20];
    
    [self reload];
    
}

@end
