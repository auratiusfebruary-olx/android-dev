//
//  DictPickerView.m
//  Couchbase
//
//  Created by Danil on 10/1/13.
//  Copyright (c) 2013 Couchbase All rights reserved.
//

#import "DictPickerView.h"


@interface DictPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@end

@implementation DictPickerView

- (void)setup
{
    [self setDataSource:self];
    [self setDelegate:self];
    [self setShowsSelectionIndicator:YES];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


- (void) setNameFrom:(NSString *)nameFrom {
    _nameFrom = nameFrom;
    [self reloadAllComponents];
}

- (void) setNameTo:(NSString *)nameTo{
    _nameTo = nameTo;
    [self reloadAllComponents];
}

- (NSArray*) resultArray{
    NSArray* array = nil;
    NSInteger firstIndex;
    NSInteger lastIndex;
    NSRange range;
    firstIndex = [self.itemNames indexOfObject:self.nameFrom];
    lastIndex = [self.itemNames indexOfObject:self.nameTo];
    if(firstIndex != NSNotFound && lastIndex != NSNotFound){
        range = NSMakeRange(firstIndex, lastIndex-firstIndex);
    }else if(lastIndex==NSNotFound && firstIndex==NSNotFound){
        return self.itemNames;
    }else if(firstIndex==NSNotFound){
        range = NSMakeRange(0, lastIndex);
    }else{
        range = NSMakeRange(firstIndex, self.itemNames.count-1-firstIndex);
    }
    NSIndexSet* set = [NSIndexSet indexSetWithIndexesInRange:range];
    array = [self.itemNames objectsAtIndexes:set];
    return array;
}


- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    //does nothing
}

- (void)selectItemFirst
{
    [self selectRow:0 inComponent:0 animated:NO];
    [self notifyDidSelectItemName];
}

- (void)setSelectedItemName:(NSString *)itemName
{
    NSAssert([self resultArray], @"here is should be item names");
    NSAssert([self resultArray].count>0, @"item names count should be > 0");
    NSInteger index = [[self resultArray] indexOfObject:itemName];
    if (index != NSNotFound)
    {
        [self selectRow:index inComponent:0 animated:NO];
    }
}

- (NSString *)selectedItemName
{
    NSInteger index = [self selectedRowInComponent:0];
    return [self resultArray][index];
}

#pragma mark -
#pragma UIPicker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self resultArray] count];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 3, 245, 24)];
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
    }

    NSAssert(self.resultArray, @"here is should be item names");
    NSAssert(row < (NSInteger)self.resultArray.count, @"item names count should be > num of row");
    [(UILabel *)(view.subviews)[0] setText:NSLocalizedString([self resultArray][row],[self resultArray][row])];
    
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self notifyDidSelectItemName];
}

- (void) notifyDidSelectItemName
{
    [self.pickerDelegate itemPicker:self didSelectItemWithName:self.selectedItemName];
}

@end
