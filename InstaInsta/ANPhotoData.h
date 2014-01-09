//
//  ANPhotoData.h
//  InstaInsta
//
//  Created by sush on 09.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANPhotoData : NSObject

@property (nonatomic) NSUInteger likes_count;
@property (nonatomic) BOOL user_has_liked;

+ (void) getPhotoDataByMediaId:(NSString *)mediaId
                   AccessToken:(NSString *)accessToken
                         block:(void (^)(NSArray *records))block;

@end
