//
//  ANUserData.h
//  InstaInsta
//
//  Created by sush on 09.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANUserData : NSObject

@property (strong, nonatomic) NSString *full_name;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *profile_picture;
@property (nonatomic) NSUInteger media_count;
@property (nonatomic) NSUInteger follows_count;
@property (nonatomic) NSUInteger followedby_count;

@property (strong, nonatomic) NSString *next_page;

+ (void) getUserDataByUserId:(NSString *)userId
          AccessToken:(NSString *)accessToken
                block:(void (^)(NSArray *records))block;

+ (void) getUsersByPath:(NSString *)path
            AccessToken:(NSString *)accessToken
                  block:(void (^)(NSArray *records))block;

+ (void) getUsersByExactPath:(NSString *)path
                  block:(void (^)(NSArray *records))block;

@end
