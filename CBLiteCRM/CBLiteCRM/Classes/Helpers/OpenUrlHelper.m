//
//  OpenUrlHelper.m
//  CBLiteCRM
//
//  Created by Andrew on 07.01.14.
//  Copyright (c) 2014 Couchbase. All rights reserved.
//

#import "OpenUrlHelper.h"

@implementation OpenUrlHelper

- (IBAction)callPhone:(UIButton *)sender
{
    [self openUrlForBase:@"tel:" andButton:sender];
}

- (IBAction)callEmail:(UIButton *)sender
{
    [self openUrlForBase:@"mailto://" andButton:sender];
}

- (IBAction)callAddress:(UIButton *)sender
{
    [self openUrlForBase:@"http://maps.google.com/maps?q=" andButton:sender];
}

- (IBAction)callWebsite:(UIButton *)sender
{
    [self openUrlForBase:@"http://" andButton:sender];
}

#pragma mark -

- (void) openUrlForBase:(NSString*)base andButton:(UIButton*)button
{
    NSString * parameter = [self textFromButton:button];
    
    if (parameter)
    {
        [[UIApplication sharedApplication] openURL:[self createURLUsingBase:base
                                                                   parmeter:parameter]];
    }
}

- (NSURL*) createURLUsingBase:(NSString*)base parmeter:(NSString*)parameter
{
    NSString * encodedParameter = [parameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *        urlString = [base stringByAppendingString:encodedParameter];
    
    NSLog(@"Will Open URL: %@", urlString);
    
    return [NSURL URLWithString:urlString];
}

- (NSString*) textFromButton:(UIButton *)sender
{
    NSString * title = [sender titleForState:UIControlStateNormal];
    NSString * text  = [title  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (text != nil && [text length] == 0) return nil;
    
    return text;
}

@end
