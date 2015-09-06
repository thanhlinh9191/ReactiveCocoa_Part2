//
//  RWTweet.m
//  TwitterInstant
//
//  Created by THANHLINH on 9/06/15.
//  Copyright (c) 2015 THANHLINH. All rights reserved.
//

#import "RWTweet.h"

@implementation RWTweet

+ (instancetype)tweetWithStatus:(NSDictionary *)status {
  RWTweet *tweet = [RWTweet new];
  tweet.status = status[@"text"];
  
  NSDictionary *user = status[@"user"];
  tweet.profileImageUrl = user[@"profile_image_url"];
  tweet.username = user[@"screen_name"];
  return tweet;
}

@end
