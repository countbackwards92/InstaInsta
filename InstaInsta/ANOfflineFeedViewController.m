//
//  ANOfflineFeedViewController.m
//  InstaInsta
//
//  Created by sush on 09.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANOfflineFeedViewController.h"
#import "ANCollectionViewCell.h"
#import "ANAppDelegate.h"
#import "ANPopularDetailViewController.h"

@interface ANOfflineFeedViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *photos;

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation ANOfflineFeedViewController

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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerClass:[ANCollectionViewCell class] forCellWithReuseIdentifier:@"CellCell"];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view from its nib.
    ANAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.context = [appDelegate managedObjectContext];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    // NSPredicate predicate = [[NSPredicate alloc] init];
    NSError *error;
    NSArray *matchingData = [self.context executeFetchRequest:fetchRequest error:&error];
    
    self.photos = matchingData;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];

    imageView.image = [UIImage imageWithData:[[self.photos objectAtIndex:indexPath.row] valueForKey:@"photo"]];

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ANPopularDetailViewController *detailController = [[ANPopularDetailViewController alloc] initWithNibName:@"ANPopularDetailViewController" bundle:nil];
    detailController.preloaded_image = [UIImage imageWithData:[[self.photos objectAtIndex:indexPath.row] valueForKey:@"photo"]];
    detailController.username = [[self.photos objectAtIndex:indexPath.row] valueForKey:@"username"];
    detailController.media_id = [[self.photos objectAtIndex:indexPath.row] valueForKey:@"media_id"];
    detailController.incomingLikeCount = [[[self.photos objectAtIndex:indexPath.row] valueForKey:@"likes_count"] integerValue];
    detailController.user_avatar_image = [UIImage imageWithData:[[self.photos objectAtIndex:indexPath.row]valueForKey:@"avatar_photo"]];
    detailController.offline_mode = YES;
    [self.navigationController pushViewController:detailController animated:YES];
}


@end
