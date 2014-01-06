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
@property (strong, nonatomic) NSMutableArray *likes_counts;
@property (strong, nonatomic) NSMutableArray *standart_urls;
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
        self.likes_counts = [[NSMutableArray alloc]init];
        self.standart_urls = [[NSMutableArray alloc]init];
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
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Load more" style:UIBarButtonItemStyleBordered target:self action:@selector(loadmore:)]];
}

- (IBAction)loadmore:(id)sender
{
    [self loadPhotosToCollectionView];
}

- (void) loadPhotosToCollectionView
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [defaults valueForKey:@"AccessTokenKey"];

    [ANPopularMedia getPopularMediWithAccessToken:access_token block:^(NSArray *records) {
        self.images = records;
        for (ANPopularMedia* media in records) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
                NSString* thumbnailUrl = media.thumbnailUrl;
                NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumbnailUrl]];
                UIImage* image = [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    if ([self.media_ids indexOfObject:media.media_id] == NSNotFound) {
                        [self.popularPhotos addObject:image];
                        [self.media_ids addObject:media.media_id];
                        [self.likes_counts addObject:[NSString stringWithFormat:@"%lu",(unsigned long)media.likes]];
                        [self.standart_urls addObject:media.standardUrl];
                        [self.collectionView reloadData];
                    }
                });
            });
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.popularPhotos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [self.popularPhotos objectAtIndex:indexPath.row];//[UIImage imageNamed:[self.popularPhotos objectAtIndex:indexPath.row]];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ANPopularDetailViewController *detailViewController = [[ANPopularDetailViewController alloc]initWithNibName:@"ANPopularDetailViewController" bundle:nil];
    detailViewController.navigationItem.title = @"Photo";
    detailViewController.imageUrl = [self.standart_urls objectAtIndex:indexPath.row];
    detailViewController.incomingLikeCount = [[self.likes_counts objectAtIndex:indexPath.row] integerValue];
    detailViewController.media_id = [self.media_ids objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
