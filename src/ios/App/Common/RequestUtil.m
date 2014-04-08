// ==============================================================================
//
// This file is part of the WelSpeak.
//
// Create by Welfony <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

#import "RequestUtil.h"
#import "RequestUtils.h"
#import "UserManager.h"

@implementation RequestUtil

+(ASIHTTPRequest *)createGetRequestWithURL:(NSURL *)url andParam:(NSDictionary *)params
{

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[url URLWithQuery:[NSString URLQueryWithParameters:params]]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];

    NSMutableDictionary *contextParams = [[NSMutableDictionary alloc] initWithCapacity:2];
    [contextParams setObject:@([UserManager SharedInstance].userLogined.id) forKey:@"currentUserId"];
    [contextParams setObject:@"36.68278473,117.02496707" forKey:@"currentLocation"];
    [request addRequestHeader:@"WH-Context" value:[Util parseJsonFromObject:contextParams]];


    return request;
}

+(ASIFormDataRequest *)createPOSTRequestWithURL:(NSURL *)url andData:(NSDictionary *)data
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];

    NSMutableDictionary *contextParams = [[NSMutableDictionary alloc] initWithCapacity:2];
    [contextParams setObject:@([UserManager SharedInstance].userLogined.id) forKey:@"currentUserId"];
    [request addRequestHeader:@"WH-Context" value:[Util parseJsonFromObject:contextParams]];

    request.requestMethod = @"POST";

    if (data) {
        [request setPostBody:[[[Util parseJsonFromObject:data] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy]];
    }

    return request;
}

+(ASIFormDataRequest *)createPUTRequestWithURL:(NSURL *)url andData:(NSDictionary *)data
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];

    NSMutableDictionary *contextParams = [[NSMutableDictionary alloc] initWithCapacity:2];
    [contextParams setObject:@([UserManager SharedInstance].userLogined.id) forKey:@"currentUserId"];
    [request addRequestHeader:@"WH-Context" value:[Util parseJsonFromObject:contextParams]];

    request.requestMethod = @"PUT";

    if (data) {
        [request setPostBody:[[[Util parseJsonFromObject:data] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy]];
    }

    return request;
}

@end
