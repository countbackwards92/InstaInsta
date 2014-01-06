//
//  UITabBarController+EnableAllDeleteThis.m
//  InstaInsta
//
//  Created by sush on 03.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "UITabBarController+EnableAllDeleteThis.h"

@implementation UITabBarController (EnableAllDeleteThis)

- (void) enableAllDeleteCurrent
{
    for (UIViewController *curr in self.viewControllers) {
        curr.tabBarItem.enabled = YES;
    }
    NSMutableArray *tmp;
    tmp = [self.viewControllers mutableCopy];
    [tmp removeObjectAtIndex:0];
    [self setViewControllers:tmp];
}

@end
