//
//  BaseStore.m
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "BaseStore.h"

@interface BaseStore ()

@end

@implementation BaseStore
- (id) initWithDatabase: (CBLDatabase*)database {
    self = [super init];
    if (self) {
        _database = database;
        [self registerCBLClass];
        [self createView];
    }
    return self;
}

-(void)registerCBLClass {}
-(void)createView {}

@end
