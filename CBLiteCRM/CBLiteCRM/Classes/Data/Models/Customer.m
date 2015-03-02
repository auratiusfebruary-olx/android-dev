//
//  Customer.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "Customer.h"
#import "DataStore.h"
#import "CustomersStore.h"
#import "ContactsStore.h"
#import "OpportunitiesStore.h"
#import "Contact.h"
#import "Opportunity.h"

@implementation Customer
@dynamic companyName, industry, phone, email, websiteUrl, address;

+ (NSString*) type{
    return kCustomerDocType;
}


- (instancetype) initInDatabase: (CBLDatabase*)database
               withCustomerName: (NSString*)name
{
    NSParameterAssert(name);
    self = [super initInDatabase:database];
    if(self){
        [self setValue:name ofProperty: @"companyName"];
    }

    NSError* error;
    if (![self save: &error]){
        NSLog(@"error: %@", error);
        return nil;
    }
    return self;
}

- (BOOL)deleteDocument: (NSError**)outError
{
    ContactsStore *ctStore = [DataStore sharedInstance].contactsStore;
    CBLQuery *cQ = [ctStore queryContactsForCustomer:self];
    NSError *error;
    for (CBLQueryRow *r in [cQ run:&error]) {
        Contact *c = [Contact modelForDocument:r.document];
        c.customer = nil;
        [c save:&error];
    }

    OpportunitiesStore *oppStore = [DataStore sharedInstance].opportunitiesStore;
    CBLQuery *oppQ = [oppStore queryOpportunitiesForCustomer:self];
    for (CBLQueryRow *r in [oppQ run:&error]) {
        Opportunity *opp = [Opportunity modelForDocument:r.document];
        opp.customer = nil;
        [opp save:&error];
    }
    return [super deleteDocument:outError];
}


@end
