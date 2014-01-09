//
//  ANUserPageViewController.m
//  InstaInsta
//
//  Created by sush on 08.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANUserPageViewController.h"
#import "ANPopularDetailViewController.h"
#import "ANCollectionViewCell.h"
#import "ANPopularMedia.h"
#import "ANUserData.h"
#import "ANUserListViewController.h"

@interface ANUserPageViewController ()
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *user_data;

@property (strong, nonatomic) NSMutableArray *media_ids;
//@property (strong, nonatomic) NSMutableArray *likes_counts;
//@property (strong, nonatomic) NSMutableArray *standart_urls;
//@property (strong, nonatomic) NSMutableArray *user_ids;
//@property (strong, nonatomic) NSMutableArray *usernames;
@property (strong, nonatomic) NSMutableArray *user_avatars;
@property (strong, nonatomic) NSMutableArray *user_photos;

@property (strong, nonatomic) IBOutlet UITableViewCell *avatarCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *photosCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *infocell;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (strong, nonatomic) NSArray *cells;

@property (weak, nonatomic) IBOutlet UIButton *followsButton;
@property (weak, nonatomic) IBOutlet UIButton *followedButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ANUserPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.user_photos = [[NSMutableArray alloc] init];
        self.media_ids = [[NSMutableArray alloc]init];
        self.user_avatars = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerClass:[ANCollectionViewCell class] forCellWithReuseIdentifier:@"CellCell"];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self loadPhotosToCollectionView];

    self.cells = [NSArray arrayWithObjects:self.avatarCell, self.infocell, self.photosCell, nil];
    for (UITableViewCell *cell in self.cells)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self getUserInfo];
    


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

