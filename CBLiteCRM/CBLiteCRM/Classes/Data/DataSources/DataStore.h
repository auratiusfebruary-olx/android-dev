@class SalesPerson, Contact, Customer, Opportunity, CBLDatabase;
@class SalePersonsStore,CustomersStore, OpportunitiesStore, ContactsStore, ContactOpportunityStore, OpportunityForContactStore;

@interface DataStore : NSObject

- (id) init;

+ (DataStore*) sharedInstance; // will not create database by default
- (void) logout;

@property (readonly) CBLDatabase* database;
@property (readonly, strong) SalePersonsStore* salePersonsStore;
@property (readonly, strong) CustomersStore* customersStore;
@property (readonly, strong) OpportunitiesStore* opportunitiesStore;
@property (readonly, strong) ContactsStore* contactsStore;
@property (readonly, strong) ContactOpportunityStore *contactOpportunityStore;
@property (readonly, strong) OpportunityForContactStore *opportunityContactStore;

@end
