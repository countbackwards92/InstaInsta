//
//  ANAppDelegate.m
//  InstaInsta
//
//  Created by Администратор on 12/26/13.
//  Copyright (c) 2013 MSU. All rights reserved.
//
#import <RestKit/RestKit.h>
#import "ANAppDelegate.h"
#import "ANInstaFeedViewController.h"
#import "ANLoginViewController.h"

@implementation ANAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSError *error = nil;
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"InstaInsta" ofType:@"momd"]];

    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Initialize the Core Data stack
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"db_my.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"RKSeedDatabase" ofType:@"sqlite"];

    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
    
    [managedObjectStore createManagedObjectContexts];

    // Set the default store shared instance
    [RKManagedObjectStore setDefaultStore:managedObjectStore];

    /////////WTF
    
    // Configure the object manager
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/v1/"]];
    objectManager.managedObjectStore = managedObjectStore;
    
    [RKObjectManager setSharedManager:objectManager];
    
    RKEntityMapping *lowresMapping = [RKEntityMapping mappingForEntityForName:@"LowResolutionPhoto" inManagedObjectStore:managedObjectStore];
    [lowresMapping addAttributeMappingsFromDictionary:@{@"url":@"url"}];
    
    RKEntityMapping *standresMapping = [RKEntityMapping mappingForEntityForName:@"StandardResolutionPhoto" inManagedObjectStore:managedObjectStore];
    [standresMapping addAttributeMappingsFromDictionary:@{@"url":@"url"}];
    
    RKEntityMapping *thumbMapping = [RKEntityMapping mappingForEntityForName:@"Thumbnail" inManagedObjectStore:managedObjectStore];
    [thumbMapping addAttributeMappingsFromDictionary:@{@"url":@"url"}];
    

    RKEntityMapping *imagesMapping = [RKEntityMapping mappingForEntityForName:@"Images" inManagedObjectStore:managedObjectStore];
    [imagesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"low_resolution" toKeyPath:@"low_resolution" withMapping:lowresMapping]];
    [imagesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"thumbnail" toKeyPath:@"thumbnail" withMapping:thumbMapping]];
    [imagesMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"standard_resolution" toKeyPath:@"standard_resolution" withMapping:standresMapping]];
  
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Post" inManagedObjectStore:managedObjectStore];
    [entityMapping addAttributeMappingsFromDictionary:@{
                                                        @"id":             @"post_id",
                                                        @"created_time":   @"created_time",
                                                        @"caption.text":   @"caption_text",
                                                        @"likes.count":    @"likes_count",
                                                        @"user.username":  @"username"
                                                        }];
    [entityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"images" toKeyPath:@"images" withMapping:imagesMapping]];

    entityMapping.identificationAttributes = @[ @"post_id" ];
    
//    NSString * const clientId = @"2c0b70e803cc4cc6b157519fcff40924";
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    //  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodAny pathPattern:@"/gists/public" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    ////NOW
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UITabBarController *tabController = [[UITabBarController alloc] init];
    
    ANLoginViewController *viewController = [[ANLoginViewController alloc] initWithNibName:@"ANLoginViewController" bundle:nil];
    ANInstaFeedViewController *feedViewController = [[ANInstaFeedViewController alloc]initWithNibName:@"ANInstaFeedViewController" bundle:nil];

    UINavigationController *feedNavViewController = [[UINavigationController alloc] initWithRootViewController:feedViewController];
    feedNavViewController.tabBarItem.title = @"User Feed";
    feedNavViewController.navigationBar.translucent = NO;
    
    [tabController addChildViewController:viewController];
    [tabController addChildViewController:feedNavViewController];
    
    tabController.tabBar.translucent = NO;
    
    feedViewController.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    
    self.window.rootViewController = tabController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) saveContext
{
    
}


- (void)applicationWillTerminate:(UIApplication*)application {
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication*)application {
    [self saveContext];
}

@end
