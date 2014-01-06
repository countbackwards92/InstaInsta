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

+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:50];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withAttributes:attributes];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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

- (NSAttributedString*) createStringFromString:(NSString*)string WithAttributes:(NSMutableDictionary *)attributes
{
    NSMutableAttributedString *result;
    UIFont *currentFont;
    BOOL italicIsOn = [[attributes valueForKey:@"Italic"] boolValue];
    BOOL boldIsOn = [[attributes valueForKey:@"Bold"] boolValue];
    float textSize = [[attributes valueForKey:@"Size"] floatValue];
    float textColor = [[attributes valueForKey:@"Color"] floatValue];
    
    if (italicIsOn && boldIsOn) {
        currentFont = [UIFont fontWithName:@"Helvetica-BoldOblique" size:(textSize + 0.1) * 100];
    } else if (boldIsOn) {
        currentFont = [UIFont fontWithName:@"Helvetica-Bold" size:(textSize + 0.1) * 100];
    } else if (italicIsOn) {
        currentFont = [UIFont fontWithName:@"Helvetica-Oblique" size:(textSize + 0.1) * 100];
    } else {
        currentFont = [UIFont fontWithName:@"Helvetica" size:(textSize + 0.1) * 100];
    }
    
    result = [[NSMutableAttributedString alloc] initWithString:string];
    [result addAttribute:NSFontAttributeName value:currentFont range:NSMakeRange(0,[string length])];
    [result addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHue:textColor saturation:1 brightness:1 alpha:1.0] range:NSMakeRange(0,[string length])];

    return result;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //  self.linkField.text = self.URLString;
   // [self.imageView setImageWithURL:[NSURL URLWithString:self.URLString] placeholderImage:nil];
    self.initialImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.URLString]]];

    [self.navigationItem setTitle:@"Photo"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit text" style:UIBarButtonItemStyleBordered target:self action:@selector(editAction:)] animated:YES];
//    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"User feed" style:UIBarButtonItemStyleBordered target:nil action:)]]
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  //  self.attr_items = [defaults objectForKey:@"AttributedItems"];
    self.items = [defaults objectForKey:@"Items"];
    self.attrib = [defaults objectForKey:@"Attributes"];
    
    //SET ATTRIB_ITEMS
    for (NSUInteger i = 0; i < [self.items count]; ++i) {
        [self.attr_items addObject:[self createStringFromString:[self.items objectAtIndex:i] WithAttributes:[self.attrib objectAtIndex:i]]];
    }
    
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
    
    //   CGSize textSize = [text boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - PADDING * 3, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],} context:nil].size;
    
    return textSize.height + PADDING * 3;
}

- (void) updateText
{
    CGPoint hereWeWrite = CGPointMake(0, 0);
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

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

- (NSMutableArray *)attrib
{
    if (!_attrib) {
        _attrib = [[NSMutableArray alloc] init];
    }
    return _attrib;
}

- (NSMutableArray *)attr_items
{
    if (!_attr_items) {
        _attr_items = [[NSMutableArray alloc] init];
    }
    return _attr_items;
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
