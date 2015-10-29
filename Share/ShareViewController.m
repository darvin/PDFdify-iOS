//
//  ShareViewController.m
//  Share
//
//  Created by Sergey Klimov on 10/28/15.
//  Copyright © 2015 Sergey Klimov. All rights reserved.
//

#import "ShareViewController.h"
@import MobileCoreServices;
@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)postUrl:(NSString* )url title:(NSString *)title {
    NSDictionary *payload = @{
        @"url":url,
        @"title":title,
            @"opts": @{
                @"readability": @"true",
                @"onFinish": @{
                    @"webdav": @{
                        @"username": @"testuser",
                        @"password": @"password",
                        @"url": @"http://google.com"
                        }
                    }
                }
        };
    NSData *postData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    NSUInteger postLength = [postData length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://pdfdify.herokuapp.com/convertPage"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d",postLength] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];

    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"requestReply: %@", requestReply);
    }] resume];

}
- (void)didSelectPost {
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    NSItemProvider *itemProvider = item.attachments.firstObject;
    if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
        [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *url, NSError *error) {
            NSString *urlString = url.absoluteString;
            
            [self postUrl:urlString title: @"hi"];
        }];
    }

    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
