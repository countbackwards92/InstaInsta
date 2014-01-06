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

@property (nonatomic, strong) NSString* thumbnailUrl;
@property (nonatomic, strong) NSString* standardUrl;
@property (nonatomic, strong) NSString* media_id;
@property (nonatomic) NSUInteger likes;

+ (void)getPopularMediWithAccessToken:(NSString *)accessToken
                                block:(void (^)(NSArray *records))block;


@end
