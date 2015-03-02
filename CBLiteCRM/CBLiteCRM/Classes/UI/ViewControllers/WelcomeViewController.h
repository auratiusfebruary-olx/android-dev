//
//  ViewController.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *asAdmin;

- (IBAction)facebookLogin;

@end
