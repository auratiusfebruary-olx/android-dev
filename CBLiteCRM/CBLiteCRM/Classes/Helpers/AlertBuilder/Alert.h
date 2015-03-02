//
//  AlertBuilder.h
//
//  Created by Andrew on 13.06.13.
//  Copyright (c) 2013 Al Digit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AlertButtonBlock) ();

@interface Alert : NSObject <UIAlertViewDelegate>

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * message;

+ (id) alert;
+ (id) alertWithTitle:(NSString*)title
              message:(NSString*)message;

+ (id) alertWithTitle:(NSString*)title
              message:(NSString*)message
         withYesBlock:(AlertButtonBlock)yesBlock
          withNoBlock:(AlertButtonBlock)noBlock;

- (id)  withTitle:  (NSString*)title;
- (id)  withMessage:(NSString*)message;

- (id)  addButton:(NSString*)title withBlock:(AlertButtonBlock)block;
- (id)  addButton:(NSString*)title;

- (void) show;

@end
