//
//  ANPopularDetailViewController.m
//  InstaInsta
//
//  Created by sush on 06.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANPopularDetailViewController.h"
#import "ANInstagramClient.h"

@interface ANPopularDetailViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;
@property (strong, nonatomic) UIImage *initialImage;
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    self.likesLabel.enabled = NO;
    self.likesButton.enabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        self.initialImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.activityIndicator setHidden:YES];
            [self.activityIndicator stopAnimating];
            [self showLikes];
            self.likesButton.enabled = YES;
            self.likesLabel.enabled = YES;
        });
    });
    // Do any additional setup after loading the view from its nib.
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

- (void) showLikes
{
    [self.imageView setImage:self.initialImage];
    self.likesLabel.text = [[NSString stringWithFormat:@"%lu",(unsigned long)self.incomingLikeCount] stringByAppendingString:@" likes"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
