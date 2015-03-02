//
//  SalesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

//UI
#import "SalesViewController.h"
#import "SalesPersonOptionsViewController.h"
#import "SalesPersonCell.h"
#import "AppDelegate.h"
//Data
#import "DataStore.h"
#import "SalePersonsStore.h"
#import "SalesPerson.h"


@interface SalesViewController ()
@property(nonatomic, strong) SalesPerson* selectedCellData;
@property(nonatomic, weak) SalePersonsStore* store;
@end

@implementation SalesViewController
@synthesize needLogout;
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.modelClass = [SalesPerson class];
    self.firstLevelSearchableProperty = @"name";
}
- (void) updateQuery
{
    self.store = [DataStore sharedInstance].salePersonsStore;
    SalesPerson *user = [[DataStore sharedInstance] salePersonsStore].user;
    if (user.approved && !user.isAdmin) {
        self.dataSource.query = [[self.store approvedUsersQuery] asLiveQuery];
    } else if (!user.approved && !user.isAdmin) {
        self.dataSource.query = [[self.store nonAdminNonApprovedUsersQuery:user.user_id] asLiveQuery];
    } else if (user.isAdmin){
        self.dataSource.query = [[self.store allUsersQuery] asLiveQuery];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (UITableViewCell *)couchTableSource:(CBLUITableSource*)source cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesPersonCell *cell = [[source tableView] dequeueReusableCellWithIdentifier:kSalesPersonCell];
    CBLQueryRow *row = [source rowAtIndex:indexPath.row];
    SalesPerson *salesPerson = [SalesPerson modelForDocument: row.document];
    cell.salesPerson = salesPerson;
    cell.checkmark.hidden = ![[DataStore sharedInstance] salePersonsStore].user.isAdmin;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    if([self isRowMe:row])
        style = UITableViewCellEditingStyleDelete;
    return style;
}

- (bool)couchTableSource:(CBLUITableSource*)source
               deleteRow:(CBLQueryRow*)row{
    SalesPerson *salesPerson = [SalesPerson modelForDocument: row.document];
    BOOL isMe = [self isRowMe:row];
    if(isMe)
        [self logout];
    NSError* error;
    [salesPerson deleteDocument:&error];
    if(error){
        NSLog(@"error in deleting: %@", error);
    }
    return isMe;
}

- (BOOL)isRowMe:(CBLQueryRow*)row{
    SalesPerson *salesPerson = [SalesPerson modelForDocument: row.document];
    BOOL isMe = [[DataStore sharedInstance].salePersonsStore.user.user_id isEqualToString:salesPerson.user_id];
    return isMe;
}

- (void)logout{
    for (id<LogoutProtocol> vc in self.navigationController.viewControllers) {
        if([vc respondsToSelector:@selector(setNeedLogout:)]){
            vc.needLogout = YES;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedCellData = [self salesForPath:indexPath];
    [self performSegueWithIdentifier:@"presentSalesPersonOptions" sender:tableView];
}

- (SalesPerson*)salesForPath:(NSIndexPath*)indexPath{
    SalesPerson* sls;
    CBLQueryRow *row = [self.currentSource rowAtIndex:indexPath.row];
    sls = [SalesPerson modelForDocument: row.document];
    return sls;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SalesPersonOptionsViewController *salesPersonOptionsViewController = [segue destinationViewController];
    salesPersonOptionsViewController.salesPerson = self.selectedCellData;
}

@end
