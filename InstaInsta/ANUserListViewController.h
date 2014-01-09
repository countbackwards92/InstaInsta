//
//  ANUserListViewController.h
//  InstaInsta
//
//  Created by sush on 09.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANUserData.h"

@interface ANUserListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *path;

@end
