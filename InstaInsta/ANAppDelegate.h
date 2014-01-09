//
//  ANAppDelegate.h
//  InstaInsta
//
//  Created by Администратор on 12/26/13.
//  Copyright (c) 2013 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ApplicationDelegate ((ANAppDelegate *)[UIApplication sharedApplication].delegate)

@interface ANAppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *coolController;
@property (strong, nonatomic) UIViewController *offlineController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
