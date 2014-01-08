//
//  ANStandRes.h
//  InstaInsta
//
//  Created by sush on 05.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ANImages;

@interface ANStandRes : NSManagedObject

@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) ANImages *image;

@end