- (void) loadPhotosToCollectionView
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [defaults valueForKey:@"AccessTokenKey"];
    
    self.usernameLabel.text = @"";
    
    [self.activityIndicator startAnimating];
    
    [ANPopularMedia getMediWithPath:[NSString stringWithFormat:@"users/%@/media/recent",self.user_id] AccessToken:access_token block:^(NSArray *records) {

        NSUInteger initialCount = [self.user_photos count];
        NSUInteger photoNumber = initialCount;
        
        UIImage *blank = [UIImage imageNamed:@"Screenshot.png"];
        for (NSUInteger i = 0; i < [records count]; i++) {
            [self.user_photos addObject:blank];
            [self.user_avatars addObject:blank];
            [self.media_ids addObject:((ANPopularMedia*)records[i]).media_id];
        }
        if (!self.images)
            self.images = [records copy];
        else
            self.images = [self.images arrayByAddingObjectsFromArray:[records copy]];
        

        
        for (ANPopularMedia* media in records) {

                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
                    NSString *thumbnailUrl = media.thumbnailUrl;
                    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumbnailUrl]];

                    UIImage *image = [UIImage imageWithData:data];
                    UIImage *avatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:media.user_avatar]]];

                        
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self.activityIndicator setHidden:YES];
                        [self.activityIndicator stopAnimating];
                        [self.user_photos setObject:image atIndexedSubscript:photoNumber];
                        [self.user_avatars setObject:avatarImage atIndexedSubscript:photoNumber];
                        self.usernameLabel.text = media.username;
                        [self.avatarImageView setImage:avatarImage];
                        [self.collectionView reloadData];
                    });
                    
                });
                photoNumber = photoNumber + 1;
            
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (((ANPopularMedia *)[self.images objectAtIndex:([self.images count] - 1)]).next_url) {
        return self.user_photos.count + 1;
    } else {
        return self.user_photos.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    if (indexPath.row < self.user_photos.count) {
        imageView.image = [self.user_photos objectAtIndex:indexPath.row];
    } else {
        imageView.image = [UIImage imageNamed:@"LoadMore.png"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.user_photos.count) {
        ANPopularDetailViewController *detailViewController = [[ANPopularDetailViewController alloc]initWithNibName:@"ANPopularDetailViewController" bundle:nil];
        detailViewController.navigationItem.title = @"Photo";
        detailViewController.imageUrl = ((ANPopularMedia *)[self.images objectAtIndex:indexPath.row]).standardUrl;
        detailViewController.incomingLikeCount = ((ANPopularMedia* )[self.images objectAtIndex:indexPath.row]).likes;
        detailViewController.media_id = [self.media_ids objectAtIndex:indexPath.row];
        detailViewController.user_avatar_image = [self.user_avatars objectAtIndex:indexPath.row];
        detailViewController.user_id = ((ANPopularMedia *)[self.images objectAtIndex:indexPath.row]).user_id;
        detailViewController.username = ((ANPopularMedia *)[self.images objectAtIndex:indexPath.row]).username;
        detailViewController.tags = ((ANPopularMedia *)[self.images objectAtIndex:indexPath.row]).tags;
        detailViewController.user_has_liked = ((ANPopularMedia *)[self.images objectAtIndex:indexPath.row]).user_has_liked;
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else {
        [ANPopularMedia getMediaWithExactPath:((ANPopularMedia *)[self.images objectAtIndex:([self.images count] - 1)]).next_url block:^(NSArray *records) {
            
            self.images = [self.images arrayByAddingObjectsFromArray:records];
            
            NSUInteger initialCount = [self.user_photos count];
            NSUInteger photoNumber = initialCount;
            
            for (ANPopularMedia* media in records) {
                if ([self.media_ids indexOfObject:media.media_id] == NSNotFound) {
                    UIImage *blank = [UIImage imageNamed:@"Screenshot.png"];
                    [self.user_photos addObject:blank];
                    [self.user_avatars addObject:blank];
                    [self.media_ids addObject:media.media_id];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
                        NSString *thumbnailUrl = media.thumbnailUrl;
                        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumbnailUrl]];
                        
                        UIImage *image = [UIImage imageWithData:data];
                        UIImage *avatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:media.user_avatar]]];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [self.activityIndicator setHidden:YES];
                            [self.activityIndicator stopAnimating];
                            [self.user_photos setObject:image atIndexedSubscript:photoNumber];
                            [self.user_avatars setObject:avatarImage atIndexedSubscript:photoNumber];
                            self.usernameLabel.text = media.username;
                            [self.avatarImageView setImage:avatarImage];

                            [self.collectionView reloadData];
                        });
                        
                    });
                    photoNumber = photoNumber + 1;
                }
            }

        }];
    }
}

- (void)getUserInfo
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [defaults valueForKey:@"AccessTokenKey"];
    [ANUserData getUserDataByUserId:self.user_id AccessToken:access_token block:^(NSArray *records) {
        self.user_data = [records copy];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self.followsButton setTitle:[NSString stringWithFormat:@"Follows: %lu",(unsigned long)((ANUserData *)[self.user_data objectAtIndex:0]).follows_count]  forState:UIControlStateNormal];

            
            [self.followedButton setTitle:[NSString stringWithFormat:@"Followed by: %lu",(unsigned long)((ANUserData *)[self.user_data objectAtIndex:0]).followedby_count]  forState:UIControlStateNormal];
            [self.followsButton setHidden:NO];
            [self.followedButton setHidden:NO];
        });
    }];
}

- (IBAction)followsTap:(id)sender {
    ANUserListViewController *userlistController = [[ANUserListViewController alloc] initWithNibName:@"ANUserListViewController" bundle:nil];
    NSString *path = [NSString stringWithFormat:@"users/%@/follows",self.user_id];
    userlistController.path = path;
    [self.navigationController pushViewController:userlistController animated:YES];
}

- (IBAction)followedbyTap:(id)sender {
    ANUserListViewController *userlistController = [[ANUserListViewController alloc] initWithNibName:@"ANUserListViewController" bundle:nil];
    NSString *path = [NSString stringWithFormat:@"users/%@/followed-by",self.user_id];
    userlistController.path = path;
    [self.navigationController pushViewController:userlistController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.hide_bar)
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.hide_bar)
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}



@end
