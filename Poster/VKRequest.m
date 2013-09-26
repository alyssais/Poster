//
//  VKRequest.m
//  Poster
//
//  Created by Alyssa Ross on 26/09/2013.
//  Copyright (c) 2013 Alyssa Ross. All rights reserved.
//

#import "VKRequest.h"

@implementation VKRequest

+ (NSArray *)savedKeys
{
    return @[@"method", @"URL", @"parameters"];
}

+ (VKRequest *)lastRequest
{
    VKRequest *request = [VKRequest new];
    request.method = [[NSUserDefaults standardUserDefaults] objectForKey:@"method"];
    request.URL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"URL"]];
    request.parameters = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"parameters"];
    return request;
}

- (instancetype)initWithMethod:(NSString *)method URL:(NSURL *)URL parameters:(NSDictionary *)parameters;
{
    self = [self init];
    self.method = method;
    self.URL = URL;
    self.parameters = parameters;
    return self;
}

- (void)sendRequestWithCompletion:(void (^)(NSString *, BOOL))completion
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:self.URL];
    NSURLRequest *request = [client requestWithMethod:self.method path:@"" parameters:self.parameters];
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        completion([[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding], YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion([error localizedDescription], NO);
    }];
    [operation start];

    [self saveAsLastRequest];
}

- (void)saveAsLastRequest
{
    [[NSUserDefaults standardUserDefaults] setObject:self.method forKey:@"method"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.URL absoluteString] forKey:@"URL"];
    [[NSUserDefaults standardUserDefaults] setObject:self.parameters forKey:@"parameters"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@", self.method, self.URL, self.parameters];
}

@end
