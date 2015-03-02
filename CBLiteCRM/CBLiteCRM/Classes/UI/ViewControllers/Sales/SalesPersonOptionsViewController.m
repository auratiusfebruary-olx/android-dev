//
//  SalesPersonOptionsViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "SalesPersonOptionsViewController.h"
#import "SalesPerson.h"

#import "DataStore.h"
#import "SalePersonsStore.h"


@interface SalesPersonOptionsViewController ()

@end

@implementation SalesPersonOptionsViewController
@synthesize needLogout, textFields, deleteButton, buttons;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUserData];
    [self blockItemForEditing:[self isMe:self.salesPerson]];
    [self setupMode];
}

- (void)setupMode
{
    BOOL editMode;
    if(self.salesPerson)
        editMode = NO;
    else
        editMode = YES;
    [self setEditMode:editMode];
}

- (void)loadUserData
{
    if (self.salesPerson) {
        self.nameField.text = self.salesPerson.name;
        self.phoneField.text = self.salesPerson.phoneNumber;
        self.mailField.text = self.salesPerson.email;
    }
}

- (void)blockItemForEditing:(BOOL)canEdit{
    self.deleteButton.hidden =!canEdit;
    self.navigationItem.rightBarButtonItem.enabled = canEdit;
    for (UITextField* tf in self.textFields) {
        tf.enabled = canEdit;
    }
}

- (IBAction)save:(id)sender
{
    if([self.navigationItem.rightBarButtonItem.title isEqualToString:kSaveTitle])
        [self updateInfoForSalesPerson:self.salesPerson];
    else if([self.navigationItem.rightBarButtonItem.title isEqualToString:kEditTitle])
        [self setEditMode:YES];
}

- (IBAction)delete:(id)sender
{
    NSError *error;
    if (![self.salesPerson deleteDocument:&error])
        [UIAlertView showError:error];
    else
        [self logout];
    
}

- (BOOL)isMe:(SalesPerson*)sp{
    BOOL isMe;
    if(!sp)
        isMe = NO;
    else
        isMe = [[DataStore sharedInstance].salePersonsStore.user.user_id isEqualToString:sp.user_id];
    return isMe;
}

- (void)updateInfoForSalesPerson:(SalesPerson*)sp
{
    sp.name        = self.nameField.text;
    sp.phoneNumber = self.phoneField.text;
    sp.email = self.mailField.text;
    NSError *error;
    if (![sp save:&error])
        [UIAlertView showError:error];
    else
        [self setEditMode:NO];
}

- (void)logout{
    for (id<LogoutProtocol> vc in self.navigationController.viewControllers) {
        if([vc respondsToSelector:@selector(setNeedLogout:)]){
            vc.needLogout = YES;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
