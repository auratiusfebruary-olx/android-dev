//
//  ContactCell.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "ContactCell.h"
#import "Contact.h"
#import "Contact+Helper.h"

NSString *kContactCellIdentifier = @"ContactCell";

@implementation ContactCell

- (void)setContact:(Contact *)contact {
    _contact = contact;
    
    self.avatar.image   = [self avatarImageForContact:contact];
    self.name.text      = [contact name];
    self.position.text  = [contact customerCompanyName];
}

- (UIImage*)avatarImageForContact:(Contact*)contact
{
    UIImage * photo = [contact photo];
    
    if(!photo)
        photo = [UIImage imageNamed:@"PhotoPlaceholderSmall"];
    
    return photo;
}

@end
