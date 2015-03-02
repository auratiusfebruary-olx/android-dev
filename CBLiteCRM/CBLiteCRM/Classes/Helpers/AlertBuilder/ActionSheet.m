//
//  ActionSheet.m
//  
//
//  Created by Andrew on 17.06.13.
//  Copyright (c) 2013 Couchbase All rights reserved.
//

#import "ActionSheet.h"
#import <objc/runtime.h>

@interface ActionSheet(/*Private*/)
@property (nonatomic, strong) NSMutableArray * otherButtonTitles;
@property (nonatomic, strong) NSString *      cancelButtonTitle;
@property (nonatomic, strong) NSString * destructiveButtonTitle;
@property (nonatomic, strong) NSMutableDictionary * actionSheetButtons;
@end

@implementation ActionSheet

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    [self callActionSheetBlockWithTitle:buttonTitle];
}

- (void)callActionSheetBlockWithTitle:(NSString *)buttonTitle
{
    ActionSheetButtonBlock
    actionSheetButtonBlock = self.actionSheetButtons[buttonTitle];
    
    if (actionSheetButtonBlock)
        actionSheetButtonBlock();
}

#pragma mark - Buttons

- (id) addOtherButton:(NSString*)title block:(ActionSheetButtonBlock)block
{
    [self addOtherButtonTitle:title];
    [self setActionSheetBlock:block
                     forTitle:title];
    return self;
}

- (id) setCancelButton:(NSString*)title block:(ActionSheetButtonBlock)block
{
    [self setCancelButtonTitle:title];
    [self setActionSheetBlock:block
                     forTitle:title];
    return self;
}

- (id) withCancelButtonDefault
{
    return [self setCancelButton:NSLocalizedString(@"Cancel", @"Action Sheet Cancel Button Title")
                           block:NULL];
}

- (id) setDistructiveButton:(NSString*)title block:(ActionSheetButtonBlock)block
{
    [self setDestructiveButtonTitle:title];
    [self setActionSheetBlock:block
                     forTitle:title];
    return self;
}

- (id)  withTitle: (NSString*)title
{
    self.title = title;
    
    return self;
}

+ (id) actionSheet
{
    return [self new];
}

+ (id) actionSheetWithTitle:(NSString*)title
{
    return [[self actionSheet] withTitle:title];
}

- (id)init
{
    if (self = [super init]) {
        self.actionSheetButtons = [NSMutableDictionary new];
        self.otherButtonTitles  = [NSMutableArray new];
    }
    return self;
}

- (UIActionSheet *)buildActionSheet
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:self.title
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:nil];
    [self addAllButtonTitlesToActionSheet:actionSheet];

    [self attachSelfToView:actionSheet];
    
    return actionSheet;
}

- (void) showInView:(UIView*)view
{
    [[self buildActionSheet] showInView:view];
}

#pragma mark - 

- (void)addAllButtonTitlesToActionSheet:(UIActionSheet *)actionSheet
{
    for (NSString * title in self.otherButtonTitles) {
        [actionSheet addButtonWithTitle:title];
    }
    if (self.cancelButtonTitle) {
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:self.cancelButtonTitle];
    }
    if (self.destructiveButtonTitle)
    {
        actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:self.destructiveButtonTitle];
    }
}

#pragma mark - Utils

- (void) addOtherButtonTitle:(NSString*)title
{
    if (title)
        [self.otherButtonTitles addObject:title];
}

- (void) setActionSheetBlock:(ActionSheetButtonBlock)block forTitle:(NSString*)title
{
    if (title && block)
        [self.actionSheetButtons setObject:block
                                    forKey:title];
}

- (BOOL) isValidTitle:(NSString*)title
{
    return title != nil;
}

#pragma mark - Attach/Retain

static char ActionSheetAssociateObjectKey;

- (void)attachSelfToView:(UIView *)view
{
    objc_setAssociatedObject(view, &ActionSheetAssociateObjectKey, self, OBJC_ASSOCIATION_RETAIN);
}

@end
