//
//  NSError+Tools.h
//
//  Created by Andrew on 05.03.12.
//  Copyright (c) 2013 Al Digit Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Tools)

+ (NSError*)errorWithDomain:(NSString*)domain message:(NSString*)message; // code == 0

+ (NSError*)errorWithDomain:(NSString*)domain code:(NSInteger)code message:(NSString*)message;

+ (NSError*)errorWithClass:(Class)clazz code:(NSInteger)code message:(NSString*)message;

+ (NSError*)errorWithClass:(Class)clazz message:(NSString*)message; // code == 0

@end
