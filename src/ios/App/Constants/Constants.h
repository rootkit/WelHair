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

#define HOME_SITE @"http://115.28.208.165/api"
#define CONFIG_UMSOCIAL_APPKEY @"530c98ec56240bfad303d2d2"
#define CONFIG_WECHAT_ID @"wxa3bf1e76d675b23a"
#define CONFIG_QQ_APP_ID  @"101061921"
#define CONFIG_QQ_APP_KEY @"65ee635188efe517af93da656e8777da"
#define CONFIG_BAIDU_MAP_KEY  @"mATLLTobcd8XqZIj3xlPt8il"

#define DB_FILE_NAME   @"db.sqlite"

//#define API_PATH(path) [NSString stringWithFormat:@"http://welhair.com/api%@", path]

#define API_PATH(path) [NSString stringWithFormat:@"http://115.28.208.165/api%@", path]

#define API_APPOINTMENTS_CREATE API_PATH(@"/appointments")
#define API_APPOINTMENTS_UPDATE API_PATH(@"/appointments/%d")

#define API_SOCIAL_LOGIN API_PATH(@"/socials/login")

#define API_USERS_SIGNIN_EMAIL API_PATH(@"/users/signin/email")
#define API_USERS_SIGNUP_EMAIL API_PATH(@"/users/signup/email")
#define API_USERS_DETAIL API_PATH(@"/users/%d")
#define API_USERS_UPDATE API_PATH(@"/users/%d")
#define API_USERS_APPOINTMENT API_PATH(@"/users/%d/appointments")
#define API_USERS_POINTS API_PATH(@"/users/%d/points")

#define API_SERVICES_SEARCH API_PATH(@"/services")
#define API_SERVICES_CREATE API_PATH(@"/services")
#define API_SERVICES_Remove API_PATH(@"/services/%d/remove")

#define API_WORKS_SEARCH API_PATH(@"/works")
#define API_WORKS_LIKED API_PATH(@"/works/liked")
#define API_WORKS_CREATE API_PATH(@"/works")
#define API_WORKS_DETAIL API_PATH(@"/works/%d")
#define API_WORKS_COMMENT_CREATE API_PATH(@"/works/%d/comments")
#define API_WORKS_LIKE API_PATH(@"/works/%d/likes")
#define API_WORKS_REMOVE API_PATH(@"/works/%d/remove")

#define API_STAFFS_SEARCH API_PATH(@"/staffs")
#define API_STAFFS_LIKED API_PATH(@"/staffs/liked")
#define API_STAFFS_LIKE API_PATH(@"/staffs/%d/likes")
#define API_STAFFS_DETAIL API_PATH(@"/staffs/%d")
#define API_STAFFS_WORKS API_PATH(@"/staffs/%d/works")
#define API_STAFFS_SERVICE API_PATH(@"/staffs/%d/services")
#define API_STAFFS_COMMENT_CREATE API_PATH(@"/staffs/%d/comments")
#define API_STAFFS_APPOINTMENT API_PATH(@"/staffs/%d/appointments")

#define API_COMPANIES_SEARCH API_PATH(@"/companies")
#define API_COMPANIES_LIKED API_PATH(@"/companies/liked")
#define API_COMPANIES_CREATE API_PATH(@"/companies")
#define API_COMPANIES_DETAIL API_PATH(@"/companies/%d")
#define API_COMPANIES_JOIN API_PATH(@"/companies/%d/join")
#define API_COMPANIES_LIKE API_PATH(@"/companies/%d/likes")
#define API_COMPANIES_COMMENT_CREATE API_PATH(@"/companies/%d/comments")

#define API_UPLOAD_PICTURE API_PATH(@"/upload/image")
#define API_GOODS_COMMENT_CREATE API_PATH(@"/goods/%d/comments")


#define APP_BASE_COLOR              @"206ba7"
#define APP_NAVIGATIONBAR_COLOR     @"206aa7"
#define APP_CONTENT_BG_COLOR        @"f2f2f2"


#define NAV_BAR_ICON_SIZE  30
#define TOP_TAB_BAR_HEIGHT  40
#define CUSTOME_BOTTOMBAR_HEIGHT  55

#define NOTIFICATION_USER_CREATE_GROUP_SUCCESS  @"CreateGroupSuccessfully"
#define NOTIFICATION_USER_STATUS_CHANGE  @"UserStatusChanged"
#define NOTIFICATION_REFRESH_APPOINTMENT @"RefreshAppintmentList"

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

#define TABLEVIEW_PAGESIZE_DEFAULT 10

#define CHARACTER_ARRAY  @[@'A',@'B',@'C',@'D',@'E',@'F',@'G',@'H',@'I',@'J',@'K',@'L',@'M',@'N',@'O',@'P',@'Q',@'R',@'S',@'T',@'U',@'V',@'W',@'X',@'Y',@'Z']


#define  JINAN_CENTER_COORDINATE  CLLocationCoordinate2DMake(36.670266,117.149292);

