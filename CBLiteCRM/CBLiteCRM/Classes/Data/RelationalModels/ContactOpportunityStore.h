//
//  ContactOpportunityStore.h
//  CBLiteCRM
//
//  Created by Ruslan on 12/10/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "BaseStore.h"

@class Opportunity;

@interface ContactOpportunityStore : BaseStore

- (CBLQuery*)queryContactsForOpportunity:(Opportunity*)opp;

@end
