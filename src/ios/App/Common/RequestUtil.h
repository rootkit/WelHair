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

@interface RequestUtil : NSObject

+(ASIHTTPRequest *)createGetRequestWithURL:(NSURL *)url andParam:(NSDictionary *)params;
+(ASIHTTPRequest *)createGetRequestWithURL:(NSURL *)url andCoordinate:(CLLocationCoordinate2D )coordinate andParam:(NSDictionary *)params;
+(ASIFormDataRequest *)createPOSTRequestWithURL:(NSURL *)url andData:(NSDictionary *)data;
+(ASIFormDataRequest *)createPUTRequestWithURL:(NSURL *)url andData:(NSDictionary *)data;

@end
