//
//  ANPopularDetailViewController.h
//  InstaInsta
//
//  Created by sush on 06.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANInstagramClient.h"


@interface ANPopularDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSUInteger incomingLikeCount;
@property (strong, nonatomic) NSString *media_id;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_avatar;

@end
