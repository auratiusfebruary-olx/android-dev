//
//  OpportunityContactStore.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "OpportunityForContactStore.h"
#import "ContactOpportunity.h"
#import "Opportunity.h"
#import "Contact.h"

@interface OpportunityForContactStore ()
{
    CBLView* _filteredOpportunitiesContactView;
}

@end

@implementation OpportunityForContactStore

-(id)initWithDatabase:(CBLDatabase *)database
{
    self = [super initWithDatabase:database];
    if (self) {
        [self.database.modelFactory registerClass: [ContactOpportunity class] forDocumentType: kContactOpportunityDocType];
        _filteredOpportunitiesContactView = [self.database viewNamed: @"filteredOpportunitiesContact"];
        [_filteredOpportunitiesContactView setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactOpportunityDocType]) {
                if (doc[@"_id"])
                    emit(doc[@"_id"], doc);
            }
        }) version: @"3"];

    }
    return self;
}

-(CBLQuery *)queryOpportunitiesForContact:(Contact *)ct
{
    CBLView* view = [self.database viewNamed: @"OpportunitiesForContact"];
    if (!view.mapBlock) {
        [view setMapBlock: MAPBLOCK({
            if ([doc[@"type"] isEqualToString: kContactOpportunityDocType]) {
                NSString* contactId = doc[@"contact"];
                if (contactId) {
                    emit(contactId, doc);
                }
            }
        }) reduceBlock: nil version: @"1"]; // bump version any time you change the MAPBLOCK body!
    }
    CBLQuery* query = [view createQuery];
    NSString* ctID = ct.document.documentID;
    query.keys = @[ctID];
    return query;
}

-(CBLQuery *)filteredQuery
{
    return [_filteredOpportunitiesContactView createQuery];
}

@end
