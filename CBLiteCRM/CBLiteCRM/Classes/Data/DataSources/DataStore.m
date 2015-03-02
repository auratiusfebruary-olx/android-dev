
#import "DataStore.h"
#import "CustomersStore.h"
#import "OpportunitiesStore.h"
#import "SalePersonsStore.h"
#import "ContactsStore.h"
#import "ContactOpportunityStore.h"
#import "OpportunityForContactStore.h"

@interface DataStore()
@end

@implementation DataStore


- (id) init{
    self = [super init];
    if (self) {
        CBLManager *manager = [CBLManager sharedInstance];
        
        NSError *error;
        _database = [manager databaseNamed: @"fb_sg" error: &error];
        if (error) {
            NSLog(@"error getting database %@",error);
        }
        [self initStores];
    }
    return self;
}

+ (DataStore *) sharedInstance{
    static dispatch_once_t predicate = 0;
    static DataStore *object = nil;
    
    dispatch_once(&predicate, ^{
        object = [self new];
    });
    
	return object;
}

- (void)initStores{
    _salePersonsStore = [[SalePersonsStore alloc] initWithDatabase:self.database];
    _customersStore = [[CustomersStore alloc] initWithDatabase:self.database];
    _opportunitiesStore = [[OpportunitiesStore alloc] initWithDatabase:self.database];
    _contactsStore = [[ContactsStore alloc] initWithDatabase:self.database];
    _contactOpportunityStore = [[ContactOpportunityStore alloc] initWithDatabase:self.database];
    _opportunityContactStore = [[OpportunityForContactStore alloc] initWithDatabase:self.database];
}

- (void) logout{
    self.salePersonsStore.user = nil;
}

@end
