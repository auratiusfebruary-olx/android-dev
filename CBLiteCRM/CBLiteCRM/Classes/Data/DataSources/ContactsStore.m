//
//  ContactsStore.m
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "ContactsStore.h"
#import "Contact.h"
#import "Opportunity.h"
#import "Customer.h"

#import "ContactOpportunityStore.h"
#import "ContactOpportunity.h"
#import "DataStore.h"

@interface ContactsStore()
{
    CBLView* _contactsView;
}
@end

@implementation ContactsStore

-(void)registerCBLClass
{
    [self.database.modelFactory registerClass: [Contact class] forDocumentType: kContactDocType];
}

- (void)createView
{
    _contactsView = [self.database viewNamed: @"contactsByName"];
    [_contactsView setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: kContactDocType]) {
            if (doc[@"name"])
                emit(doc[@"name"], doc);
        }
    }) version: @"2"];
}

- (Contact*) createContactWithMailOrReturnExist: (NSString*)mail{
    Contact* ct = [self contactWithMail:mail];
    if(!ct)
        ct = [[Contact alloc] initInDatabase:self.database withEmail:mail];
    return ct;
}

- (Contact*) contactWithMail: (NSString*)mail{
    CBLDocument* doc = [self.database createDocument];
    if (!doc.currentRevisionID)
        return nil;
    return [Contact modelForDocument: doc];
}

#pragma mark - Queries

- (CBLQuery*) queryContacts
{
    CBLQuery* query = [_contactsView createQuery];
    return query;
}

- (CBLQuery*) queryContactsForOpportunity:(Opportunity*)opp
{
    CBLQuery* query = [_contactsView createQuery];
    query.keys = [self getFilteringEmailKeysMatchedForOpportunity:opp query:query];
    return query;
}

- (NSMutableArray *)getFilteringEmailKeysMatchedForOpportunity:(Opportunity *)opp query:(CBLQuery *)query
{
    CBLQuery *addedContactsQuery = [[DataStore sharedInstance].contactOpportunityStore queryContactsForOpportunity:opp];
    NSError *error;
    NSMutableArray *keys = [NSMutableArray new];
    for (CBLQueryRow *r in [query run:&error]) {
        Contact *ct = [Contact modelForDocument:r.document];
        BOOL exist = NO;
        for (CBLQueryRow *row in [addedContactsQuery run:&error]) {
            ContactOpportunity *ctOpp = [ContactOpportunity modelForDocument:row.document];
            if ([ct.name isEqualToString:ctOpp.contact.name])
                exist = YES;
        }
        if (!exist)
            [keys addObject:ct.name];
    }
    return keys;
}

- (CBLQuery *)queryContactsForCustomer:(Customer *)cust
{
    CBLView* view = [self.database viewNamed: @"contactsForCustomer"];
    if (!view.mapBlock) {
        [view setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactDocType]) {
                NSString* customerId = doc[@"customer"];
                if (customerId) {
                    emit(customerId, doc);
                }
            }
        }) reduceBlock: nil version: @"4"]; // bump version any time you change the MAPBLOCK body!
    }
    CBLQuery* query = [view createQuery];
    NSString* myCustID = cust.document.documentID;
    query.keys = @[myCustID];
    return query;
}

- (CBLQuery *)filteredQuery
{
    return [_contactsView createQuery];
}

@end
