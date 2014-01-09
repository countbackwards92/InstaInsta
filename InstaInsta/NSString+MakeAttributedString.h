//
//  NSString+MakeAttributedString.h
//  InstaInsta
//
//  Created by sush on 08.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MakeAttributedString)

+ (NSAttributedString*) createStringFromString:(NSString*)string WithAttributes:(NSMutableDictionary *)attributes;

@end
