//
//  ContactsByOpportunityViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/10/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "ContactsByOpportunityViewController.h"

#import "DataStore.h"
#import "ContactOpportunityStore.h"
#import "ContactOpportunity.h"
#import "Contact.h"
#import "ContactCell.h"
#import "ContactDetailsViewController.h"

@interface ContactsByOpportunityViewController ()
{
    Contact* selectedContact;
}
@end

@implementation ContactsByOpportunityViewController

- (void)updateQuery
{
    self.store = [DataStore sharedInstance].contactOpportunityStore;
    CBLQuery *query = [(ContactOpportunityStore*)self.store queryContactsForOpportunity:self.filteredOpp];
    self.dataSource.query = [query asLiveQuery];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"presentContactSelectionForOpportunity"]) {
        ContactsViewController* vc = (ContactsViewController*)segue.destinationViewController;
        vc.chooser = YES;
        vc.filteringOpportunity = self.filteredOpp;
        [vc setOnSelectContact:^(Contact * ct) {
            ContactOpportunity *ctOpp = [[ContactOpportunity alloc] initInDatabase:[DataStore sharedInstance].database withContact:ct andOpportunity:self.filteredOpp];
            NSLog(@"ContactOpportunity created %@", ctOpp);
        }];
    } else if ([segue.identifier isEqualToString:@"presentContactDetails"]) {
        ContactDetailsViewController* vc = (ContactDetailsViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        vc.currentContact = selectedContact;
    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selPath = [self.currentSource.tableView indexPathForSelectedRow];
    selectedContact = [[ContactOpportunity modelForDocument:[(CBLUITableSource*)tableView.dataSource rowAtIndex:selPath.row].document] contact];
    [self performSegueWithIdentifier:@"presentContactDetails" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)couchTableSource:(CBLUITableSource *)source cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [[source tableView] dequeueReusableCellWithIdentifier:kContactCellIdentifier];
    CBLQueryRow *row = [(CBLUITableSource *)self.tableView.dataSource rowAtIndex:indexPath.row];
    ContactOpportunity *ctOpp = [ContactOpportunity modelForDocument:row.document];
    cell.contact = ctOpp.contact;
    return cell;
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSError *error;
    CBLQuery *query = [self.store filteredQuery];
    CBLQueryEnumerator *enumer = [self.dataSource.query run:&error];

    NSMutableArray *matches = [NSMutableArray new];
    for (NSUInteger i = 0; i < enumer.count; i++) {
        CBLQueryRow *row = [self.dataSource rowAtIndex:i];
        ContactOpportunity *ctOpp = [ContactOpportunity modelForDocument:row.document];
        NSString* searchableString = ctOpp.contact.email;
        if ([searchableString rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            [matches addObject:ctOpp.document.documentID];
    }
    query.keys = matches;
    self.filteredDataSource.query = [query asLiveQuery];
}

@end
