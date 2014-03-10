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

#import "SRWebSocket.h"

@interface WebSocketUtil : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, assign) BOOL isOpen;

- (void)reconnect;
- (void)close;

@end
