//
//  ANTagSearchViewController.m
//  InstaInsta
//
//  Created by sush on 08.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANTagSearchViewController.h"
#import "ANTagSearch.h"
#import "ANPopularViewController.h"

@interface ANTagSearchViewController ()

@property (strong, nonatomic) NSArray *searchResults;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ANTagSearchViewController

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
    [self.activityIndicator setHidden:YES];

    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANTagSearch *temp = [self.searchResults objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = [@"#" stringByAppendingString:temp.name];
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [defaults valueForKey:@"AccessTokenKey"];
    NSString *tag = searchBar.text;
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [ANTagSearch getSearchResultsWithTag:tag AccessToken:access_token block:^(NSArray *records) {
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        self.searchResults = records;
        [self.tableView reloadData];
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANPopularViewController *popController = [[ANPopularViewController alloc] initWithNibName:@"ANPopularViewController" bundle:nil];
    ANTagSearch *temp = [self.searchResults objectAtIndex:indexPath.row];
    popController.mediapath = [NSString stringWithFormat:@"tags/%@/media/recent",temp.name];
    popController.navigationItem.title = [[@"#" stringByAppendingString:temp.name] uppercaseString];
    [self.navigationController pushViewController:popController animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
    [aSearchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
    
}

@end
