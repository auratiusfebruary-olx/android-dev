//
//  ContactDetailsViewController.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "TextFieldsViewController.h"
#import "UIViewController+ReadOnlyOrWriteMode.h"

@class Contact;
@interface ContactDetailsViewController : TextFieldsViewController<EditableViewControllers>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *companyButton;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;
@property (weak, nonatomic) IBOutlet UITextField *positionField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *mailField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@property (strong, nonatomic) Contact *currentContact;

- (IBAction)back:(id)sender;
- (IBAction)saveItem:(id)sender;
- (IBAction)customerAction;

@end
