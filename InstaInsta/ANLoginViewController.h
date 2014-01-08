//
//  ANLoginViewController.h
//  InstaInsta
//
//  Created by Администратор on 1/3/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANModel.h"
#import "UITabBarController+EnableAllDeleteThis.h"

@interface ANLoginViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *accessToken;

@end
