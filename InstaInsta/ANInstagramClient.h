//
//  ANInstagramClient.h
//  InstaInsta
//
//  Created by sush on 06.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "AFHTTPClient.h"

@interface ANInstagramClient : AFHTTPClient

+ (ANInstagramClient*) sharedClient;
- (id)initWithBaseURL:(NSURL *)url;

@end
