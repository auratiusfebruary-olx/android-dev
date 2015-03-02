//
//  BaseModel.m
//  CBLiteCRM
//
//  Created by Danil on 29/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
@dynamic uniqueField, type;

- (instancetype) initInDatabase: (CBLDatabase*)database{
    self = [super initWithNewDocumentInDatabase:database];
    if(self){
        self.type = [[self class] type];
    }
    return self;
}

+ (NSString*) type{
    NSAssert(YES, @"implement doc type in your class");
    return nil;
}

@end
