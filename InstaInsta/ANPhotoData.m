//
//  ANPhotoData.m
//  InstaInsta
//
//  Created by sush on 09.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANPhotoData.h"
#import "ANInstagramClient.h"

@implementation ANPhotoData

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.likes_count = [[[attributes objectForKey:@"likes"] valueForKey:@"count"] integerValue];
    self.user_has_liked = [[attributes valueForKey:@"user_has_liked"] boolValue];
    return self;
}

+ (void) getPhotoDataByMediaId:(NSString *)mediaId
                   AccessToken:(NSString *)accessToken
                         block:(void (^)(NSArray *records))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:accessToken,nil] forKeys:[NSArray arrayWithObjects:@"access_token",nil]];
    
    NSString *path = [NSString stringWithFormat:@"media/%@", mediaId];
    
    [[ANInstagramClient sharedClient] getPath:path
                                   parameters:params
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSMutableArray *mutableRecords = [NSMutableArray array];
                                          NSDictionary* data = [responseObject objectForKey:@"data"];
                                          
                                          ANPhotoData* media = [[ANPhotoData alloc] initWithAttributes:data];
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


@end
