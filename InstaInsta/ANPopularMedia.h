//
//  ANPopularMedia.h
//  InstaInsta
//
//  Created by sush on 06.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANInstagramClient.h"

@interface ANPopularMedia : NSObject

@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *standardUrl;
@property (nonatomic, strong) NSString *media_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *user_avatar;
@property (nonatomic, strong) NSString *next_url;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic) BOOL user_has_liked;
@property (nonatomic) NSUInteger likes;

@property (nonatomic, strong) NSString *load_more_url;

+ (void)getMediWithPath:(NSString *)path
            AccessToken:(NSString *)accessToken
                  block:(void (^)(NSArray *records))block;

+ (void)getMediaWithExactPath:(NSString *)path
                  block:(void (^)(NSArray *records))block;


@end
