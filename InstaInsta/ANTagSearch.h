//
//  ANTagSearch.h
//  InstaInsta
//
//  Created by sush on 08.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANTagSearch : NSObject

@property NSUInteger media_count;
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *next_url;

+ (void)getSearchResultsWithTag:(NSString *)tag
                    AccessToken:(NSString *)accessToken
                          block:(void (^)(NSArray *records))block;

@end
