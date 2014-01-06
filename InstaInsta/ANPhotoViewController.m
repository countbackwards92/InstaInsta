//
//  ANPhotoViewController.m
//  InstaInsta
//
//  Created by sush on 05.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANPhotoViewController.h"
#import <RestKit.h>
#import "ANTableViewController.h"
@interface ANPhotoViewController ()

@property (strong, nonatomic) UIImage *initialImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@end

@implementation ANPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


+(UIImage *) drawAttributedText:(NSAttributedString*)text
                        inImage:(UIImage*)image
                        atPoint:(CGPoint)point
{

    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

+(UIImage *) drawAttributedTextNew:(NSAttributedString*)text
                        inImage:(UIImage*)image
                        atPoint:(CGPoint)point
{
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    [text drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //  self.linkField.text = self.URLString;
   // [self.imageView setImageWithURL:[NSURL URLWithString:self.URLString] placeholderImage:nil];


    [self.navigationItem setTitle:@"Photo"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit text" style:UIBarButtonItemStyleBordered target:self action:@selector(editAction:)] animated:YES];
//    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"User feed" style:UIBarButtonItemStyleBordered target:nil action:)]]
    
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    self.saveButton.enabled = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        self.initialImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.URLString]]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.activityIndicator setHidden:YES];
            [self.activityIndicator stopAnimating];
            [self updateText];
            self.saveButton.enabled = YES;
        });
    });
    
}
- (IBAction)saveToLibrary:(id)sender {
    [self.activityIndicator setHidden:NO];
   [self.activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.activityIndicator setHidden:YES];
            [self.activityIndicator stopAnimating];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Image saved" message:@"Yeah!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        });
    });

}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateText];
}

#define PADDING 15.0f
- (CGFloat) textHeight:(NSAttributedString *)attr_text
           forWidth:(CGFloat)width
{
    CGSize textSize = [attr_text boundingRectWithSize:CGSizeMake(width, 1000.0f)  options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return textSize.height + PADDING * 3;
}

- (void) updateText
{
    CGPoint hereWeWrite = CGPointMake(50, 50);
    UIImage *temp = [self.initialImage copy];
    for (NSAttributedString *str in self.attr_items) {
        hereWeWrite.y += [self textHeight:str forWidth:[temp size].width];
        temp = [ANPhotoViewController drawAttributedText:str inImage:temp atPoint:hereWeWrite];
    }
    [self.imageView setImage:temp];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"Attributes"];
    [defaults removeObjectForKey:@"Items"];
    [defaults setObject:self.attrib forKey:@"Attributes"];
    [defaults setObject:self.items forKey:@"Items"];
  //  [defaults setObject:self.attr_items forKey:@"AttributedItems"];
    [defaults synchronize];
}


- (IBAction)editAction:(id)sender
{
    ANTableViewController *tableview = [[ANTableViewController alloc]initWithNibName:@"ANTableViewController" bundle:nil];
    tableview.items = self.items;
    tableview.attr_items = self.attr_items;
    tableview.attrib = self.attrib;
    [self.navigationController pushViewController:tableview animated:YES];
}

- (IBAction)gotoEditing:(id)sender {


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
