//
//  CBLModelDeleteHelper.h
//  CBLiteCRM
//
//  Created by Ruslan on 12/25/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

typedef void (^DeleteBlock)(BOOL shouldDelete);

@interface CBLModelDeleteHelper : NSObject
<
UIAlertViewDelegate
>

@property (nonatomic, strong) CBLModel* item;
@property (nonatomic, strong) DeleteBlock deleteAlertBlock;

- (id)initWithItem:(CBLModel*)item;
- (void)showDeletionAlert;

@end
