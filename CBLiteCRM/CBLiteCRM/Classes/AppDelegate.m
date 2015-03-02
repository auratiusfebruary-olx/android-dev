//
//  AppDelegate.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "AppDelegate.h"

#import "DataStore.h"
#import "CBLSyncManager.h"

#import "SalesPerson.h"
#import "SalePersonsStore.h"

#import <FacebookSDK/FacebookSDK.h>
#import "TestFlight.h"



@interface AppDelegate()
@property (nonatomic) DataStore* dataStore;
@property (nonatomic) BOOL asAdmin;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupTestflight];
    [self setupAppearance];
    [self setupDatabase:[DataStore sharedInstance]];
    [self setupCBLSync];
    return YES;
}

- (void)setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:kNavigationBarColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITextField appearance] setTintColor:[UIColor grayColor]];
    [[UIToolbar appearance] setTintColor:[UIColor blackColor]];
    [[UIToolbar appearance] setBackgroundColor:[UIColor lightGrayColor]];
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}


#pragma mark - Sync

- (void)setupDatabase:(DataStore*)store
{
    self.dataStore = store;
}

- (void) setupCBLSync {
    self.cblSync = [[CBLSyncManager alloc] initSyncForDatabase:self.dataStore.database withURL:[NSURL URLWithString:kSyncUrl]];
    
    // Tell the Sync Manager to use Facebook for login.
    self.cblSync.authenticator = [[CBLFacebookAuthenticator alloc] initWithAppID:kFBAppId];
}

- (void)loginAndSync: (void (^)())complete asAdmin:(BOOL)asAdmin
{
    // TODO: removed that variable after CBLSyncManager refactoring
    self.asAdmin = asAdmin;
    
    if (self.cblSync.userID) {
        [self updateUserWithRole:self.asAdmin];
        complete();
    } else {
        [self.cblSync beforeFirstSync:^(NSString *userID, NSDictionary *userData, NSError **outError) {
            [self updateUserWithRole:self.asAdmin];
            complete();
        }];
        [self.cblSync start];
    }
}

- (void)updateUserWithRole:(BOOL)adminRole
{
    NSError* error;
    SalesPerson *myProfile = [DataStore sharedInstance].salePersonsStore.user;
    myProfile.isAdmin = adminRole;
    [myProfile save:&error];
    if(error){
        NSLog(@"error on updateUserWithRole: %@", error);
    }
    NSLog(@"my profile doc properties: %@", myProfile.document.properties);
}

//TODO: should be refactored with CBLSyncManager
- (void)logout{
    [self.dataStore logout];
    [self.cblSync logout];
}

#pragma -

- (void) setupTestflight
{
    [TestFlight takeOff:@"f13dc547-6cef-4b07-9864-6fd1cffa1b3f"];
}

@end
