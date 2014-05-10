// ==============================================================================
//
// This file is part of the WelHair
//
// Create by Welfony <support@welfony.com>
// Copyright (c) 2013-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

#import "BaseModel.h"
#import "User.h"

typedef enum {
    WHMessageMediaTypeNone = 1,
    WHMessageMediaTypePhoto = 2,
    WHMessageMediaTypeAudio = 3
} WHMessageMediaType;

typedef enum {
    WHMessageTypeUpdateUser = 1,
    WHMessageTypeNewMessage = 2
} WHMessageType;

@interface Message : BaseModel

@property (nonatomic, assign) WHMessageMediaType mediaType;
@property (nonatomic, strong) NSURL *mediaUrl;
@property (nonatomic, strong) User *from;
@property (nonatomic, strong) User *to;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSDate *date;

- (Message *)initWithDic:(NSDictionary *)dictionary;

@end
