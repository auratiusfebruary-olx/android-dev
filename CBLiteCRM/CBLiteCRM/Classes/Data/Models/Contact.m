//
//  Contact.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "Contact.h"
#import "OpportunityForContactStore.h"
#import "ContactOpportunity.h"
#import "DataStore.h"

@implementation Contact
@dynamic customer, name, position, phoneNumber, email, address, opportunities;

+ (NSString*) type{
   return kContactDocType;
}

- (instancetype) initInDatabase: (CBLDatabase*)database
                  withEmail: (NSString*)mail
{
    NSParameterAssert(mail);
    self = [super initInDatabase:database];
    if(self){
        self.email = mail;
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
    OpportunityForContactStore *oppCtStore = [DataStore sharedInstance].opportunityContactStore;
    CBLQuery *q = [oppCtStore queryOpportunitiesForContact:self];
    NSError *error;
    for (CBLQueryRow *r in [q run:&error]) {
        ContactOpportunity *ctOpp = [ContactOpportunity modelForDocument:r.document];
        [ctOpp deleteDocument:&error];
        [ctOpp save:&error];
    }
    return [super deleteDocument:outError];
}

- (UIImage*)photo
{
    NSData * photoData = [[self attachmentNamed:@"photo"] content];

    return [UIImage imageWithData:photoData];
}

@end
