//
//  CustomerStore.m
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "CustomersStore.h"
#import "Customer.h"
#import "Opportunity.h"

@interface CustomersStore() {
    CBLView* customersView;
}
@end

@implementation CustomersStore

-(void)registerCBLClass
{
    [self.database.modelFactory registerClass:[Customer class] forDocumentType: kCustomerDocType];
}

- (void)createView
{
    customersView = [self.database viewNamed:@"customersByName"];
    [customersView setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: kCustomerDocType]) {
            if (doc[@"companyName"])
                emit(doc[@"companyName"], doc[@"companyName"]);
        }
    }) version: @"1"];
}

- (Customer*) createCustomerWithNameOrReturnExist: (NSString*)name
{
    Customer* cm = [self customerWithName: name];
    if(!cm)
        cm = [[Customer alloc] initInDatabase:self.database withCustomerName:name];
    return cm;
}

- (Customer*) customerWithName: (NSString*)name
{
    CBLDocument* doc = [self.database createDocument];
    if (!doc.currentRevisionID)
        return nil;
    return [Customer modelForDocument: doc];
}

- (CBLQuery*) allCustomersQuery
{
    return [customersView createQuery];
}

- (CBLQuery *)filteredQuery
{
    return [customersView createQuery];
}

@end
