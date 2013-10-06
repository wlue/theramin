//
//  UIView+RXAdditions.h
//  remix
//
//  Created by Wen-Hao Lue on 2012-12-10.
//  Copyright (c) 2012 Team Remix. All rights reserved.
//

@interface UIView (RXAdditions)

@property (nonatomic, assign) CGFloat frameX;
@property (nonatomic, assign) CGFloat frameY;
@property (nonatomic, assign) CGFloat frameBottom;
@property (nonatomic, assign) CGFloat frameRight;

@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;
@property (nonatomic, assign) CGPoint frameOrigin;
@property (nonatomic, assign) CGSize frameSize;

@property (nonatomic, assign) CGFloat boundsX;
@property (nonatomic, assign) CGFloat boundsY;
@property (nonatomic, assign) CGFloat boundsWidth;
@property (nonatomic, assign) CGFloat boundsHeight;
@property (nonatomic, assign) CGSize boundsSize;

- (NSMutableArray *)recursiveSubviews;

@end
