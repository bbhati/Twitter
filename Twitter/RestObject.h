//
//  RestObject.h
//  Twitter
//
//  Created by Bhagyashree Shekhawat on 2/1/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestObject : NSObject

- (id)initWithDictionary:(NSDictionary *)data;

@property (nonatomic, strong) NSDictionary *data;

@end

@interface RestObject (ForwardedMethods)

- (id)objectForKey:(id)key;
- (id)valueOrNilForKeyPath:(NSString *)keyPath;

@end

