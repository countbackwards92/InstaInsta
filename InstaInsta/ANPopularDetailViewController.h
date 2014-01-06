//
//  ANPopularDetailViewController.h
//  InstaInsta
//
//  Created by sush on 06.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANInstagramClient.h"


@interface ANPopularDetailViewController : UIViewController

@property NSUInteger incomingLikeCount;
@property (strong, nonatomic) NSString *media_id;
@property (strong, nonatomic) NSString *imageUrl;


@end
