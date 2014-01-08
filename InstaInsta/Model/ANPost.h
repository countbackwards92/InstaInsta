//
//  ANPost.h
//  InstaInsta
//
//  Created by sush on 05.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ANImages;

@interface ANPost : NSManagedObject

@property (nonatomic, retain) NSString * caption_text;
@property (nonatomic, retain) NSNumber * created_time;
@property (nonatomic, retain) NSData * img;
@property (nonatomic, retain) NSNumber * likes_count;
@property (nonatomic, retain) NSNumber * post_id;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) ANImages *images;

@end
