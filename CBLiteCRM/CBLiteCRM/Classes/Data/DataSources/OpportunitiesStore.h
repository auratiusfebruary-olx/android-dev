//
//  OpportunityStore.h
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "BaseStore.h"
@class Opportunity, Customer, Contact;
@interface OpportunitiesStore : BaseStore

- (CBLQuery*) queryOpportunitiesForCustomer:(Customer*)customer;

- (CBLQuery*) queryOpportunities;

- (Opportunity*) createOpportunityWithTitle: (NSString*)title;

@end
