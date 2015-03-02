//
//  CBLModelDeleteHelper.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/25/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "CBLModelDeleteHelper.h"

@implementation CBLModelDeleteHelper

- (id)initWithItem:(CBLModel*)item
{
    self = [super init];
    if (self) {
        _item = item;
    }
    return self;
}

- (void)showDeletionAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Delete item" message:@"Are you sure you want to remove item" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSError *error;
        if ([self.item deleteDocument:&error])
            self.deleteAlertBlock(YES);
        else {
            [UIAlertView showError:error];
            self.deleteAlertBlock(NO);
        }
    }
}

@end
