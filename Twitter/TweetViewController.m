//
//  TweetViewController.m
//  
//
//  Created by Bhagyashree Shekhawat on 2/6/14.
//
//

#import "TweetViewController.h"
#import "MyTwitterClient.h"
#import "TweetViewCell.h"
#import "Utils.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <objc/runtime.h>

@interface TweetViewController ()

@property (nonatomic, strong) MyTwitterClient *client;

@end

@implementation TweetViewController

- (id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSDictionary *data = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"kAccessTokenKey"];
        NSString *token = [data valueForKey:@"oauth_token"];
        
        NSString *verifier = [data valueForKey:@"oauth_verifier"];
        self.client = [MyTwitterClient instancewithoAuthToken:token secret:verifier];

        [self.tableView registerNib:[UINib nibWithNibName:@"TweetViewCell" bundle:nil] forCellReuseIdentifier:@"TweetViewCell"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetViewCell";
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.tweetObj = self.tweet;
    cell.tweet.text = self.tweet.text;
    cell.name.text = self.tweet.name;
    cell.handle.text = self.tweet.formattedHandle;
    cell.timestamp.text = self.tweet.createdDate;
    NSMutableString * result = [[NSMutableString alloc] initWithString:@""];
    [result appendString: [NSString stringWithFormat:@"%d",self.tweet.favCount ]];
    [result appendString: @" favorites"];
    cell.favorites.text = result;

    result = [[NSMutableString alloc] initWithString:@""];
    [result appendString: [NSString stringWithFormat:@"%d",self.tweet.rtCount ]];
    [result appendString: @" retweets"];
    cell.retweets.text = result;
    UIColor *color = [UIColor grayColor];
    UIImage* favIcon =[UIImage imageNamed:@"star.png"];
    UIImage* retweetIcon =[UIImage imageNamed:@"retweet.png"];
    UIImage* replyIcon =[UIImage imageNamed:@"Comment.png"];
    
    [cell.favorite setImage:[Utils maskWithColor:color image:favIcon] forState:UIControlStateNormal];
    [cell.retweet setImage:[Utils maskWithColor:color image:retweetIcon] forState:UIControlStateNormal];
    [cell.reply setImage:[Utils maskWithColor:color image:replyIcon] forState:UIControlStateNormal];
    
    [cell.photo setImageWithURL:[NSURL URLWithString:self.tweet.imageUrl]];
    

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 257.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 257.0f;
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

@end
