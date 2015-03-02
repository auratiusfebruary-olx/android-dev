//
//  CustomerDeleteHelper.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/27/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "CustomerDeleteHelper.h"
#import "ContactsStore.h"
#import "OpportunitiesStore.h"
#import "DataStore.h"
#import "Alert.h"

@interface CustomerDeleteHelper ()
{
    Alert        * alertBuilder;
    
    ContactsStore* contactsStore;
    OpportunitiesStore* opportunitiesStore;
    CBLQuery* relatedContactsQuery;
    CBLQuery* relatedOpportunitiesQuery;
}
@end

@implementation CustomerDeleteHelper
@synthesize item = _item;

- (id)initWithItem:(CBLModel*)item
{
    self = [super init];
    if (self) {
        _item = item;
        [self initialize];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setupAlertBuilder
{
    __block id _self = self;
    
    alertBuilder = [Alert alertWithTitle:@"Delete item"
                                 message:@"Are you sure you want to remove item"];
    [alertBuilder addButton:@"NO"];
    [alertBuilder addButton:@"YES" withBlock:^{ [_self deleteSelectedItem]; }];
    
    [Alert alertWithTitle:@"Some Title"
                  message:@"Some Message" withYesBlock:^{
                      // call method for YES
                  } withNoBlock:^{
                      // call method for NO
                  }];
}

- (void)initialize
{
    contactsStore = [DataStore sharedInstance].contactsStore;
    opportunitiesStore = [DataStore sharedInstance].opportunitiesStore;
    
    [self setupAlertBuilder];
}

- (void)setItem:(CBLModel *)item
{
    _item = item;
    [self setDeleteMessageForItem:item];
}

- (void)setDeleteMessageForItem:(CBLModel *)item
{
    NSError* error;
    NSMutableString* msg = [NSMutableString new];
    relatedContactsQuery = [contactsStore queryContactsForCustomer:(Customer*)item];
    NSUInteger ctCount = [[relatedContactsQuery run:&error] count];

    relatedOpportunitiesQuery = [opportunitiesStore queryOpportunitiesForCustomer:(Customer*)item];
    NSUInteger oppCount = [[relatedOpportunitiesQuery run:&error] count];

    if (ctCount == 1)
        [msg appendFormat:@"%u contact", ctCount];
    else if (ctCount > 1)
        [msg appendFormat:@"%u contacts", ctCount];

    if (ctCount > 0 && oppCount > 0)
        [msg appendString:@" and "];
    if (oppCount == 1)
        [msg appendFormat:@"%u opportunity", oppCount];
    else if (oppCount > 1)
        [msg appendFormat:@"%u opportunities", oppCount];

    if (oppCount + ctCount > 0)
        alertBuilder.message = [NSString stringWithFormat:@"Are you sure you want to remove item.\nAlso %@ will be deleted", msg];
    else
        alertBuilder.message = @"Are you sure you want to remove item";
}

- (void)showDeletionAlert
{
    [alertBuilder show];
}

- (void)deleteRelatedObjects
{
    [self deleteRelatedContacts];
    [self deleteRelatedOpportunities];
}

- (void)deleteRelatedContacts
{
    NSError* error;
    for (CBLQueryRow* row in [relatedContactsQuery run:&error])
        [row.document deleteDocument:&error];
}

- (void)deleteRelatedOpportunities
{
    NSError* error;
    for (CBLQueryRow* row in [relatedOpportunitiesQuery run:&error])
        [row.document deleteDocument:&error];
}

- (void) deleteSelectedItem
{
    NSError *error;
    [self deleteRelatedObjects];
    [self.item deleteDocument:&error];
    self.deleteAlertBlock(YES);
}

@end
