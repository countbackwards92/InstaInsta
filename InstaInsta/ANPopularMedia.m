//
//  ANPopularMedia.m
//  InstaInsta
//
//  Created by sush on 06.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANPopularMedia.h"

@implementation ANPopularMedia

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.thumbnailUrl = [[[attributes valueForKeyPath:@"images"] valueForKeyPath:@"thumbnail"] valueForKeyPath:@"url"];
    self.standardUrl = [[[attributes valueForKeyPath:@"images"] valueForKeyPath:@"standard_resolution"] valueForKeyPath:@"url"];
    self.likes = [[[attributes objectForKey:@"likes"] valueForKey:@"count"] integerValue];
    self.media_id = [attributes valueForKey:@"id"];
    self.username = [[attributes objectForKey:@"user"] valueForKey:@"username"];
    self.user_id = [[attributes objectForKey:@"user"] valueForKey:@"id"];
    self.user_avatar = [[attributes objectForKey:@"user"] valueForKey:@"profile_picture" ];
    return self;
}

+ (void)getMediWithPath:(NSString *)path
            AccessToken:(NSString *)accessToken
                  block:(void (^)(NSArray *records))block
{
    NSDictionary* params = [NSDictionary dictionaryWithObject:accessToken forKey:@"access_token"];
    
    [[ANInstagramClient sharedClient] getPath:path
                             parameters:params
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSMutableArray *mutableRecords = [NSMutableArray array];
                                    NSArray* data = [responseObject objectForKey:@"data"];
                                    for (NSDictionary* obj in data) {
                                        ANPopularMedia* media = [[ANPopularMedia alloc] initWithAttributes:obj];
                                        [mutableRecords addObject:media];
                                    }
                                    if (block) {
                                        block([NSArray arrayWithArray:mutableRecords]);
                                    }
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"error: %@", error.localizedDescription);
                                    if (block) {
                                        block([NSArray array]);
                                    }
                                }];
}

@end
