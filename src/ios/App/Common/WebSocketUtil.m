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

#import "Message.h"
#import "WebSocketUtil.h"
#import "UserManager.h"

@interface WebSocketUtil () <SRWebSocketDelegate>

@end

@implementation WebSocketUtil

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];

        [NSTimer scheduledTimerWithTimeInterval:5 target:sharedInstance selector:@selector(listenConnection:) userInfo:nil repeats:YES];
    });

    return sharedInstance;
}

- (void)listenConnection:(id)time
{
    if (!_isOpen) {
        [self reconnect];
    }
}

- (void)reconnect
{
    _webSocket.delegate = nil;
    [_webSocket close];

    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEBSOCKET_SERVER_URL]]];
    _webSocket.delegate = self;

    [_webSocket open];
}

- (void)close
{
    [_webSocket close];
    _webSocket.delegate = nil;
    _webSocket = nil;
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    _isOpen = YES;

    if (![UserManager SharedInstance].userLogined) {
        return;
    }

    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dicData setObject:[NSNumber numberWithInt:[UserManager SharedInstance].userLogined.id] forKey:@"UserId"];
    [dicData setObject:[NSNumber numberWithInt:WHMessageTypeUpdateUser] forKey:@"Type"];

    NSString *message = [Util parseJsonFromObject:dicData];
    [_webSocket send:message];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    _isOpen = NO;
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSDictionary *rst = [Util objectFromJson:message];
    if ([[rst objectForKey:@"ToId"] intValue] == [UserManager SharedInstance].userLogined.id) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NEW_MESSAGE_RECEIVED object:rst];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    _isOpen = NO;
    _webSocket = nil;
}

@end
