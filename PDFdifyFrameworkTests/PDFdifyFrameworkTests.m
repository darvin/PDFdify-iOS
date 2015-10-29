//
//  PDFdifyFrameworkTests.m
//  PDFdifyFrameworkTests
//
//  Created by Sergey Klimov on 10/28/15.
//  Copyright © 2015 Sergey Klimov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PDFdify.h"
@interface PDFdifyFrameworkTests : XCTestCase

@end

@implementation PDFdifyFrameworkTests



- (void)testPasswordEncrypt{
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"result"];
    NSString *password = @"my password";
    [PDFdify encryptString:password withCompletion:^(NSError *error, NSString *result) {
        XCTAssertNil(error);

        XCTAssertNotNil(result);
        XCTAssertFalse([password isEqualToString:result]);
        [resultExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testConvert {
    PDFdify *pdfdify = [PDFdify pdfdifyWithOpts:@{@"onFinish":@{@"open":@(YES)}}];
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"result"];
    [pdfdify convertPageWithURL:@"http://wikipedia.org" title:@"Wikipedia" withCompletion:^(NSError *error, NSDictionary *result) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [resultExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];

}



@end
