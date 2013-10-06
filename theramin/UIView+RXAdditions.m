//
//  UIView+RXAdditions.m
//  remix
//
//  Created by Wen-Hao Lue on 2012-12-10.
//  Copyright (c) 2012 Team Remix. All rights reserved.
//

#import "UIView+RXAdditions.h"

@implementation UIView (RXAdditions)

#pragma mark - Frame Methods

#pragma mark frameX

- (CGFloat)frameX
{
    return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)frameX
{
    self.frame = CGRectMake(frameX, self.frameY, self.frameWidth, self.frameHeight);
}

#pragma mark frameY

- (CGFloat)frameY
{
    return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)frameY
{
    self.frame = CGRectMake(self.frameX, frameY, self.frameWidth, self.frameHeight);
}

#pragma mark frameBottom

- (CGFloat)frameBottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)frameBottom
{
    self.frame = CGRectMake(self.frameX, frameBottom - self.frameHeight, self.frameWidth, self.frameHeight);
}

#pragma mark frameRight

- (CGFloat)frameRight
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)frameRight
{
    self.frame = CGRectMake(frameRight - self.frameWidth, self.frameY, self.frameWidth, self.frameHeight);
}

#pragma mark frameWidth

- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)frameWidth
{
    self.frame = CGRectMake(self.frameX, self.frameY, frameWidth, self.frameHeight);
}

#pragma mark frameHeight

- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)frameHeight
{
    self.frame = CGRectMake(self.frameX, self.frameY, self.frameWidth, frameHeight);
}

#pragma mark frameOrigin

- (CGPoint)frameOrigin
{
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)point
{
    self.frame = CGRectMake(point.x, point.y, self.frameWidth, self.frameHeight);
}

#pragma mark frameSize

- (CGSize)frameSize
{
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)size
{
    self.frame = CGRectMake(self.frameX, self.frameY, size.width, size.height);
}

#pragma mark boundsX

- (CGFloat)boundsX
{
    return self.bounds.origin.x;
}

- (void)setBoundsX:(CGFloat)boundsX
{
    self.bounds = CGRectMake(boundsX, self.boundsY, self.boundsWidth, self.boundsHeight);
}

#pragma mark frameY

- (CGFloat)boundsY
{
    return self.bounds.origin.y;
}

- (void)setBoundsY:(CGFloat)boundsY
{
    self.bounds = CGRectMake(self.boundsX, boundsY, self.boundsWidth, self.boundsHeight);
}

#pragma mark boundsWidth

- (CGFloat)boundsWidth
{
    return self.bounds.size.width;
}

- (void)setBoundsWidth:(CGFloat)boundsWidth
{
    self.bounds = CGRectMake(0.0f, 0.0f, boundsWidth, self.boundsHeight);
}

#pragma mark boundsHeight

- (CGFloat)boundsHeight
{
    return self.bounds.size.height;
}

- (void)setBoundsHeight:(CGFloat)boundsHeight
{
    self.bounds = CGRectMake(0.0f, 0.0f, self.boundsWidth, boundsHeight);
}

#pragma mark boundsSize

- (CGSize)boundsSize
{
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)size
{
    self.bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
}

#pragma mark - Public Methods

- (NSArray *)recursiveSubviews
{
    NSMutableArray *array = [NSMutableArray array];

    [array addObject:self];
    for (UIView *view in self.subviews) {
        [array addObjectsFromArray:[view recursiveSubviews]];
    }

    return array;
}

@end
