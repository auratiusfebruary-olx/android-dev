#import <Kiwi/Kiwi.h>
#import "AppDelegate.h"
#import "DataStore.h"
#import "CBLSyncManager.h"


@interface AppDelegate ()

- (void)setupAppearance;
- (void)setupCBLSync;
- (void)setupDatabase:(DataStore*)store;
@end

SPEC_BEGIN(AppDelegateSpec)

describe(@"initialisation all services", ^{
    
    context(nil, ^{
        
        __block AppDelegate* app;
        __block DataStore* store;
        __block CBLSyncManager* cblSync;
        beforeEach(^{
            app = [AppDelegate new];
            store = [KWMock nullMock];
            cblSync = [KWMock nullMock];
            app.cblSync = cblSync;
            [app setupDatabase:store];
        });
        
        afterEach(^{
            app = nil;
        });

        context(@"on app didFinishLaunchingWithOptions actions", ^{
            
            it(@"should setup all nesesary managers and UI appearance", ^{
                
                [[app should] receive:@selector(setupAppearance)];
                [[app should] receive:@selector(setupDatabase:)];
                [[app should] receive:@selector(setupCBLSync)];
                [app.cblSync shouldNotBeNil];
                [app application:[KWMock nullMock] didFinishLaunchingWithOptions:[KWMock nullMock]];
                
            });
        });
        
        context(@"on logout actions", ^{
            it(@"should call logout for DataStore and CBLSyncManager", ^{
                
                [[[store should] receive] logout];
                [[[cblSync should] receive] logout];
                [app logout];
                
            });
        });

    });
});

SPEC_END