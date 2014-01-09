//
//  ANPopularDetailViewController.m
//  InstaInsta
//
//  Created by sush on 06.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANPopularDetailViewController.h"
#import "ANInstagramClient.h"
#import "ANUserPageViewController.h"
#import "ANPhotoViewController.h"

@interface ANPopularDetailViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (strong, nonatomic) UIImage *initialImage;
@property (strong, nonatomic) IBOutlet UITableViewCell *photoCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *userCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *likesCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *addcaptionCell;

@property (weak, nonatomic) IBOutlet UIImageView *avatarLabel;

@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (strong, nonatomic) NSArray *cells;
@end

@implementation ANPopularDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)touchAndLike:(id)sender {
    
}

- (IBAction)addTextTap:(id)sender {
    ANPhotoViewController *photoEditController = [[ANPhotoViewController alloc] initWithNibName:@"ANPhotoViewController" bundle:nil];
    photoEditController.initialImage = self.imageView.image;
    [self.navigationController pushViewController:photoEditController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cells count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cells objectAtIndex:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.cells objectAtIndex:indexPath.row];
    return cell.bounds.size.height;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    self.likesLabel.text = [[NSString stringWithFormat:@"%lu",(unsigned long)self.incomingLikeCount] stringByAppendingString:@" likes"];
    [self.usernameButton setTitle:self.username forState:UIControlStateNormal];
    
    self.cells = [NSArray arrayWithObjects:self.userCell, self.photoCell, self.likesCell, self.addcaptionCell, nil];
    for (UITableViewCell *cell in self.cells)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.user_avatar_image)
        [self.avatarLabel setImage:self.user_avatar_image];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        UIImage *avatarImage;
        if (!self.user_avatar_image)
            avatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: self.user_avatar]]];
        self.initialImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.activityIndicator setHidden:YES];
            [self.activityIndicator stopAnimating];
            [self.imageView setImage:self.initialImage];
            if (!self.user_avatar_image)
                [self.avatarLabel setImage:avatarImage];
        });
    });
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)userpageTap:(id)sender {
    ANUserPageViewController *userpageController = [[ANUserPageViewController alloc] initWithNibName:@"ANUserPageViewController" bundle:nil];
    userpageController.user_id = self.user_id;
    [self.navigationController pushViewController:userpageController animated:YES];
}

- (IBAction)LIKELIKE:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [defaults valueForKey:@"AccessTokenKey"];
    
    NSDictionary* params = [NSDictionary dictionaryWithObject:access_token forKey:@"access_token"];
    NSString* path = [NSString stringWithFormat:@"media/%@/likes",self.media_id];
    
    [[ANInstagramClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIAlertView *alertOk = [[UIAlertView alloc] initWithTitle:@"InstaInsta" message:@"Like added!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertOk show];
    } failure:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIAlertView *alertOk = [[UIAlertView alloc] initWithTitle:@"InstaInsta" message:@"Like edding error :(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertOk show];
    }];
     
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
