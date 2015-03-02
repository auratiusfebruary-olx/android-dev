//
//  AppDelegate.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBLSyncManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CBLSyncManager *cblSync;

- (void)logout;
- (void)loginAndSync: (void (^)())complete asAdmin:(BOOL)asAdmin;
@end
