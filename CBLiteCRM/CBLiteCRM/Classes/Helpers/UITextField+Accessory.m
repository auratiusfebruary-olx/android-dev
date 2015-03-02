//
//  UITextField+Accessory.m
//  CBLiteCRM
//
//  Created by Andrew on 06.01.14.
//  Copyright (c) 2014 Couchbase. All rights reserved.
//

#import "UITextField+Accessory.h"

@implementation UITextField (Accessory)


- (void) setRightViewImage:(UIImage*)image
{
    self.rightView     = [self createImageViewWithImage:image];
//    self.rightViewMode = UITextFieldViewModeAlways;
}

#pragma mark -

- (UIImageView *)createImageViewWithImage:(UIImage *)image
{
    UIImageView *
    uiImageView       = [[UIImageView alloc] initWithImage:image];
    uiImageView.frame = [self boundsFromImage:image];
    
    return uiImageView;
}

- (CGRect) boundsFromImage:(UIImage*)image
{
    return CGRectMake(0, 0, image.size.width, image.size.height);
}

@end
