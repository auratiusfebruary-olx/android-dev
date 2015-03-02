//
//  UIView+Activity.m
//
//  Created by Andrew on 7/7/11.
//  Copyright 2011 Al Digit. All rights reserved.
//
//  Based on GIST: https://gist.github.com/andrew-tokarev/4116199
//
//  Updated at 9/05/2013 - Version 1.4

#import "UIView+Activity.h"

#define kActivityViewCancelButtonWidth    80.f
#define kActivityViewCancelButtonHeight   37.f
#define kActivityViewCancelButtonYOffset  20.f

@interface ActivityView : UIView {
    UIActivityIndicatorView * activityView;
    
    UIButton * cancelButton;
    
    ActivityViewCancelBlock cancelBlock;
}
@property (nonatomic, copy) ActivityViewCancelBlock cancelBlock;
@end


@implementation ActivityView

@synthesize cancelBlock;

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)color indicatorStyle:(UIActivityIndicatorViewStyle)style cancelBlock:(ActivityViewCancelBlock)block
{
    if((self = [super initWithFrame:frame])) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor  = color;
        self.cancelBlock      = block;
        
         activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        [activityView startAnimating];
        
        [self addSubview:activityView];
    }
    return self;
}

- (void)dealloc
{
    [activityView stopAnimating];
}

- (void) layoutSubviews {
	[super layoutSubviews];
    
    // Center
	activityView.frame = CGRectMake(self.frame.size.width/2  - activityView.frame.size.width/2,
									self.frame.size.height/2 - activityView.frame.size.height/2,
									activityView.frame.size.width,
									activityView.frame.size.height);
    
    // Center bellow activity view
    cancelButton.frame = CGRectMake(self.frame.size.width/2  - kActivityViewCancelButtonWidth/2,
                                    activityView.frame.origin.y + activityView.frame.size.height + kActivityViewCancelButtonYOffset,
                                    kActivityViewCancelButtonWidth,
                                    kActivityViewCancelButtonHeight);
}

- (void) setCancelBlock:(ActivityViewCancelBlock)aCancelBlock
{
    // Block
    cancelBlock = [aCancelBlock copy];
        
    // Button
    if (cancelBlock) {
        
        if (!cancelButton) {
             cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            [cancelButton setTitleColor:[UIColor grayColor]
                               forState:UIControlStateDisabled];

            [cancelButton setTitle:NSLocalizedString(@"Cancel", @"ActivityView Cancel Button Title")
                          forState:UIControlStateNormal];

            [cancelButton addTarget:self action:@selector(onCancelAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:cancelButton];
        }
        [cancelButton setEnabled:YES];
    }
    else {
        
        [cancelButton removeFromSuperview];
         cancelButton = nil;
    }
}

- (void) onCancelAction
{
    if (cancelBlock) {
        cancelBlock();
    }
    [cancelButton setEnabled:NO];
}

@end


/// Category
@implementation UIView (Activity)

- (ActivityView*) findActivityView
{
    @synchronized(self) {
        // This method is not quite effective, but
        // I decided to avoid using Runtime Property to prevent complex modification of the view where we are injecting Activity View

        for (UIView * view in self.subviews) {
            if ([view isKindOfClass:[ActivityView class]]) {
                return (ActivityView*) view;
            }
        }
    }
    return nil;
}

- (void) showActivityWithBackgroundColor:(UIColor*)color indicatorStyle:(UIActivityIndicatorViewStyle)style cancelBlock:(void(^)(/*empty*/))block
{
    @synchronized(self) {
        
        [self hideActivity]; // to remove any other if any
        
        ActivityView * activityView = [[ActivityView alloc] initWithFrame:self.bounds
                                                          backgroundColor:color
                                                           indicatorStyle:style
                                                              cancelBlock:block];

        [self addActivityView:activityView];
    }
}

- (void)  showActivityWithBackgroundColor:(UIColor*)color indicatorStyle:(UIActivityIndicatorViewStyle)style
{
    [self showActivityWithBackgroundColor:color
                           indicatorStyle:style
                              cancelBlock:NULL];
}

- (void) showActivity
{
    [self showActivityWithBackgroundColor:[UIColor colorWithWhite:1.f
                                                            alpha:0.7] indicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)  showActivityWithBackgroundWhite
{
    [self showActivityWithBackgroundColor:[UIColor whiteColor] indicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)  showActivityWithBackgroundWhiteAndCancelBlock:(void(^)(/*empty*/))block
{
    
    [self showActivityWithBackgroundColor:[UIColor whiteColor]
                           indicatorStyle:UIActivityIndicatorViewStyleGray
                              cancelBlock:block];
}

- (void) hideActivity
{
    @synchronized(self) {
        
        ActivityView * activityView = [self findActivityView];
        
        if  (activityView) {
            [activityView removeFromSuperview];
        }
        
        activityView = nil;
    }
}

- (BOOL) isInActivity
{
    return ([self findActivityView] != nil);
}

- (void) addActivityView:(ActivityView*)activityView
{
    // Add SubView
    [self addSubview:activityView];
    
    // Update Frame
    activityView.frame = [self bounds];
    
    // Layout...
    [self setNeedsLayout];
}

@end
