//
//  ANImages.h
//  InstaInsta
//
//  Created by sush on 05.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ANLowRes, ANPost, ANStandRes, ANThumb;

@interface ANImages : NSManagedObject

@property (nonatomic, retain) ANLowRes *low_resolution;
@property (nonatomic, retain) ANPost *post;
@property (nonatomic, retain) ANStandRes *standard_resolution;
@property (nonatomic, retain) ANThumb *thumbnail;

@end
