//
//  CustomerDetailsViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/28/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "CustomerDetailsViewController.h"
#import "OpportunitiesViewController.h"
#import "ContactsViewController.h"

//Data
#import "Customer.h"
#import "DataStore.h"
#import "CustomersStore.h"
#import "CustomerDeleteHelper.h"

@interface CustomerDetailsViewController ()
{
    CustomerDeleteHelper* deleteHelper;
}
@end

@implementation CustomerDetailsViewController
@synthesize deleteButton, textFields, buttons;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMode];
    deleteHelper = [CustomerDeleteHelper new];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadInfoForCustomer:self.currentCustomer];
}

- (void)setupMode
{
    BOOL editMode;
    if(self.currentCustomer)
        editMode = NO;
    else
        editMode = YES;
    [self setEditMode:editMode];
}

- (void)loadInfoForCustomer:(Customer*)cm{
    self.buttonsView.hidden = (cm == nil);
    if(cm) {
        self.companyNameField.text = cm.companyName.length > 0 ? cm.companyName : @"";
        self.industryField.text = cm.industry;
        self.phoneField.text = cm.phone;
        self.mailField.text = cm.email;
        self.addressField.text = cm.address;
        self.URLField.text = cm.websiteUrl;
    }
}

#pragma mark - Actions

- (IBAction)back:(id)sender {
    self.currentCustomer = nil;
    if([self.presentingViewController isKindOfClass:[UINavigationController class]]){
            [self dismissViewControllerAnimated:YES completion:NULL];
    }else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveItem:(id)sender {
    if([self.navigationItem.rightBarButtonItem.title isEqualToString:kSaveTitle]){
        if(self.companyNameField.text && ![self.companyNameField.text isEqualToString:@""]) {
            Customer* newCustomer = self.currentCustomer;
            if(!newCustomer)
                newCustomer = [[DataStore sharedInstance].customersStore createCustomerWithNameOrReturnExist:self.companyNameField.text];
            [self updateInfoForCustomer:newCustomer];
            [self setEditMode:NO];
        } else
            [UIAlertView showErrorMessage:@"Company Name is required"];
        
    }else if([self.navigationItem.rightBarButtonItem.title isEqualToString:kEditTitle])
        [self setEditMode:YES];
}

-(DeleteBlock)createOnDeleteBlock
{
    __weak typeof(self) weakSelf = self;
    return ^(BOOL shouldDelete){
        if (shouldDelete)
            [weakSelf dismissViewControllerAnimated:YES completion:^{}];
    };
}

- (IBAction)opportunities:(id)sender
{
    [self performSegueWithIdentifier:@"presentOpportunitiesForCustomer" sender:self];
}

- (IBAction)showContacts:(id)sender
{
    [self performSegueWithIdentifier:@"presentContactsForCustomer" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[OpportunitiesViewController class]]) {
        OpportunitiesViewController *vc = (OpportunitiesViewController*)segue.destinationViewController;
        vc.filteredCustomer = self.currentCustomer;
        vc.navigationItem.rightBarButtonItem = ![self isEditMode] ? nil : vc.navigationItem.rightBarButtonItem;
    } else if ([segue.destinationViewController isKindOfClass:[ContactsViewController class]]) {
        ContactsViewController *vc = (ContactsViewController*)segue.destinationViewController;
        vc.filteredCustomer = self.currentCustomer;
        vc.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)editModeChanged:(BOOL)editMode
{
    self.buttonsView.hidden = !self.currentCustomer;
    self.opportunitiesButton.hidden = !self.currentCustomer;

    if (editMode)
        [self.opportunitiesButton setTitle:@"Edit Opportunities" forState:UIControlStateNormal];
    else
        [self.opportunitiesButton setTitle:@"Opportunities" forState:UIControlStateNormal];
}

#pragma mark -

- (void)updateInfoForCustomer:(Customer*)cm
{
    cm.companyName  = self.companyNameField.text;
    cm.industry = self.industryField.text;
    cm.phone = self.phoneField.text;
    cm.address = self.addressField.text;
    cm.websiteUrl = self.URLField.text;
    cm.email = self.mailField.text;
    NSError* error;
    if(![cm save:&error])
        NSLog(@"error in save customer: %@", error);
    else
        self.currentCustomer = cm;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
