//
//  ActionSheet.h
//  
//
//  Created by Andrew on 17.06.13.
//  Copyright (c) 2013 Couchbase All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ActionSheetButtonBlock) ();

@interface ActionSheet : NSObject <UIActionSheetDelegate>

@property (nonatomic, strong) NSString * title;

+ (id) actionSheet;
+ (id) actionSheetWithTitle:(NSString*)title;

- (id)  withTitle: (NSString*)title;

- (id)  addOtherButton:(NSString*)title block:(ActionSheetButtonBlock)block;
- (id)  setCancelButton:(NSString*)title block:(ActionSheetButtonBlock)block;
- (id)  setDistructiveButton:(NSString*)title block:(ActionSheetButtonBlock)block;

- (id)  withCancelButtonDefault; // Cancel TITLE with no BLOCK

- (void) showInView:(UIView*)view;

@end
