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
    
    [self waitForExpectationsWithTimeout:6.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testConvert {
    PDFdify *pdfdify = [PDFdify pdfdifyWithOpts:@{@"onFinish":@{@"webdav":@{
                                                                        @"username":@"somebody",
                                                                        @"password":@"myencodedpass",
                                                                        @"url":@"http://programming-motherfucker.com/"
                                                                        }}}];
    XCTestExpectation *resultExpectation = [self expectationWithDescription:@"result"];
    [pdfdify convertPageWithURL:@"http://programming-motherfucker.com/" title:@"Programming" withCompletion:^(NSError *error, NSDictionary *result) {
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        [resultExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];

}



@end
