//
//  PDFdify.m
//  PDFdify
//
//  Created by Sergey Klimov on 10/28/15.
//  Copyright © 2015 Sergey Klimov. All rights reserved.
//

#import "PDFdify.h"

@implementation PDFdify {
    NSDictionary *_opts;
}
- (instancetype)initWithOpts:(NSDictionary *)opts {
    if (self = [super init]) {
        _opts = opts;
    }
    return self;
}

+ (instancetype)pdfdifyWithOpts:(NSDictionary *)opts {
    return [[self alloc] initWithOpts:opts];
}
+ (void)postRequestToEndpoint:(NSString *)endpoint payload:(NSDictionary *)payload completion:(void (^)(NSError *error, NSDictionary *result))completionHandler {
    NSData *postData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    NSUInteger postLength = [postData length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://pdfdify.herokuapp.com/%@", endpoint]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d",postLength] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        completionHandler(error, result);
    }] resume];

}

+ (void)encryptString:(NSString *)string withCompletion:(void (^)(NSError *error, NSString* result))completionHandler {
    [self postRequestToEndpoint:@"encrypt" payload:@{@"string":string} completion:^(NSError *error, NSDictionary *result) {
                                                                     completionHandler(error, result[@"encrypted"]);
                                                                 }];

}
- (void)convertPageWithURL:(NSString *)url title:(NSString *)title withCompletion:(void (^)(NSError *error, NSDictionary *result))completionHandler {
    [[self class] postRequestToEndpoint:@"convertPage" payload:@{
                                                                @"title":title,
                                                                @"url":url,
                                                                @"opts":_opts
                                                                } completion:^(NSError *error, NSDictionary *result) {
                                                                    completionHandler(error, result);
                                                                }];
}


@end
