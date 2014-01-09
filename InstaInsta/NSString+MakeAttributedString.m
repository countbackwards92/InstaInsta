//
//  NSString+MakeAttributedString.m
//  InstaInsta
//
//  Created by sush on 08.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "NSString+MakeAttributedString.h"
#import <UIKit/UIKit.h>

@implementation NSString (MakeAttributedString)

+ (NSAttributedString*) createStringFromString:(NSString*)string WithAttributes:(NSMutableDictionary *)attributes
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


@end
