//
//  OpenUrlHelper.h
//  CBLiteCRM
//
//  Created by Andrew on 07.01.14.
//  Copyright (c) 2014 Couchbase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenUrlHelper : NSObject

- (IBAction)callPhone:  (UIButton *)sender;
- (IBAction)callEmail:  (UIButton *)sender;
- (IBAction)callAddress:(UIButton *)sender;

- (IBAction)callWebsite:(UIButton *)sender;

@end
