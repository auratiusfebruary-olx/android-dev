//
//  ContactsStore.h
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "BaseStore.h"
@class Contact, Opportunity, Customer;
@interface ContactsStore : BaseStore

- (Contact*) createContactWithMailOrReturnExist: (NSString*)mail;
- (Contact*) contactWithMail: (NSString*)mail;
- (CBLQuery*) queryContacts;

- (CBLQuery*) queryContactsForCustomer:(Customer*)cust;
- (CBLQuery*) queryContactsForOpportunity:(Opportunity*)opp;

@end
