//
//  RoundedImageView.m
//  CBLiteCRM
//
//  Created by Andrew on 12.12.13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "RoundedImageView.h"

#import <QuartzCore/QuartzCore.h>

@implementation RoundedImageView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self  addCircleMaskToBounds:frame];
}

- (void)addCircleMaskToBounds:(CGRect)maskBounds
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.bounds    = maskBounds;
    maskLayer.path      = CGPathCreateWithEllipseInRect(maskBounds, NULL);
    maskLayer.position  = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2);

    maskLayer.shouldRasterize    = YES;
    maskLayer.rasterizationScale = [UIScreen mainScreen].scale;

    self.layer.mask = maskLayer;
}

@end
