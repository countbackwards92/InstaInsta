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

@interface ANUserPageViewController ()
@property (strong, nonatomic) NSMutableArray *media_ids;
@property (strong, nonatomic) NSMutableArray *likes_counts;
@property (strong, nonatomic) NSMutableArray *standart_urls;
@property (strong, nonatomic) NSMutableArray *user_ids;
@property (strong, nonatomic) NSMutableArray *usernames;
@property (strong, nonatomic) NSMutableArray *user_avatars;
@property (strong, nonatomic) NSMutableArray *user_photos;

@property (strong, nonatomic) IBOutlet UITableViewCell *avatarCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *photosCell;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (strong, nonatomic) NSArray *cells;



@end

@implementation ANUserPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.user_photos = [[NSMutableArray alloc] init];
        self.media_ids = [[NSMutableArray alloc]init];
        self.likes_counts = [[NSMutableArray alloc]init];
        self.standart_urls = [[NSMutableArray alloc]init];
        self.user_ids = [[NSMutableArray alloc]init];
        self.usernames = [[NSMutableArray alloc] init];
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

    self.cells = [NSArray arrayWithObjects:self.avatarCell, self.photosCell, nil];
    for (UITableViewCell *cell in self.cells)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

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
    
    [ANPopularMedia getMediWithPath:[NSString stringWithFormat:@"users/%@/media/recent",self.user_id] AccessToken:access_token block:^(NSArray *records) {
       // self.images = records;
        for (ANPopularMedia* media in records) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
                NSString *thumbnailUrl = media.thumbnailUrl;
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumbnailUrl]];
                UIImage *image = [UIImage imageWithData:data];
                UIImage *avatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:media.user_avatar]]];
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    if ([self.media_ids indexOfObject:media.media_id] == NSNotFound) {
                        [self.user_photos addObject:image];
                        [self.media_ids addObject:media.media_id];
                        [self.likes_counts addObject:[NSString stringWithFormat:@"%lu",(unsigned long)media.likes]];
                        [self.standart_urls addObject:media.standardUrl];
                        [self.usernames addObject:media.username];
                        [self.user_ids addObject:media.user_id];
                        [self.user_avatars addObject:media.user_avatar];
                        self.usernameLabel.text = media.username;
                        [self.avatarImageView setImage:avatarImage];
                        [self.collectionView reloadData];
                    }
                });
            });
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.user_photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [self.user_photos objectAtIndex:indexPath.row];//[UIImage imageNamed:[self.popularPhotos objectAtIndex:indexPath.row]];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ANPopularDetailViewController *detailViewController = [[ANPopularDetailViewController alloc]initWithNibName:@"ANPopularDetailViewController" bundle:nil];
    detailViewController.navigationItem.title = @"Photo";
    detailViewController.imageUrl = [self.standart_urls objectAtIndex:indexPath.row];
    detailViewController.incomingLikeCount = [[self.likes_counts objectAtIndex:indexPath.row] integerValue];
    detailViewController.media_id = [self.media_ids objectAtIndex:indexPath.row];
    detailViewController.user_avatar = [self.user_avatars objectAtIndex:indexPath.row];
    detailViewController.user_id = [self.user_ids objectAtIndex:indexPath.row];
    detailViewController.username = [self.usernames objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
