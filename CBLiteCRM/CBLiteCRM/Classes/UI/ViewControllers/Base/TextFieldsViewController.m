//
//  TextFieldsViewController.m
//
//  Created by Danil on 8/7/13.
//

#import "TextFieldsViewController.h"


@interface TextFieldsViewController ()

@end

@implementation TextFieldsViewController{
    CGFloat savedHeight;
}


#pragma mark - Keyboard Logic


#pragma mark - View controller

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerKeyboardObserver];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterKeyboardObserver];
}

- (void)dealloc
{
    [self unregisterKeyboardObserver];
}

- (void)setupScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.baseScrollView setContentSize:self.contentView.frame.size];
}

#pragma mark - Keyboard observer

- (void)registerKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unregisterKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (void)beginKeyboardAnimations:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    NSTimeInterval duration =
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve =
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect endFrame =
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    endFrame = [[[UIApplication sharedApplication] keyWindow] convertRect:endFrame
                                                                   toView:self.view];
    if(savedHeight==0)
        savedHeight = self.view.frame.size.height;
    [self beginKeyboardAnimations:notification];
    [self adjustForKeyboardUp:endFrame.origin.y];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self adjustForKeyboardDown:savedHeight];
    savedHeight=0;
}

- (void)adjustForKeyboardUp:(CGFloat)viewHeight {
    CGRect newFrame = self.view.frame;
    newFrame.size.height = viewHeight;
    self.view.frame = newFrame;
}

- (void)adjustForKeyboardDown:(CGFloat)viewHeight {
    CGRect newFrame = self.view.frame;
    newFrame.size.height = viewHeight;
    self.view.frame = newFrame;
}

@end
