//
//  ContactOpportunity.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/9/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "ContactOpportunity.h"
#import "Constants.h"

@implementation ContactOpportunity
@dynamic contact, opportunity;

- (instancetype) initInDatabase: (CBLDatabase*)database
                    withContact: (Contact*)ct
                 andOpportunity:(Opportunity*)opp;
{
    self = [super initWithNewDocumentInDatabase:database];
    if(self){
        [self setValue: [[self class] type] ofProperty: @"type"];
        [self setValue:ct forKey:@"contact"];
        [self setValue:opp forKey:@"opportunity"];
    }

    NSError* error = nil;
    if(![self save: &error]) {
        
        NSLog(@"ContactOpportunity Error: %@", [error localizedDescription]);
        
        return nil;
    }
    
    return self;
}


+ (NSString*) type{
    return kContactOpportunityDocType;
}


@end
