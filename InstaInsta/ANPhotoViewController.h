//
//  ANPhotoViewController.h
//  InstaInsta
//
//  Created by sush on 05.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANPhotoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *URLString;
@property (strong, nonatomic) UIImage *initialImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *attr_items;
@property (strong, nonatomic) NSMutableArray *attrib;

- (void) updateText;

@end
