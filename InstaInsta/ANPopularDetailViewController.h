//
//  ANPopularDetailViewController.h
//  InstaInsta
//
//  Created by sush on 06.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANInstagramClient.h"


@interface ANPopularDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property NSUInteger incomingLikeCount;
@property (strong, nonatomic) NSString *media_id;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_avatar;
@property (strong, nonatomic) NSArray *tags;
@property (nonatomic) BOOL user_has_liked;

@property (nonatomic) BOOL offline_mode;

@property (strong, nonatomic) UIImage *user_avatar_image;
@property (strong, nonatomic) UIImage *preloaded_image;

@end
