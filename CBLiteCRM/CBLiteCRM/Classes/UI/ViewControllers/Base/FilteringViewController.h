//
//  FilteringViewController.h
//  CBLiteCRM
//
//  Created by Ruslan Musagitov on 01.12.13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

@class BaseStore;

@interface FilteringViewController : UIViewController 
<
UITableViewDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate,
CBLUITableDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CBLUITableSource* dataSource;

@property (nonatomic, strong) CBLUITableSource* filteredDataSource;
@property (nonatomic, weak) CBLUITableSource* currentSource;

@property (nonatomic, strong) NSString *firstLevelSearchableProperty;
@property (nonatomic, strong) NSString *secondLevelSearchableProperty;

@property (readwrite) Class modelClass;
@property (nonatomic, weak) BaseStore *store;

@property (nonatomic, strong) NSString *cellIdentifier;

- (void) updateQuery;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;

@end
