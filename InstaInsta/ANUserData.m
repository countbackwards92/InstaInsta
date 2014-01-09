//
//  ANUserData.m
//  InstaInsta
//
//  Created by sush on 09.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANUserData.h"
#import "ANInstagramClient.h"

@implementation ANUserData

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.media_count = [[[attributes objectForKey:@"counts"] valueForKey:@"media"] integerValue];
    self.follows_count = [[[attributes objectForKey:@"counts"] valueForKey:@"follows"] integerValue];
    self.followedby_count = [[[attributes objectForKey:@"counts"] valueForKey:@"followed_by"] integerValue];
    self.full_name = [attributes valueForKey:@"full_name"];
    self.bio = [attributes valueForKey:@"bio"];
    self.website = [attributes valueForKey:@"website"];
    self.username = [attributes valueForKey:@"username"];
    self.user_id = [attributes valueForKey:@"id"];
    self.profile_picture = [attributes valueForKey:@"profile_picture"];
    return self;
}

+ (void) getUserDataByUserId:(NSString *)userId
                AccessToken:(NSString *)accessToken
                      block:(void (^)(NSArray *records))block;
{
    NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:accessToken,nil] forKeys:[NSArray arrayWithObjects:@"access_token",nil]];
    
    NSString *path = [NSString stringWithFormat:@"users/%@", userId];
    
    [[ANInstagramClient sharedClient] getPath:path
                                   parameters:params
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSMutableArray *mutableRecords = [NSMutableArray array];
                                          NSDictionary* data = [responseObject objectForKey:@"data"];
                                          
                                          ANUserData* media = [[ANUserData alloc] initWithAttributes:data];
                                          [mutableRecords addObject:media];
                                          
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

+ (void) getUsersByPath:(NSString *)path
            AccessToken:(NSString *)accessToken
                  block:(void (^)(NSArray *records))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:accessToken,nil] forKeys:[NSArray arrayWithObjects:@"access_token",nil]];
    
   // NSString *path = [NSString stringWithFormat:@"users/%@", userId];
    
    [[ANInstagramClient sharedClient] getPath:path
                                   parameters:params
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSMutableArray *mutableRecords = [NSMutableArray array];
                                          NSArray* data = [responseObject objectForKey:@"data"];
                                          for (NSDictionary *obj in data) {
                                              ANUserData* media = [[ANUserData alloc] initWithAttributes:obj];
                                              media.next_page = [[responseObject objectForKey:@"pagination"] valueForKey:@"next_url"];//////is it always there?
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

+ (void) getUsersByExactPath:(NSString *)path
                  block:(void (^)(NSArray *records))block
{
 //   NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:accessToken,nil] forKeys:[NSArray arrayWithObjects:@"access_token",nil]];
    
    // NSString *path = [NSString stringWithFormat:@"users/%@", userId];
    
    [[ANInstagramClient sharedClient] getPath:path
                                   parameters:nil
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSMutableArray *mutableRecords = [NSMutableArray array];
                                          NSArray* data = [responseObject objectForKey:@"data"];
                                          for (NSDictionary *obj in data) {
                                              ANUserData* media = [[ANUserData alloc] initWithAttributes:obj];
                                              media.next_page = [[responseObject objectForKey:@"pagination"] valueForKey:@"next_url"];//////is it always there?
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
