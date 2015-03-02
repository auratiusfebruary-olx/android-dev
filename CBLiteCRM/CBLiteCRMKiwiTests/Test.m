#import <Kiwi/Kiwi.h>



SPEC_BEGIN(testMathSpec1)

describe(@"Math", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(43)];
    });
});

SPEC_END