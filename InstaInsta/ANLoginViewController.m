//
//  ANLoginViewController.m
//  InstaInsta
//
//  Created by Администратор on 1/3/14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANLoginViewController.h"

@interface ANLoginViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation ANLoginViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Login Screen";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *authString = @"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token";
    NSString * const clientId = @"2c0b70e803cc4cc6b157519fcff40924";
    NSString * const redirectUrl = @"http://localhost:3000";
    
    self.webView.delegate = self;
    NSURLRequest* request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:
                                  [NSString stringWithFormat:authString, clientId, redirectUrl]]];
    [self.webView loadRequest:request];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{		
    NSString *lol = request.URL.absoluteString;
    if ([request.URL.absoluteString rangeOfString:@"#"].location != NSNotFound) {
        
        NSString* params = [[request.URL.absoluteString componentsSeparatedByString:@"#"] objectAtIndex:1];
        self.accessToken = [params stringByReplacingOccurrencesOfString:@"access_token=" withString:@""];

        [self.tabBarController enableAllDeleteCurrent];
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.accessToken forKey:@"AccessTokenKey"];
        [defaults synchronize];

    }
    
	return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
     NSObject *hereweare = [defaults objectForKey:@"AccessTokenKey"];
     if (!hereweare) {
     UIAlertView *offlinealert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet connection - no offline data stored" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [offlinealert show];
     } else {
     UIAlertView *offlinealert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet connection - running in offline mode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [offlinealert show];
     [self.tabBarController enableAllDeleteCurrent];
     }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.loadingIndicator startAnimating];
    [self.loadingIndicator setHidden:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingIndicator stopAnimating];
    [self.loadingIndicator setHidden:YES];
}
@end
