//
//  UIView+Activity.h
//
//  Created by Andrew on 7/7/11.
//  Copyright 2011 Al Digit. All rights reserved.
//
//  Based on GIST: https://gist.github.com/andrew-tokarev/4116199
//
//  Updated at 9/05/2013 - Version 1.4

typedef void (^ActivityViewCancelBlock) (/*empty*/);

/* Convenient UIView Category to show activity on top of it while in progress */
@interface UIView (Activity)

- (void) showActivityWithBackgroundColor:(UIColor*)color indicatorStyle:(UIActivityIndicatorViewStyle)style cancelBlock:(void(^)(/*empty*/))block;
- (void) showActivityWithBackgroundColor:(UIColor*)color indicatorStyle:(UIActivityIndicatorViewStyle)style;
- (void) showActivityWithBackgroundWhite;
- (void) showActivityWithBackgroundWhiteAndCancelBlock:(ActivityViewCancelBlock)block;
- (void) showActivity;
- (void) hideActivity;
- (BOOL) isInActivity;

@end
