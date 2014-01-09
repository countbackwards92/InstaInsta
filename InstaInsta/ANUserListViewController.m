//
//  ANUserListViewController.m
//  InstaInsta
//
//  Created by sush on 09.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANUserListViewController.h"
#import "ANUserPageViewController.h"
#import "ANUserListCell.h"

@interface ANUserListViewController ()

@property (strong, nonatomic) NSArray *userList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ANUserListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUserList];
    [self.tableView registerNib:[UINib nibWithNibName:@"ANUserListCell" bundle:nil] forCellReuseIdentifier:@"CustomCellReuseID"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadUserList
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [defaults valueForKey:@"AccessTokenKey"];
    [ANUserData getUsersByPath:self.path AccessToken:access_token block:^(NSArray *records) {
        self.userList = [records copy];
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (((ANUserData *)[self.userList objectAtIndex:([self.userList count] - 1)]).next_page)
        return [self.userList count] + 1;
    else
        return  [self.userList count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *CellIdentifier = @"CustomCellReuseID";
    ANUserListCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ANUserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    if (indexPath.row < [self.userList count]) {
        ANUserData *temp = [self.userList objectAtIndex:indexPath.row];
        [cell.cellitemLabel setText:temp.username];
        [cell.cellitemImageView setImage:[UIImage imageNamed:@"Screenshot.png"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:((ANUserData *)[self.userList objectAtIndex:indexPath.row]).profile_picture]]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [cell.cellitemImageView setImage:image];
            });
            
        });
    } else {
        [cell.cellitemLabel setText:@"Load more"];
        [cell.cellitemImageView setImage:[UIImage imageNamed:@"LoadMore.png"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.userList count]) {
        ANUserPageViewController *userpageController = [[ANUserPageViewController alloc] initWithNibName:@"ANUserPageViewController" bundle:nil];
        userpageController.user_id = ((ANUserData *)[self.userList objectAtIndex:indexPath.row]).user_id;
        [self.navigationController pushViewController:userpageController animated:YES];
    } else {
        //get more

        [ANUserData getUsersByExactPath:((ANUserData *)[self.userList objectAtIndex:([self.userList count] - 1)]).next_page block:^(NSArray *records) {
            self.userList = [self.userList arrayByAddingObjectsFromArray:[records copy]];
            [self.tableView reloadData];
        }]; 
    }
}

@end
