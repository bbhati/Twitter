//
//  Utils.h
//  Twitter
//
//  Created by Bhagyashree Shekhawat on 2/6/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize source:(UIImage*)source;
+ (UIImage *) maskWithColor:(UIColor *)color image:(UIImage*)image;
@end
