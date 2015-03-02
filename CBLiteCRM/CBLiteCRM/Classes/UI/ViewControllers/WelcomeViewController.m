//
//  ViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UIView+Activity.h"
#import "UIAlertView+Helper.h"
#import "AppDelegate.h"

//Data
#import "DataStore.h"
#import "SalePersonsStore.h"

#define kWelcomeViewControllerAsAdmin @"CBL.WelcomeScreen.Login.as.Admin"

@implementation WelcomeViewController

- (void)showMenuScreen
{
    [self setShouldLoginAsAdmin:self.asAdmin.on];
    
    [self performSegueWithIdentifier:@"pushMenuController" sender:self];
}

#pragma mark -

- (IBAction)facebookLogin {
    [self.view showActivity];
    
    [[self appDelegate] loginAndSync: ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"called complete loginAndSync");
            
            [self showMenuScreen];            
            [self.view hideActivity];
        });
    } asAdmin:self.asAdmin.isOn];
}

- (void) onEpicFail
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIAlertView showErrorMessage:@"Authentification failed"];
        [self.view hideActivity];
    });
}

#pragma mark - ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.asAdmin setOn:[self shouldLoginAsAdmin]];
    
    [self subscribeAuthenticationFailNotification];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self unsubscribeAllNotifications];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self hasUserId])
        [self facebookLogin];
}

#pragma mark -

- (BOOL) hasUserId
{
    return [self currentUserId] != nil;
}

#pragma mark - User Defaults

- (NSString*) currentUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: kCBLPrefKeyUserID];
}

- (BOOL) shouldLoginAsAdmin {
    return [[NSUserDefaults standardUserDefaults] boolForKey: kWelcomeViewControllerAsAdmin];
}

- (void) setShouldLoginAsAdmin:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value
                                            forKey:kWelcomeViewControllerAsAdmin];
}

#pragma mark - Notifications

- (void)subscribeAuthenticationFailNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onEpicFail)
                                                 name:@"authentication.fail"
                                               object:nil];
}

- (void)unsubscribeAllNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 

- (AppDelegate*)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

@end
