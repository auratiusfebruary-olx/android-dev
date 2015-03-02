//
//  Customer.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "BaseModel.h"

@interface Customer : BaseModel
@property (strong) NSString* companyName;
@property (strong) NSString* industry;
@property (strong) NSString* phone;
@property (strong) NSString* email;
@property (strong) NSString* websiteUrl;
@property (strong) NSString* address;

- (instancetype) initInDatabase: (CBLDatabase*)database
                  withCustomerName: (NSString*)name;

@end
