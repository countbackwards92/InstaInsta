//
//  ANInstaFeedViewController.h
//  InstaInsta
//
//  Created by Администратор on 12/26/13.
//  Copyright (c) 2013 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ANInstaFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableFeed;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *attr_items;
@property (strong, nonatomic) NSMutableArray *attrib;

@end
