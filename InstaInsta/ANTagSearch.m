//
//  ANTagSearch.m
//  InstaInsta
//
//  Created by sush on 08.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANTagSearch.h"
#import "ANInstagramClient.h"

@implementation ANTagSearch
- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.media_count = [[attributes valueForKey:@"media_count"] integerValue];
    self.name = [attributes valueForKey:@"name"];
    return self;
}

+ (void)getSearchResultsWithTag:(NSString *)tag
                    AccessToken:(NSString *)accessToken
                          block:(void (^)(NSArray *records))block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:accessToken,tag,nil] forKeys:[NSArray arrayWithObjects:@"access_token",@"q",nil]];

    NSString *path = @"tags/search";
    
    [[ANInstagramClient sharedClient] getPath:path
                                   parameters:params
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSMutableArray *mutableRecords = [NSMutableArray array];
                                          NSArray* data = [responseObject objectForKey:@"data"];
                                          for (NSDictionary* obj in data) {
                                              ANTagSearch* media = [[ANTagSearch alloc] initWithAttributes:obj];
                                              media.next_url = [[responseObject objectForKey:@"pagination"] valueForKey:@"next_url"];
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
