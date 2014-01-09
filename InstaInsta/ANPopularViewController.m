//
//  ANPopularViewController.m
//  InstaInsta
//
//  Created by sush on 06.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANPopularViewController.h"
#import "ANCollectionViewCell.h"
#import "ANPopularMedia.h"
#import "ANInstagramClient.h"
#import "ANPopularDetailViewController.h"

@interface ANPopularViewController ()

@property (strong,nonatomic) NSMutableArray *popularPhotos;
@property (strong, nonatomic) NSMutableArray *media_ids;
@property (strong, nonatomic) NSMutableArray *user_avatars;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *images;
@end

@implementation ANPopularViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.popularPhotos = [[NSMutableArray alloc] init];
        self.media_ids = [[NSMutableArray alloc]init];
        self.user_avatars = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.popularPhotos = [[NSMutableArray alloc]init];//[NSArray arrayWithObjects:@"first.png", @"first.png",nil];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerClass:[ANCollectionViewCell class] forCellWithReuseIdentifier:@"CellCell"];
    [self loadPhotosToCollectionView];
    
    if ([self.mediapath isEqualToString:@"media/popular"])
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Load more" style:UIBarButtonItemStyleBordered target:self action:@selector(loadmore:)]];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (IBAction)loadmore:(id)sender
{
    [self loadPhotosToCollectionView];
}

- (void) loadPhotosToCollectionView
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [defaults valueForKey:@"AccessTokenKey"];
    
   // [self.activityIndicator startAnimating];
    
    [ANPopularMedia getMediWithPath:self.mediapath AccessToken:access_token block:^(NSArray *records) {
        NSUInteger initialCount = [self.popularPhotos count];
        NSUInteger photoNumber = initialCount;
        UIImage *blank = [UIImage imageNamed:@"Screenshot.png"];
        for (NSUInteger i = 0; i < [records count]; i++) {
            [self.popularPhotos addObject:blank];
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
              //          [self.activityIndicator setHidden:YES];
                //        [self.activityIndicator stopAnimating];
                        [self.popularPhotos setObject:image atIndexedSubscript:photoNumber];
                        [self.user_avatars setObject:avatarImage atIndexedSubscript:photoNumber];
                       // self.usernameLabel.text = media.username;
                     //   [self.avatarImageView setImage:avatarImage];
                        [self.collectionView reloadData];
                    });
                    
                });
                photoNumber = photoNumber + 1;
            }
        
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (((ANPopularMedia *)[self.images objectAtIndex:([self.images count] - 1)]).next_url)
        return self.popularPhotos.count + 1;
    else
        return self.popularPhotos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    if (indexPath.row < [self.popularPhotos count]) {
        imageView.image = [self.popularPhotos objectAtIndex:indexPath.row];
    } else {
        imageView.image = [UIImage imageNamed:@"LoadMore.png"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.images count]) {
        ANPopularDetailViewController *detailViewController = [[ANPopularDetailViewController alloc]initWithNibName:@"ANPopularDetailViewController" bundle:nil];
        detailViewController.navigationItem.title = @"Photo";
        detailViewController.imageUrl = ((ANPopularMedia *)[self.images objectAtIndex:indexPath.row]).standardUrl;//[self.standart_urls objectAtIndex:indexPath.row];
        detailViewController.incomingLikeCount = ((ANPopularMedia *) [self.images objectAtIndex:indexPath.row]).likes;//[[self.likes_counts objectAtIndex:indexPath.row] integerValue];
        detailViewController.media_id = ((ANPopularMedia *) [self.images objectAtIndex:indexPath.row]).media_id;
        detailViewController.user_avatar_image = [self.user_avatars objectAtIndex:indexPath.row];
        detailViewController.user_id = ((ANPopularMedia *) [self.images objectAtIndex:indexPath.row]).user_id;//[self.user_ids objectAtIndex:indexPath.row];
        detailViewController.username = ((ANPopularMedia *) [self.images objectAtIndex:indexPath.row]).username;//[self.usernames objectAtIndex:indexPath.row];
        detailViewController.tags = ((ANPopularMedia *) [self.images objectAtIndex:indexPath.row]).tags;
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else {
        [ANPopularMedia getMediaWithExactPath:(((ANPopularMedia *)[self.images objectAtIndex:([self.images count] - 1)]).next_url) block:^(NSArray *records) {
            if (!self.images)
                self.images = [records copy];
            else
                self.images = [self.images arrayByAddingObjectsFromArray:[records copy]];
            
            NSUInteger initialCount = [self.popularPhotos count];
            NSUInteger photoNumber = initialCount;
            
            for (ANPopularMedia* media in records) {
                if ([self.media_ids indexOfObject:media.media_id] == NSNotFound) {
                    UIImage *blank = [UIImage imageNamed:@"Screenshot.png"];
                    [self.popularPhotos addObject:blank];
                    [self.user_avatars addObject:blank];
                    [self.media_ids addObject:media.media_id];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
                        NSString *thumbnailUrl = media.thumbnailUrl;
                        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumbnailUrl]];
                        
                        UIImage *image = [UIImage imageWithData:data];
                        UIImage *avatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:media.user_avatar]]];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            //          [self.activityIndicator setHidden:YES];
                            //        [self.activityIndicator stopAnimating];
                            if (image)
                                [self.popularPhotos setObject:image atIndexedSubscript:photoNumber];
                            if (avatarImage)
                                [self.user_avatars setObject:avatarImage atIndexedSubscript:photoNumber];
                            // self.usernameLabel.text = media.username;
                            //   [self.avatarImageView setImage:avatarImage];
                            [self.collectionView reloadData];
                        });
                        
                    });
                    photoNumber = photoNumber + 1;
                }
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
