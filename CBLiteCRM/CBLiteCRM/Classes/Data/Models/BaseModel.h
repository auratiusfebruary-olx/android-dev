//
//  BaseModel.h
//  CBLiteCRM
//
//  Created by Danil on 29/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//


@interface BaseModel : CBLModel
@property (strong) NSString* uniqueField;
@property (strong) NSString* type;

- (instancetype) initInDatabase: (CBLDatabase*)database;
+ (NSString*) type;
@end
