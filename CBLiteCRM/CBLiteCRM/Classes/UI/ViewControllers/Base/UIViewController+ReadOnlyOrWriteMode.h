//
//  UIViewController+ReadOnlyOrWriteMode.h
//  CBLiteCRM
//
//  Created by Danil on 24/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldView;

@protocol EditableViewControllers

@property (strong, nonatomic) IBOutletCollection(TextFieldView) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

- (BOOL)isEditMode;
- (void)setEditMode:(BOOL)editMode;
- (void)changeRightButtonTitleForMode:(BOOL)editMode;
- (void)editModeChanged:(BOOL)editMode;

@end

@interface UIViewController(ReadOnlyOrWriteMode)<EditableViewControllers>


@end
