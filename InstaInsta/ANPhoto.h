//
//  ANPhoto.h
//  InstaInsta
//
//  Created by sush on 09.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ANPhoto : NSObject

@property (nonatomic) NSUInteger likes_count;
@property (strong, nonatomic) NSString *media_id;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSData *avatar_photo;
@property (strong, nonatomic) NSData *photo;

@property (strong, nonatomic) UIImage *avatar_photo_img;
@property (strong, nonatomic) UIImage *photo_img;
@end
