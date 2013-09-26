//
//  VKRequest.h
//  Poster
//
//  Created by Alyssa Ross on 26/09/2013.
//  Copyright (c) 2013 Alyssa Ross. All rights reserved.
//

#import "AFNetworking.h"
#import <Foundation/Foundation.h>

@interface VKRequest : NSObject

@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, copy) NSDictionary *parameters;

+ (VKRequest *)lastRequest;

- (instancetype)initWithMethod:(NSString *)method URL:(NSURL *)URL parameters:(NSDictionary *)parameters;

- (void)sendRequestWithCompletion:(void (^)(NSString *responseOrErrorDescription, BOOL success))completion;

@end
