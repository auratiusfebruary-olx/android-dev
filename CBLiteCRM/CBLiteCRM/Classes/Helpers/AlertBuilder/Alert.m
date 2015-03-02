//
//  AlertBuilder.m
//
//  Created by Andrew on 13.06.13.
//  Copyright (c) 2013 Al Digit. All rights reserved.
//

#import "Alert.h"
#import <objc/runtime.h>

@interface AlertButton : NSObject

@property (nonatomic, retain) NSString *       title;
@property (nonatomic, copy)   AlertButtonBlock block;

+ (id)   alertButtonWithTitle:(NSString*)_title
                        block:(AlertButtonBlock)_block;
- (void) call;

@end

static char AlertAssociateObjectKey;

@implementation Alert {
    
    NSMutableArray * alertButtons;
}

- (id)init
{
    self = [super init];
    if (self) {
        alertButtons = [NSMutableArray new];
    }
    return self;
}

- (UIAlertView *)buildAlertView
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:self.title
                                                         message:self.message
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:nil];

    [self addOtherButtonTitlesToAlertView:alertView];
    
    [self addSelfToActivityView:alertView];
    
    return alertView;
}

- (void)addOtherButtonTitlesToAlertView:(UIAlertView *)alertView
{
    for (AlertButton * alertButton in alertButtons)
    {
        [alertView addButtonWithTitle:alertButton.title];
    }
}

- (void)addSelfToActivityView:(UIAlertView *)alertView
{
    objc_setAssociatedObject(alertView, &AlertAssociateObjectKey, self, OBJC_ASSOCIATION_RETAIN);
}

- (void) show
{
    [[self buildAlertView] show];
}

+ (id) alert
{
    return [Alert new];
}

+ (id) alertWithTitle:(NSString*)title message:(NSString*)message
{
    return [[[self alert] withTitle:title]
                        withMessage:message];
}

+ (id) alertWithTitle:(NSString*)title
              message:(NSString*)message
         withYesBlock:(AlertButtonBlock)yesBlock
          withNoBlock:(AlertButtonBlock)noBlock
{
    Alert * alert = [Alert alertWithTitle:title
                                  message:message];
    
    [alert addButton:NSLocalizedString(@"Yes", @"Alert - YES") withBlock:yesBlock];
    [alert addButton:NSLocalizedString(@"No" , @"Alert - NO")  withBlock: noBlock];
    
    return alert;
}


- (id)  withTitle:(NSString*)title
{
    self.title = title;
    return self;
}

- (id)  withMessage:(NSString *)message
{
    self.message = message;
    return self;
}

- (id)  addButton:(NSString*)title withBlock:(AlertButtonBlock)block
{
    [alertButtons addObject:[AlertButton alertButtonWithTitle:title
                                                        block:block]];
    return self;
}

- (id)  addButton:(NSString*)title
{
    return [self addButton:title
                 withBlock:NULL];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertButtons[buttonIndex] call];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation AlertButton

+ (id)alertButtonWithTitle:(NSString*)_title
                     block:(AlertButtonBlock)_block
{
    AlertButton * alertButton = [AlertButton new];
    alertButton.title = _title;
    alertButton.block = _block;
    
    return alertButton;
}

- (void) call
{
    if (self.block) {
        self.block();
    }
}

@end
