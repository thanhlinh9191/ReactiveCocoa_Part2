//
//  RWTweet.h
//  TwitterInstant
//
//  Created by THANHLINH on 9/06/15.
//  Copyright (c) 2015 THANHLINH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTweet : NSObject

@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *profileImageUrl;

@property (strong, nonatomic) NSString *username;

+ (instancetype)tweetWithStatus:(NSDictionary *)status;


@end
