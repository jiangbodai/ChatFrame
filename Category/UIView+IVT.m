//
//  UIView+NJ.m
//  传智微博
//
//  Created by apple on 14-7-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIView+IVT.h"

@implementation UIView (IVT)

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect bounds = self.frame;
    bounds.size.width = width;
    self.frame = bounds;
}

- (CGFloat)width
{
    return self.bounds.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect bounds = self.frame;
    bounds.size.height = height;
    self.frame = bounds;
}

- (CGFloat)height
{
    return self.bounds.size.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

@end
