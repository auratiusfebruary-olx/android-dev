//
//  UIView+IsA.m
//  CBLiteCRM
//
//  Created by Andrew on 07.01.14.
//  Copyright (c) 2014 Couchbase. All rights reserved.
//

#import "UIView+IsA.h"

@implementation UIView (IsA)

- (BOOL)isUITextField
{
    return [self isKindOfClass:[UITextField class]];
}

- (BOOL)isUIButton
{
    return [self isKindOfClass:[UIButton class]];
}

- (BOOL)isUIImageView
{
    return [self isKindOfClass:[UIImageView class]];
}

@end
