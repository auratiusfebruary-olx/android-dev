//
//  UIViewController+ReadOnlyOrWriteMode.m
//  CBLiteCRM
//
//  Created by Danil on 24/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "UIViewController+ReadOnlyOrWriteMode.h"
#import "TextFieldView.h"

@implementation UIViewController (ReadOnlyOrWriteMode)
@dynamic deleteButton, textFields, buttons;

- (void)setEditMode:(BOOL)editMode
{
    [self changeRightButtonTitleForMode:editMode];
    [self changeLeftButtonTitleForMode:editMode];
    self.deleteButton.hidden = !editMode;
    for (TextFieldView* view in self.textFields)
        view.editMode = editMode;
    [self editModeChanged:editMode];
}

- (BOOL)isEditMode
{
    return [self.navigationItem.rightBarButtonItem.title isEqualToString:kSaveTitle];
}

- (void)changeRightButtonTitleForMode:(BOOL)editMode
{
    if(editMode)
        self.navigationItem.rightBarButtonItem.title = kSaveTitle;
    else
        self.navigationItem.rightBarButtonItem.title = kEditTitle;
}

- (void)changeLeftButtonTitleForMode:(BOOL)editMode
{
    if(editMode)
        self.navigationItem.leftBarButtonItem.title = kCancelTitle;
    else
        self.navigationItem.leftBarButtonItem.title = kBackTitle;
}


- (void)editModeChanged:(BOOL)editMode{}

@end
