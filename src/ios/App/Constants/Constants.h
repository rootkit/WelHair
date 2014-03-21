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

#define WEBSOCKET_SERVER_URL @"ws://115.28.208.165:8080"

#define CONFIG_UMSOCIAL_APPKEY @"530c98ec56240bfad303d2d2"
#define CONFIG_WECHAT_ID @"wxa3bf1e76d675b23a"
#define CONFIG_QQ_APP_ID  @"100424468"
#define CONFIG_BAIDU_MAP_KEY  @"mATLLTobcd8XqZIj3xlPt8il"

//#define API_PATH(path) [NSString stringWithFormat:@"http://welhair.com/api%@", path]

#define API_PATH(path) [NSString stringWithFormat:@"http://115.28.208.165/api%@", path]
#define API_SOCIAL_LOGIN API_PATH(@"/socials/login")
#define API_USERS_SIGNIN_EMAIL API_PATH(@"/users/signin/email")
#define API_USERS_SIGNUP_EMAIL API_PATH(@"/users/signup/email")


#define APP_BASE_COLOR              @"206ba7"
#define APP_NAVIGATIONBAR_COLOR     @"206aa7"

#define NAV_BAR_ICON_SIZE  30
#define TOP_TAB_BAR_HEIGHT  40
#define CUSTOME_BOTTOMBAR_HEIGHT  55

#define NOTIFICATION_USER_CREATE_GROUP_SUCCESS  @"CreateGroupSuccessfully"

#define HAIR_STYLE_FACE_CICLE   0
#define HAIR_STYLE_FACE_OVAL    1
#define HAIR_STYLE_FACE_SQUARE  2
#define HAIR_STYLE_FACE_LLONG   3

#define HAIR_STYLE_LENGTH_LONG      0
#define HAIR_STYLE_LENGTH_MIDDLE    1
#define HAIR_STYLE_LENGTH_SHORT     2

#define HAIR_STYLE_QUANTITY_HAVAVY      0
#define HAIR_STYLE_QUANTITY_MIDDLE      1
#define HAIR_STYLE_QUANTITY_LITTLE      2



