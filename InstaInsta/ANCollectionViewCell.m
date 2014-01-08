//
//  ANCollectionViewCell.m
//  InstaInsta
//
//  Created by sush on 06.01.14.
//  Copyright (c) 2014 MSU. All rights reserved.
//

#import "ANCollectionViewCell.h"

@implementation ANCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imagView = [[UIImageView alloc] init];
        imagView.frame = self.contentView.bounds;
        [self.contentView addSubview:imagView];
        imagView.tag = 100;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
