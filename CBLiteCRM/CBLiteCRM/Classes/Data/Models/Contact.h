//
//  Contact.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//
#import "BaseModel.h"

@class Customer;
@interface Contact : BaseModel
@property (weak) Customer* customer;
@property (strong) NSString* name;
@property (strong) NSString* position;
@property (strong) NSString* phoneNumber;
@property (strong) NSString* email;
@property (strong) NSString* address;
@property (strong) NSArray* opportunities;

- (instancetype) initInDatabase: (CBLDatabase*)database
                 withEmail: (NSString*)mail;

- (UIImage*) photo;

@end
