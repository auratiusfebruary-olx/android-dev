//
//  ContactOpportunity.h
//  CBLiteCRM
//
//  Created by Ruslan on 12/9/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@class Contact, Opportunity;

@interface ContactOpportunity : CBLModel

@property (weak) Contact *contact;
@property (weak) Opportunity *opportunity;

- (instancetype) initInDatabase: (CBLDatabase*)database
                    withContact: (Contact*)ct
                 andOpportunity:(Opportunity*)opp;

@end
