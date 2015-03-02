//
//  UIView+IsA.h
//  CBLiteCRM
//
//  Created by Andrew on 07.01.14.
//  Copyright (c) 2014 Couchbase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IsA)

- (BOOL)isUITextField;
- (BOOL)isUIButton;
- (BOOL)isUIImageView;

@end
