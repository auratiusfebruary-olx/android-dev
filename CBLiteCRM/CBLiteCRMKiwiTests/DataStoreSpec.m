SPEC_BEGIN(DataStoreSpec)

describe(@"initialisation all services", ^{
    
    context(nil, ^{
        
        __block DataStore* store;
        beforeEach(^{
            store = [DataStore new];
        });
        
        afterEach(^{
            store = nil;
        });
        
    });
});

SPEC_END