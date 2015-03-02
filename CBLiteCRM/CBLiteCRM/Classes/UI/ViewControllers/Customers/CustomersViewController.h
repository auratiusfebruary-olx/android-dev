//
//  CustomersViewController.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "FilteringViewController.h"
@class Opportunity, Customer;
@interface CustomersViewController : FilteringViewController
@property (nonatomic) BOOL chooser;
@property (nonatomic, copy) void (^onSelectCustomer)(Customer * customer);

@end
