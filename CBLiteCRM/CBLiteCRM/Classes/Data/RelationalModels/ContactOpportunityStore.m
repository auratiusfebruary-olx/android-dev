//
//  ContactOpportunityStore.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/10/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "ContactOpportunityStore.h"
#import "ContactOpportunity.h"
#import "Opportunity.h"
#import "Contact.h"

@interface ContactOpportunityStore ()
{
    CBLView* _filteredContactsOpportunityView;
}

@end

@implementation ContactOpportunityStore

-(id)initWithDatabase:(CBLDatabase *)database
{
    self = [super initWithDatabase:database];
    if (self) {
        [self.database.modelFactory registerClass: [ContactOpportunity class] forDocumentType: kContactOpportunityDocType];
        _filteredContactsOpportunityView = [self.database viewNamed: @"filteredContactsOpportunities"];
        [_filteredContactsOpportunityView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactOpportunityDocType]) {
                if (doc[@"_id"])
                    emit(doc[@"_id"], doc);
            }
        }) version: @"3"];
    }
    return self;
}

-(CBLQuery *)queryContactsForOpportunity:(Opportunity *)opp
{
    CBLView* view = [self.database viewNamed: @"ContactsForOpportunity"];
    if (!view.mapBlock) {
        [view setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactOpportunityDocType]) {
                NSString* opportunityId = doc[@"opportunity"];
                if (opportunityId) {
                    emit(opportunityId, doc);
                }
            }
        }) reduceBlock: nil version: @"1"]; // bump version any time you change the MAPBLOCK body!
    }
    CBLQuery* query = [view createQuery];
    NSString* oppID = opp.document.documentID;
    query.keys = @[oppID];
    return query;
}

-(CBLQuery *)filteredQuery
{
    return [_filteredContactsOpportunityView createQuery];
}

@end
