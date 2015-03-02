//
//  Opportunity.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "BaseModel.h"

@class Customer;
@interface Opportunity : BaseModel
@property (weak) Customer* customer;
@property (strong) NSDate* creationDate;
@property long long revenueSize;
@property float winProbability;
@property (strong) NSString* salesStage;
@property (readonly, strong) NSArray* contacts;
@property (strong) NSString* title;

- (instancetype) initInDatabase: (CBLDatabase*)database
                      withTitle: (NSString*)title;
@end
