
//
//  TextFieldView.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/25/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "TextFieldView.h"
#import "UIView+IsA.h"

@interface TextFieldView ()

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIButton    *actionButton;
@property (nonatomic, weak) UIImageView *background; // TODO: to be removed

@end

@implementation TextFieldView

-(void)awakeFromNib {
    for (UIView *view in [self subviews])
    {
        if ([view isUITextField]) {
            self.textField = (UITextField*)view;
        }
        else
        if ([view isUIButton]) {
            self.actionButton = (UIButton*)view;
            
            [self addTextFieldObserver];
        }
        else
        if ([view isUIImageView]) {
            self.background = (UIImageView*)view;
        }
    }
    self.editMode = self.textField.enabled;
    NSAssert(self.textField, @"textField should not be nil");
}

- (void)dealloc
{
    if ([self hasActionButton])
        [self removeTextFieldObserver];
}

- (void)updateButtonTitleWithText
{
    NSString * title = self.textField.text;
    
    [self.actionButton setTitle:title
                       forState:UIControlStateNormal];
    
    [self hideActionButtonIfContentIsBlank];
}

// TODO: findout if this really necessary
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    [self.textField becomeFirstResponder];
//}

- (void)setEditMode:(BOOL)editMode {
    _editMode = editMode;
    
    if([self hasActionButton]) {
        
        self.textField.hidden    =!editMode;
        self.actionButton.hidden = editMode;
        
        [self updateButtonTitleWithText]; // KVO does not work here
    }

    self.textField.enabled = editMode;
    
    if (editMode)
        [self.background setImage:[UIImage imageNamed:@"input_field.png"]];
    else
        [self.background setImage:[UIImage imageNamed:@"input_field_disabled.png"]];
}

- (BOOL) hasActionButton
{
    return self.actionButton != nil;
}

- (BOOL) isEmptyTextInField
{
    return [self.textField.text isEqualToString:@""];
}

- (void)hideActionButtonIfContentIsBlank
{
    if([self isEmptyTextInField]) {
        self.actionButton.hidden = YES;
    }
    else
    if(![self editMode]) {
         self.actionButton.hidden = NO;
    }
}

#pragma Observer Delegate

// TODO: move this somewhere out: something like KV Binder.

#define kTextFieldViewObservableKeyPath @"text"

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:kTextFieldViewObservableKeyPath])
    {
        [self updateButtonTitleWithText];

        return;
    }
    
    if ([super respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]) {
		[super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)addTextFieldObserver;
{
    [self.textField addObserver:self
                     forKeyPath:kTextFieldViewObservableKeyPath
                        options:0 context:NULL];
}

- (void)removeTextFieldObserver
{
    [self.textField removeObserver:self
                        forKeyPath:kTextFieldViewObservableKeyPath];
}

@end
