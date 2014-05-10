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

#define CONFIG_UMSOCIAL_APPKEY @"530c98ec56240bfad303d2d2"
#define CONFIG_WECHAT_ID @"wxa3bf1e76d675b23a"
#define CONFIG_QQ_APP_ID  @"101061921"
#define CONFIG_QQ_APP_KEY @"65ee635188efe517af93da656e8777da"

#define CONFIG_BAIDU_MAP_KEY  @"mATLLTobcd8XqZIj3xlPt8il"

#define CONFIG_XINGE_ACCESSID 2200022202
#define CONFIG_XINGE_ACCESSKEY @"KEYI967MSEC8Z3W"
#define CONFIG_XINGE_SECRETKEY @"112a1622ca89ef99f98e4a04389b18c3"

#define DB_FILE_NAME   @"db.sqlite"

#define DOMAIN_NAME @"115.28.208.165"
//#define DOMAIN_NAME @"welhair.com"

#define WEBSOCKET_SERVER_URL [NSString stringWithFormat:@"ws://%@:8080", DOMAIN_NAME]
#define SITE_PATH(path) [NSString stringWithFormat:@"http://%@%@", DOMAIN_NAME, path]
#define API_PATH(path) [NSString stringWithFormat:@"http://%@/api%@", DOMAIN_NAME, path]

#define SITE_GOODS_CONTENT SITE_PATH(@"/goods/index/content?goods_id=%d")

#define API_APPOINTMENTS_CREATE API_PATH(@"/appointments")
#define API_APPOINTMENTS_UPDATE API_PATH(@"/appointments/%d")

#define API_SOCIAL_LOGIN API_PATH(@"/users/signin/social")

#define API_USERS_SIGNIN_EMAIL API_PATH(@"/users/signin/email")
#define API_USERS_SIGNUP_EMAIL API_PATH(@"/users/signup/email")
#define API_USERS_SIGNIN_MOBILE API_PATH(@"/users/signin/mobile")
#define API_USERS_SIGNUP_MOBILE API_PATH(@"/users/signup/mobile")
#define API_USERS_DETAIL API_PATH(@"/users/%d")
#define API_USERS_UPDATE API_PATH(@"/users/%d")
#define API_USERS_APPOINTMENT API_PATH(@"/users/%d/appointments")
#define API_USERS_POINTS API_PATH(@"/users/%d/points")

#define API_MESSAGES_CREATE API_PATH(@"/messages")
#define API_MESSAGES_LIST API_PATH(@"/messages/to/%d/from/%d")
#define API_MESSAGES_CONVERSATIONS_LIST API_PATH(@"/users/%d/messages/conversations")
#define API_MESSAGES_CONVERSATIONS_UPDATE API_PATH(@"/messages/conversations")
#define API_MESSAGES_CONVERSATIONS_REOMVE API_PATH(@"/messages/conversations/%d")

#define API_SERVICES_SEARCH API_PATH(@"/services")
#define API_SERVICES_CREATE API_PATH(@"/services")
#define API_SERVICES_REMOVE API_PATH(@"/services/%d/remove")

#define API_ADDRESSES_LIST API_PATH(@"/users/%d/addresses")
#define API_ADDRESSES_CREATE API_PATH(@"/addresses")
#define API_ADDRESSES_UPDATE API_PATH(@"/addresses/%d")
#define API_ADDRESSES_REMOVE API_PATH(@"/addresses/%d/remove")
#define API_ADDRESSES_DEFAULT API_PATH(@"/addresses/%d/default")

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
#define API_STAFFS_CLIENTS API_PATH(@"/staffs/%d/clients")
#define API_STAFFS_SERVICE API_PATH(@"/staffs/%d/services")
#define API_STAFFS_COMMENT_CREATE API_PATH(@"/staffs/%d/comments")
#define API_STAFFS_APPOINTMENT API_PATH(@"/staffs/%d/appointments")

#define API_FEEDBACK_CREATE API_PATH(@"/feedback")

#define API_GOODS_SEARCH API_PATH(@"/goods")
#define API_GOODS_LIKE API_PATH(@"/goods/%d/likes")
#define API_GOODS_LIKED API_PATH(@"/goods/liked")
#define API_GOODS_DETAIL API_PATH(@"/goods/%d")
#define API_GOODS_COMMENT_CREATE API_PATH(@"/goods/%d/comments")

#define API_COMPANIES_SEARCH API_PATH(@"/companies")
#define API_COMPANIES_LIKED API_PATH(@"/companies/liked")
#define API_COMPANIES_STAFFS API_PATH(@"/companies/%d/staffs")
#define API_COMPANIES_GOODS API_PATH(@"/companies/%d/goods")
#define API_COMPANIES_STAFFS_STATUS API_PATH(@"/companies/%d/staffs/%d/status")
#define API_COMPANIES_STAFFS_REMOVE API_PATH(@"/companies/%d/staffs/%d/remove")
#define API_COMPANIES_CREATE API_PATH(@"/companies")
#define API_COMPANIES_UPDATE API_PATH(@"/companies/%d")
#define API_COMPANIES_DETAIL API_PATH(@"/companies/%d")
#define API_COMPANIES_NEARBY API_PATH(@"/companies/nearby")
#define API_COMPANIES_JOIN API_PATH(@"/companies/%d/join")
#define API_COMPANIES_LIKE API_PATH(@"/companies/%d/likes")
#define API_COMPANIES_COMMENT_CREATE API_PATH(@"/companies/%d/comments")

#define API_UPLOAD_PICTURE API_PATH(@"/upload/image")


#define APP_BASE_COLOR              @"206ba7"
#define APP_NAVIGATIONBAR_COLOR     @"206aa7"
#define APP_CONTENT_BG_COLOR        @"f2f2f2"


#define NAV_BAR_ICON_SIZE  30
#define TOP_TAB_BAR_HEIGHT  40
#define CUSTOME_BOTTOMBAR_HEIGHT  55

#define NOTIFICATION_USER_REFRESH_GROUP_INFO  @"Notification_RefreshGroupInfo"
#define NOTIFICATION_USER_CREATE_GROUP_SUCCESS  @"Notification_CreateGroupSuccessfully"
#define NOTIFICATION_USER_STATUS_CHANGE  @"Notification_UserStatusChanged"
#define NOTIFICATION_REFRESH_APPOINTMENT @"Notification_RefreshAppintmentList"
#define NOTIFICATION_REFRESH_COMMENTLIST @"Notification_RefreshCommentList"
#define NOTIFICATION_REFRESH_ADDRESSLIST @"Notification_RefreshAddressList"
#define NOTIFICATION_SHOW_LOGIN_VIEW  @"Notification_ShowLoginView"
#define NOTIFICATION_NEW_MESSAGE_RECEIVED @"NewMessageReceived"

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

