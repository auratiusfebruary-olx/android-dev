//
//  Contact+Helper.m
//  CBLiteCRM
//
//  Created by Andrew on 12.12.13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "Contact+Helper.h"
#import "Customer.h"

@implementation Contact (Helper)

- (NSString*)customerCompanyName
{
    return self.customer.companyName;
}

@end
