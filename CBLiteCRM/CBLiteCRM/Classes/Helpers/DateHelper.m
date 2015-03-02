//
//  DateHelper.m
//  Couchbase
//
//  Created by Danil on 5/15/13.
//  Copyright (c) 2013 Couchbase All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

static NSDateFormatter* opportDateFormatter;

+ (NSDateFormatter*)preparedOpportDateFormatter {
    if(!opportDateFormatter) {
        opportDateFormatter = [[NSDateFormatter alloc] init];
        opportDateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return opportDateFormatter;
}

@end
