//
//  ANTableViewController.h
//  homework_1
//
//  Created by Администратор on 11/17/13.
//  Copyright (c) 2013 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property BOOL needsToLoadData;

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *attr_items;
@property (strong, nonatomic) NSMutableArray *attrib;

- (void) doneWithString:(NSString *)string Attributed:(NSAttributedString*)attributed Attributes:(NSDictionary*)attributes atIndex:(NSInteger) iindex;



@end
