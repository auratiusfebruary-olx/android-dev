//
//  FilteringViewController.m
//  CBLiteCRM
//
//  Created by Ruslan Musagitov on 01.12.13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "FilteringViewController.h"
#import "BaseStore.h"
#import "BaseModel.h"

@interface FilteringViewController ()
@end

@implementation FilteringViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){}
    return self;
}

- (void)updateQuery{}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.cellIdentifier) {
        [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:self.cellIdentifier bundle:[NSBundle mainBundle]]  forCellReuseIdentifier:self.cellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:self.cellIdentifier bundle:[NSBundle mainBundle]]  forCellReuseIdentifier:self.cellIdentifier];
    } 

    self.dataSource = [CBLUITableSource new];
    self.dataSource.tableView = self.tableView;
    self.tableView.dataSource = self.dataSource;
    self.currentSource = self.dataSource;
    
    self.filteredDataSource = [CBLUITableSource new];
    self.filteredDataSource.tableView = self.searchDisplayController.searchResultsTableView;
    self.searchDisplayController.searchResultsTableView.dataSource = self.filteredDataSource;
    self.searchDisplayController.searchResultsTableView.delegate   = self;
    
    self.searchDisplayController.searchResultsTableView.rowHeight       = self.tableView.rowHeight;
    self.searchDisplayController.searchResultsTableView.backgroundColor = self.tableView.backgroundColor;

    [self updateQuery];
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSError *error;
    CBLQuery *query = [self.store filteredQuery];
    CBLQueryEnumerator *enumer = [self.dataSource.query run:&error];

    NSMutableArray *matches = [NSMutableArray new];
    for (NSUInteger i = 0; i < enumer.count; i++) {
        CBLQueryRow* row = [enumer rowAtIndex:i];
        CBLModel* model = [self.modelClass modelForDocument:row.document];
        NSString* searchableString = [model getValueOfProperty:self.firstLevelSearchableProperty];
        if ([searchableString rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound && searchableString)
            [matches addObject:searchableString];
    }
    query.keys = matches;
    self.filteredDataSource.query = [query asLiveQuery];
}

#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    self.currentSource = self.dataSource;
    [self.tableView reloadData];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    self.currentSource = self.filteredDataSource;
}

- (void)dealloc {
    self.tableView.dataSource = nil;
}


@end
