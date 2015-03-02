//
//  BaseStore.h
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//


@interface BaseStore : NSObject
@property (readonly) CBLDatabase* database;

@property (readonly) CBLQuery* filteredQuery;

- (id) initWithDatabase: (CBLDatabase*)database;
- (void)registerCBLClass;
- (void)createView;

@end
