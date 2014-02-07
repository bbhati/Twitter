//
//  GlobalStore.m
//  Twitter
//
//  Created by Bhagyashree Shekhawat on 2/7/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import "GlobalStore.h"

@implementation GlobalStore

+ (GlobalStore *)instance {
    static dispatch_once_t once;
    static GlobalStore *instance;
    
    dispatch_once(&once, ^{
        instance = [[GlobalStore alloc] init];
    });
    
    return instance;
}

@end
