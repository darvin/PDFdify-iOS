//
//  PDFdify.h
//  PDFdify
//
//  Created by Sergey Klimov on 10/28/15.
//  Copyright © 2015 Sergey Klimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFdify : NSObject
+ (instancetype)pdfdifyWithOpts:(NSDictionary *)opts;
+ (void)encryptString:(NSString *)string withCompletion:(void (^)(NSError *error, NSString* result))completionHandler;
- (void)convertPageWithURL:(NSString *)url title:(NSString *)title withCompletion:(void (^)(NSError *error, NSDictionary *result))completionHandler;
@end
