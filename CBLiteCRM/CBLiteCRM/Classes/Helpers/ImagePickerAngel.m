//
//  ImagePickerAngel.m
//  
//
//  Created by Andrew on 18.09.13.
//  Copyright (c) 2013 Couchbase All rights reserved.
//

#import "ImagePickerAngel.h"
#import "ActionSheet.h"

@implementation ImagePickerAngel

- (void) presentImagePicker
{
    if ([self isParentViewControllerNotAvailable]) return;
    
    [self presentImagePickerActionSheet];
}

- (void) presentImagePickerActionSheet
{
    ActionSheet * actionSheet = [[ActionSheet new] withCancelButtonDefault];
    
    if ([self canUseCameraToPickImage]) {
        [self addTakePhotoActionToSheet:actionSheet];
    }
    [self addUseLibraryActionToSheet:actionSheet];
    [self addDeleteActionToSheet:actionSheet];

    [actionSheet showInView:self.parentViewController.view];
}

- (void)addTakePhotoActionToSheet:(ActionSheet *)actionSheet
{
    [self actionSheet:actionSheet
            addButton:NSLocalizedString(@"Take A Photo", @"Take A Photo")
       withPickerType:UIImagePickerControllerSourceTypeCamera];
}

- (void)addUseLibraryActionToSheet:(ActionSheet *)actionSheet
{
    [self actionSheet:actionSheet
            addButton:NSLocalizedString(@"Choose An Existing Photo",@"Choose An Existing Photo")
       withPickerType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)addDeleteActionToSheet:(ActionSheet *)actionSheet
{
    [actionSheet addOtherButton:NSLocalizedString(@"Delete Photo",@"Delete Photo") block:self.onDeleteImage];
}

- (void)actionSheet:(ActionSheet *)actionSheet addButton:(NSString *)title withPickerType:(UIImagePickerControllerSourceType)pickerType
{
    [actionSheet addOtherButton:title block:^{
        [self presentImagePickerWithSourceType:pickerType];
    }];
}

- (void) presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    [self.parentViewController presentViewController:[self createImagePickerOfSourceType:sourceType]
                                            animated:YES
                                          completion:NULL];
}

- (UIImagePickerController *)createImagePickerOfSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController * uiImagePickerController = [[UIImagePickerController alloc] init];
    uiImagePickerController.delegate                  = self;
    uiImagePickerController.allowsEditing             = YES;
    uiImagePickerController.sourceType                = sourceType;
    
    return uiImagePickerController;
}

- (void) callOnPickedImageBlockWithImage:(UIImage*)image
{
    if (self.onPickedImage)
        self.onPickedImage(image);
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];

    UIImage * pickedImage = [info valueForKey:@"UIImagePickerControllerEditedImage"];

    [self callOnPickedImageBlockWithImage:pickedImage];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    // After Image Picker is shown status bar is set to black for some reason
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Utils

- (BOOL) isParentViewControllerNotAvailable
{
    return self.parentViewController == nil;
}

- (BOOL) canUseCameraToPickImage
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void) presentImagePickerForPhotoLibrary
{
    [self presentImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

@end
