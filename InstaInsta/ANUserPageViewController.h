//
//  ANUserPageViewController.h
//  InstaInsta
//
//  Created by sush on 08.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANUserPageViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSString *user_id;


@end