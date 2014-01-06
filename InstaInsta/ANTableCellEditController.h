//
//  ANTableCellEditController.h
//  homework_1
//
//  Created by Администратор on 11/17/13.
//  Copyright (c) 2013 MSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANTableCellEditController : UIViewController

@property (strong, nonatomic) NSMutableString *initialString;
@property BOOL isInitBold;
@property BOOL isInitItalic;
@property float initColor;
@property float initFontSize;

@property (nonatomic) NSUInteger indexindex;
- (IBAction)doneEditing:(id)sender;
@end
