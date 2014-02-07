//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"
#import "NSDictionary+CPAdditions.h"

@implementation Tweet
static NSDictionary* timezoneMapping;

+(void)initialize{
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"ActiveSupport2iOS_Timezones" ofType:@"plist"];
    timezoneMapping = [[[NSDictionary alloc] initWithContentsOfFile:plistCatPath] objectForKey:@"TimeZones"];
}

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSString *)name {
    return [self.data valueOrNilForKeyPath:@"user.name"];
}

- (NSString *)handle {
    return [self.data valueOrNilForKeyPath:@"user.screen_name"];
}

- (NSString *)imageUrl{
    return [self.data valueOrNilForKeyPath:@"user.profile_image_url"];
}

- (NSString *)createdDate{
    return [self.data valueOrNilForKeyPath:@"created_at"];
}

- (NSString *)id{
    return [self.data valueOrNilForKeyPath:@"id"];
}

//"favorite_count"
//"retweet_count"
//favorited
//retweeted

- (NSInteger)favCount{
    
    return [[self.data valueOrNilForKeyPath:@"favorite_count"] integerValue];
}

- (NSInteger)rtCount {
    return [[self.data valueOrNilForKeyPath:@"retweet_count"] integerValue];
}

- (BOOL)favorited{
    //(myBool) ? @"YES" : @"NO"
    if([[self.data valueForKey:@"favorited"]integerValue] == 0){
        return NO;
    }
    return YES;
    
}

- (BOOL)retweeted{
    //(myBool) ? @"YES" : @"NO"
    if([[self.data valueForKey:@"retweeted"]integerValue] == 0){
        return NO;
    }
    return YES;
}

- (NSString *)timeZone{
    return [self.data valueForKey:@"time_zone"];
}
- (NSString *)timeElapsed{
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSString* timeinCurrentZone = [self timeinZone:currentTimeZone withUTC:[self createdDate]];
    //NSTimeInterval timeInterval = [timeinCurrentZone timeIntervalSinceNow];
    
    NSDate* current = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
    NSLog(@"Current date: ");
    
    NSLog(@"%@",[dateFormat stringFromDate:current]);
    NSDate *date = [dateFormat dateFromString:timeinCurrentZone];
    
    return [self prettifiedTimeElapsedSince:date toDate:current];
    
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    
    return tweets;
}


- (NSString*)timeinZone:(NSTimeZone*)zone withUTC:(NSString *)ts_utc{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //Thu Feb 06 21:53:41 +0000 2014 EEE MMM dd HH:mm:ss ZZZ yyyy
    [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
    
    NSLog(@"Tweet date: ");
    NSLog(@"%@", ts_utc);

    NSDate *date = [dateFormat dateFromString:ts_utc];

    dateFormat.timeZone = zone;
    NSString *local = [dateFormat stringFromDate:date];
    NSLog(@"GMT to local %@", local);
//    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    dateFormat.timeZone = gmt;
//    
//    date = [dateFormat dateFromString:local];
//    
//    return date;
    
    return local;
}


- (NSString*)prettifiedTimeElapsedSince:(NSDate*)date1 toDate:(NSDate*)date2 {

    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    NSLog(@"Break down: %d sec : %d min : %d hours : %d days : %d months : %d years",breakdownInfo.second, breakdownInfo.minute, breakdownInfo.hour, breakdownInfo.day, breakdownInfo.month, breakdownInfo.year);
    NSString* result = @"";
    if((breakdownInfo.year == 0 || breakdownInfo.year ==2147483647) && (breakdownInfo.second == 0 || breakdownInfo.second ==2147483647)&& (breakdownInfo.month == 0) && (breakdownInfo.day == 0) && (breakdownInfo.minute == 0)) {
        return @"Just now";
    }
    
    if(breakdownInfo.year > 0 && breakdownInfo.year !=2147483647)
    {
    	result = [result stringByAppendingString: [NSString stringWithFormat:@"%dy", [breakdownInfo year]]];
    }
    else {
        if(breakdownInfo.month > 0)
        {
            //return date
            result = [result stringByAppendingString: [NSString stringWithFormat:@"%dmonths", [breakdownInfo month]]];
        }
        else {
            if(breakdownInfo.day > 0)
            {
                result = [result stringByAppendingString: [NSString stringWithFormat:@"%dd", [breakdownInfo day]]];
            }
            if(breakdownInfo.minute > 0)
            {
                result = [result stringByAppendingString: [NSString stringWithFormat:@"%dm", [breakdownInfo minute]]];
            }
            if(breakdownInfo.second > 0 && breakdownInfo.second !=2147483647)
            {
                result = [result stringByAppendingString: [NSString stringWithFormat:@"%ds", [breakdownInfo second]]];
            }
        }

    }

    return result;
}

-(void) toString{
//    NSMutableString* result = [[NSMutableString alloc ] init];
//    [result appendString:self.text];
       // [result appendString:@" , "];
    //[result appendString:self.imageUrl];
//        [result appendString:@" , "];
    //[result appendString:self.name];
  //      [result appendString:@" , "];
    //[result appendString:self.handle];
    //[result appendString:@" , "];
    //[result appendString:self.createdDate];
//    return result;
    NSLog(@"text %@", self.text);
        NSLog(@"image %@", self.imageUrl);
        NSLog(@"name %@", self.name);
        NSLog(@"handle %@", self.handle);
            NSLog(@"date %@", self.createdDate);
}

-(NSString* )formattedHandle{
    NSMutableString * result = [[NSMutableString alloc] initWithString:@"\@"];
    [result appendString:self.handle];
    return result;
}
@end
