//
//  OpportunitiesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "OpportunitiesViewController.h"
#import "OpportunityDetailesViewController.h"

//Data
#import "DataStore.h"
#import "OpportunitiesStore.h"
#import "Opportunity.h"
#import "Customer.h"
#import "CBLModelDeleteHelper.h"

@interface OpportunitiesViewController ()
<
CBLUITableDelegate
>
{
    CBLModelDeleteHelper* deleteHelper;
}
@property (nonatomic, weak) OpportunitiesStore* store;

@end

@implementation OpportunitiesViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.modelClass = [Opportunity class];
    self.firstLevelSearchableProperty = @"title";
    deleteHelper = [CBLModelDeleteHelper new];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedCellData = [self opportForPath:indexPath];
    [self performSegueWithIdentifier:@"pushOpportDetailes" sender:tableView];
}

- (Opportunity*)opportForPath:(NSIndexPath*)indexPath
{
    CBLQueryRow *row = [self.currentSource rowAtIndex:indexPath.row];
    return [Opportunity modelForDocument: row.document];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"pushOpportDetailes"]){
        OpportunityDetailesViewController* vc = (OpportunityDetailesViewController*)segue.destinationViewController;
        vc.currentOpport = self.selectedCellData;
    } else if ([segue.identifier isEqualToString:@"opportDetails"] && self.filteredCustomer) {
        UINavigationController* navc = (UINavigationController*)segue.destinationViewController;
        OpportunityDetailesViewController* vc = (OpportunityDetailesViewController*)navc.topViewController;
        [vc setCustomer:self.filteredCustomer];
    }
}

- (void) updateQuery
{
    self.store = [DataStore sharedInstance].opportunitiesStore;
    if (self.filteredCustomer)
        self.dataSource.query = [[self.store queryOpportunitiesForCustomer:self.filteredCustomer] asLiveQuery];
    else
        self.dataSource.query = [[self.store queryOpportunities] asLiveQuery];
}

-(UITableViewCell *)couchTableSource:(CBLUITableSource *)source cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[source tableView] dequeueReusableCellWithIdentifier:@"OpportunityCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OpportunityCell"];

    Opportunity *opportunity = [Opportunity modelForDocument:[source.rows[indexPath.row] document]];
    cell.textLabel.text = [opportunity getValueOfProperty:@"title"];
    cell.detailTextLabel.text = opportunity.customer.companyName.length > 0 ? opportunity.customer.companyName : @"";
    return cell;
}

- (bool)couchTableSource:(CBLUITableSource *)source deleteRow:(CBLQueryRow *)row
{
    deleteHelper.item = [Opportunity modelForDocument:row.document];
    deleteHelper.deleteAlertBlock = [self createOnDeleteBlock];
    [deleteHelper showDeletionAlert];
    return NO;
}

-(DeleteBlock)createOnDeleteBlock
{
    __weak typeof(self) weakSelf = self;
    return ^(BOOL shouldDelete){
        if (shouldDelete)
            [weakSelf.currentSource.tableView reloadData];
    };
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSError *error;
    CBLQuery *query = [self.store filteredQuery];
    CBLQueryEnumerator *enumer = [self.dataSource.query run:&error];

    NSMutableArray *matches = [NSMutableArray new];
    for (NSUInteger i = 0; i < enumer.count; i++)
    {
        CBLQueryRow *row = [self.dataSource rowAtIndex:i];
        Opportunity *opp = [Opportunity modelForDocument:row.document];
        NSString* firstSearchString = opp.title;
        NSString* secongSearchString = opp.customer.companyName;
        if ([firstSearchString rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            [matches addObject:opp.title];
        else if ([secongSearchString rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound && secongSearchString)
            [matches addObject:opp.title];
    }
    query.keys = matches;
    self.filteredDataSource.query = [query asLiveQuery];
}

@end
