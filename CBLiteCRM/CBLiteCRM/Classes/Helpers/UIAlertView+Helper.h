//
//  UIAlertView+Helper.h
//  CBLiteCRM
//
//  Created by Andrew on 13.12.13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Helper)

+ (void) showErrorMessage:(NSString*)message;

+ (void) showError:(NSError*)error;

@end
