//
//  CircleBTN.m
//  MyMask
//
//  Created by liqunfei on 15/9/7.
//  Copyright (c) 2015年 chuchengpeng. All rights reserved.
//

#import "CircleBTN.h"

@interface CircleBTN ()

@property (strong,nonatomic)UIColor *bgColor;

@end

@implementation CircleBTN

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(_bottomLeftRadius?UIRectCornerBottomLeft:0) | (_bottomRightRadius?UIRectCornerBottomRight:0) | (_topLeftRadius?UIRectCornerTopLeft:0) | (_topRightRadius?UIRectCornerTopRight:0) cornerRadii:CGSizeMake(_cornerRadius, 0.f)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextAddRect(context, rect);
    CGContextSetFillColorWithColor(context, [self bgColor].CGColor);
    CGContextFillPath(context);
    if (_backgroundImage) {
        [_backgroundImage drawInRect:rect];
    }
}

- (instancetype)init {
    if (self = [super init]) {
        self.isSelected = NO;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    _bgColor = backgroundColor;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected == YES) {
        self.backgroundColor = [UIColor grayColor];
    }
    else {
        self.backgroundColor = [UIColor blackColor];
    }
}

@end
