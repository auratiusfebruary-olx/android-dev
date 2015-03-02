//
//  ImagePickerAngel.h
//  
//
//  Created by Andrew on 18.09.13.
//  Copyright (c) 2013 Couchbase All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImagePickerAngelBlock) (UIImage * image);
typedef void (^ImagePickerAngelDeleteBlock) (void);

@interface ImagePickerAngel : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) UIViewController * parentViewController;
@property (nonatomic, copy) void (^onPickedImage) (UIImage * image);
@property (nonatomic, copy) void (^onDeleteImage) (void);
- (void) presentImagePicker;

@end
