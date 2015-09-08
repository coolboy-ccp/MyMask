//
//  CircleBTN.h
//  MyMask
//
//  Created by liqunfei on 15/9/7.
//  Copyright (c) 2015年 chuchengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleBTN : UIView

@property (assign,nonatomic)BOOL isSelected;
@property (assign,nonatomic)BOOL topRightRadius;
@property (assign,nonatomic)BOOL topLeftRadius;
@property (assign,nonatomic)BOOL bottomRightRadius;
@property (assign,nonatomic)BOOL bottomLeftRadius;
@property (assign,nonatomic)CGFloat cornerRadius;
@property (weak,nonatomic)UIImage *backgroundImage;
@end
