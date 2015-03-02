//
//  SalePersonsStore.h
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "BaseStore.h"
@class SalesPerson;
@interface SalePersonsStore : BaseStore
/** The local logged-in user */
@property (nonatomic, strong) SalesPerson* user;

/** The local logged-in user's username. */
- (void) setUserID:(NSString *)userID;
- (NSString*)userID;

@property (readonly) CBLQuery* allUsersQuery;
@property (readonly) NSArray* allOtherUsers;    /**< UserProfile objects of other users */
@property (readonly) CBLQuery* approvedUsersQuery;

- (CBLQuery*) nonAdminNonApprovedUsersQuery:(NSString*)userId;

@end
