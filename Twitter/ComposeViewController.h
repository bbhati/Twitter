//
//  ComposeViewController.h
//  TwitterlClient
//
//  Created by Bhagyashree Shekhawat on 1/31/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel* name;
@property (nonatomic, weak) IBOutlet UILabel* handle;
@property (nonatomic, weak) IBOutlet UILabel* charRemaining;

@property (nonatomic, weak) IBOutlet UITextView* tweet;
@property (nonatomic, weak) IBOutlet UIImageView* photo;
@property (nonatomic, weak) IBOutlet UIButton* done;
@property (nonatomic, weak) IBOutlet UIButton* cancel;

@end
