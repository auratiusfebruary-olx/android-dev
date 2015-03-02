//
//  CustomerStore.h
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "BaseStore.h"
@class Customer;
@interface CustomersStore : BaseStore
@property (readonly) CBLQuery* allCustomersQuery;

- (Customer*) createCustomerWithNameOrReturnExist: (NSString*)name;

@end
