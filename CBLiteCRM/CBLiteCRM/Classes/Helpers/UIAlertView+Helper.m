//
//  UIAlertView+Helper.m
//  CBLiteCRM
//
//  Created by Andrew on 13.12.13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "UIAlertView+Helper.h"

#define kUIAlertViewHelperErrorTitle NSLocalizedString(@"Error", @"UIAlertView+Helper::showErrorMessage: (Title)")
#define kUIAlertViewHelperErrorOk    NSLocalizedString(@"OK",    @"UIAlertView+Helper::showErrorMessage: (cancaleButton)")


@implementation UIAlertView (Helper)

+ (void) showErrorMessage:(NSString*)message
{
    [[[UIAlertView alloc] initWithTitle:kUIAlertViewHelperErrorTitle
                                message:message
                               delegate:nil
                      cancelButtonTitle:kUIAlertViewHelperErrorOk
                      otherButtonTitles: nil] show];
}

+ (void) showError:(NSError*)error
{
    [[[UIAlertView alloc] initWithTitle:kUIAlertViewHelperErrorTitle
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:kUIAlertViewHelperErrorOk
                      otherButtonTitles: nil] show];
}

@end
