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
#import "ANButtonCollectionViewCell.h"
#import "ANPopularViewController.h"
#import "ANPopularMedia.h"
#import "ANPhotoData.h"

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
@property (strong, nonatomic) IBOutlet UITableViewCell *tagsCell;

@property (weak, nonatomic) IBOutlet UICollectionView *tagsCollectionView;
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

      //  self.tags = @[@"lol", @"lmao"];
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
    if (indexPath.row != 2) {
        UITableViewCell *cell = [self.cells objectAtIndex:indexPath.row];
        return cell.bounds.size.height;
    } else { //tags view
        return [self.tagsCollectionView.collectionViewLayout collectionViewContentSize].height + 15.0f;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];

    [self.usernameButton setTitle:self.username forState:UIControlStateNormal];
    
    self.cells = [NSArray arrayWithObjects:self.userCell, self.photoCell, self.tagsCell, self.likesCell, nil];
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
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Add caption" style:UIBarButtonItemStyleBordered target:self action:@selector(addTextTap:)]];
    [self.tagsCollectionView setBackgroundColor:[UIColor whiteColor]];
    [self.tagsCollectionView registerNib:[UINib nibWithNibName:@"ANButtonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CellButton"];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [defaults valueForKey:@"AccessTokenKey"];
    [ANPhotoData getPhotoDataByMediaId:self.media_id AccessToken:access_token block:^(NSArray *records) {
        ANPhotoData *data = [records objectAtIndex:0];
        self.user_has_liked = data.user_has_liked;
        self.incomingLikeCount = data.likes_count;
        if (self.user_has_liked) {
            [self.likesButton setTitle:@"💙Dislike" forState:UIControlStateNormal];
        } else {
            [self.likesButton setTitle:@"❤Like" forState:UIControlStateNormal];
        }
        if (self.incomingLikeCount != 1)
            self.likesLabel.text = [[NSString stringWithFormat:@"%lu",(unsigned long)self.incomingLikeCount] stringByAppendingString:@" likes"];
        else
            self.likesLabel.text = [[NSString stringWithFormat:@"%lu",(unsigned long)self.incomingLikeCount] stringByAppendingString:@" like"];

    }];
  //  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  //  [flowLayout setItemSize:CGSizeMake(100, 30)];
  //  [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
   // [self.tagsCollectionView setCollectionViewLayout:flowLayout ];
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
    
    if (!self.user_has_liked) {
        [[ANInstagramClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.likesButton setTitle:@"💙Dislike" forState:UIControlStateNormal];
            self.user_has_liked = !self.user_has_liked;
            self.incomingLikeCount = self.incomingLikeCount + 1;
            if (self.incomingLikeCount != 1)
                self.likesLabel.text = [[NSString stringWithFormat:@"%lu",(unsigned long)self.incomingLikeCount] stringByAppendingString:@" likes"];
            else
                self.likesLabel.text = [[NSString stringWithFormat:@"%lu",(unsigned long)self.incomingLikeCount] stringByAppendingString:@" like"];
        } failure:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIAlertView *alertOk = [[UIAlertView alloc] initWithTitle:@"InstaInsta" message:@"Like edding error :(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertOk show];
        }];
        
    } else {
        [[ANInstagramClient sharedClient] deletePath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.likesButton setTitle:@"❤Like" forState:UIControlStateNormal];
            self.user_has_liked = !self.user_has_liked;
            self.incomingLikeCount = self.incomingLikeCount - 1;
            if (self.incomingLikeCount != 1)
                self.likesLabel.text = [[NSString stringWithFormat:@"%lu",(unsigned long)self.incomingLikeCount] stringByAppendingString:@" likes"];
            else
                self.likesLabel.text = [[NSString stringWithFormat:@"%lu",(unsigned long)self.incomingLikeCount] stringByAppendingString:@" like"];
        } failure:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIAlertView *alertOk = [[UIAlertView alloc] initWithTitle:@"InstaInsta" message:@"Error :(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertOk show];
        }];

    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tags count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellButton";
    
    ANButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.buttonView setTitle:[@"#" stringByAppendingString:[self.tags objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    [cell.buttonView setTag:indexPath.row];
    [cell.buttonView addTarget:self action:@selector(sendTag:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (IBAction)sendTag:(id)sender
{
    ANPopularViewController *popController = [[ANPopularViewController alloc] initWithNibName:@"ANPopularViewController" bundle:nil];

    popController.mediapath = [NSString stringWithFormat:@"tags/%@/media/recent",[self.tags objectAtIndex:[sender tag]]];
    popController.navigationItem.title = [[@"#" stringByAppendingString:[self.tags objectAtIndex:[sender tag]]] uppercaseString];
    [self.navigationController pushViewController:popController animated:YES];
}

#define PADDING 15.0f



 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [@"#" stringByAppendingString:[self.tags objectAtIndex:indexPath.row]];
    
   // CGSize textSize = [attr_text boundingRectWithSize:CGSizeMake(self.tagsCollectionView.frame.size.width - PADDING * 3, 1000.0f)  options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
       CGSize textSize = [text boundingRectWithSize:CGSizeMake(self.tagsCollectionView.frame.size.width - PADDING * 3, 20.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],} context:nil].size;
    
    return textSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
