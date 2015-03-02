//
//  ContactsViewController.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "FilteringViewController.h"

@class Customer, Opportunity, Contact;

@interface ContactsViewController : FilteringViewController

@property (strong, nonatomic) Customer* filteredCustomer;
@property (nonatomic) BOOL chooser;
@property (nonatomic, copy) void (^onSelectContact)(Contact * contact);
@property (nonatomic, strong) Opportunity *filteringOpportunity;

@end
