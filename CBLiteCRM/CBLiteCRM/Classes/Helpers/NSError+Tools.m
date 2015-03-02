//
//  NSError+Tools.m
//
//  Created by Andrew on 05.03.12.
//  Copyright (c) 2013 Al Digit Ltd. All rights reserved.
//

#import "NSError+Tools.h"

@implementation NSError (Tools)

+ (NSError*)errorWithDomain:(NSString*)domain code:(NSInteger)code message:(NSString*)message
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:message};
    
    return [NSError errorWithDomain:domain
                               code:code
                           userInfo:userInfo];
}

+ (NSError*)errorWithDomain:(NSString*)domain message:(NSString*)message // code == 0
{
    return [self errorWithDomain:domain
                            code:0
                         message:message];
}

+ (NSError*)errorWithClass:(Class)clazz code:(NSInteger)code message:(NSString*)message {
    
    return [self errorWithDomain:NSStringFromClass(clazz)
                            code:code
                         message:message];
}

+ (NSError*)errorWithClass:(Class)clazz message:(NSString*)message // code == 0
{
    return [self errorWithClass:clazz
                           code:0
                        message:message];
}

@end
