//
//  OpportunityContactStore.h
//  CBLiteCRM
//
//  Created by Ruslan on 12/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "BaseStore.h"

@class Contact;

@interface OpportunityForContactStore : BaseStore

-(CBLQuery *)queryOpportunitiesForContact:(Contact *)ct;

@end
