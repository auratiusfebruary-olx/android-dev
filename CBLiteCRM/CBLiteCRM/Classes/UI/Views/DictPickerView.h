//
//  DictPickerView.h
//  Couchbase
//
//  Created by Danil on 10/1/13.
//  Copyright (c) 2013 Couchbase All rights reserved.
//

#import <UIKit/UIKit.h>



@class DictPickerView;
@protocol DictPickerViewDelegate <UIPickerViewDelegate>

- (void)itemPicker:(DictPickerView *)picker didSelectItemWithName:(NSString *)name;

@end

@interface DictPickerView : UIPickerView

@property (nonatomic, strong) NSArray* itemNames;
@property (nonatomic, weak) id<DictPickerViewDelegate> pickerDelegate;
@property (nonatomic, copy) NSString *selectedItemName;
@property (nonatomic, strong) NSString* nameFrom;
@property (nonatomic, strong) NSString* nameTo;
- (void) selectItemFirst;

@end
