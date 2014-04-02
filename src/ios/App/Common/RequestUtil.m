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
    NSMutableDictionary *newParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    [newParams setObject:[NSString stringWithFormat:@"%d", [UserManager SharedInstance].userLogined.id] forKey:@"currentUserId"];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[url URLWithQuery:[NSString URLQueryWithParameters:newParams]]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];

    return request;
}

+(ASIFormDataRequest *)createPOSTRequestWithURL:(NSURL *)url andData:(NSDictionary *)data
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setPostBody:[[[Util parseJsonFromObject:data] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy]];

    return request;
}

+(ASIFormDataRequest *)createPUTRequestWithURL:(NSURL *)url andData:(NSDictionary *)data
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.requestMethod = @"PUT";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];

    return request;
}

@end
