//
//  FakeDataHelper.m
//  WelHair
//
//  Created by lu larry on 3/1/14.
//  Copyright (c) 2014 Welfony. All rights reserved.
//

#import "FakeDataHelper.h"
#import "Work.h"
#import "Comment.h"
#import "Group.h"
#import "Product.h"
#import "ChatSession.h"
#import "Coupon.h"
#import "Address.h"
#import "Service.h"
#import "Appointment.h"
#import "Order.h"
@implementation FakeDataHelper


+(id)SharedInstance
{
    static FakeDataHelper *sharedInstance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FakeDataHelper alloc] init];
    });
    return sharedInstance;
}

+(NSArray *)getFakeHairWorkImgs
{
    return @[@"http://pic.mf08s.com/201011/20/c30.jpg",
             @"http://model.zdface.com/news/smallimg/atitle201003041351546937.jpg",
             @"http://luxury.zdface.com/news/smallimg/atitle201010261025178428.jpg",
             @"http://man.zdface.com/news/smallimg/atitle201010191359289550.jpg",
             @"http://pic.mf08s.com/201011/18/t8.jpg",
             @"http://www.zdface.com/news/smallimg/atitle200909232126449011.jpg",
             @"http://beauty.zdface.com/news/smallimg/atitle201107021415336426.jpg",
             @"http://pic.mf08s.com/201106/13/b27.jpg",
             @"http://pic.mf08s.com/201011/20/c80.jpg",
             @"http://pic.mf08s.com/201011/18/t30.jpg"];
}

+(NSArray *)getFakeWorkList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Work *work = [Work new];
        work.imgUrlList = @[@"http://i2.skinpp.com.cn/2013/09/11/20130911233809_195_w580.jpg",
                            @"http://y0.ifengimg.com/6a44e90e48f13dc2/2013/1008/ori_52536015c7bac.jpeg"];
        
        Staff *staff = [Staff new];
        staff.name = @"Larry";
        work.creator = staff;
        [ar addObject:work];
    }
    return ar;
}

+(NSArray *)getFakeGroupList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Group *group = [Group new];
        
        group.imgUrls = @[@"http://img0.aibangjuxin.com/ipic/51f1abfead26fb22_0.jpg"];
        group.name = @"一剪美工作室";
        group.address = @"济南高新区牛王庄路西";
        group.distance = 1;
        [ar addObject:group];
    }
    return ar;
}




+ (Group *)getFakeGroup
{
    Group *group = [Group new];
    
    group.imgUrls = @[@"http://img0.aibangjuxin.com/ipic/51f1abfead26fb22_0.jpg",@"http://img0.aibangjuxin.com/ipic/51f1abfead26fb22_0.jpg"];
    group.name = @"一剪美工作室";
    group.address = @"济南高新区牛王庄路西";
    group.distance = 1;
    return group;
}

+(NSArray *)getFakeProductList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Product *product = [Product new];
        product.name = @"护发素，洗发水";
        Group *group = [Group new];
        group.name = @"永琪";
        group.logoUrl = @"http://img0.aibangjuxin.com/ipic/51f1abfead26fb22_0.jpg";
        group.address = @"济南高新区牛王庄路西";
        group.distance = 12;
        product.group = group;
        product.price = 87.9;
        product.imgUrlList = @[@"http://4.xiustatic.com/upload/goods20111107/65002396/650023960001/g1_600_600.1339481667492.jpg",@"http://d12.yihaodianimg.com/t1/2011/1117/506/180/3500538_600x600.jpg"];
        [ar addObject:product];
    }
    return ar;
}

+(NSArray *)getFakeChatGroupList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        ChatSession *session = [ChatSession new];
        session.name = @"金三胖儿，奥巴马";
        session.description = @"最近咋样，老哥?";
        session.lastDate = [NSDate date];
        session.imgUrl = @"http://i2.skinpp.com.cn/2013/09/11/20130911233809_195_w580.jpg";
        [ar addObject:session];
    }
    return ar;
}

+(NSArray *)getFakeCommentList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Comment *comment = [Comment new];
        comment.description = @"这个化妆水厉害,能易容";
        comment.createdDate = [NSDate date];
        [ar addObject:comment];
    }
    return ar;
}

+(NSArray *)getFakeStaffList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Staff *staff = [Staff new];
        staff.name = @"高级总监";
        staff.group = [Group new];
        staff.group.name = @"上海永琪";
        staff.rate = 0.5;
        staff.description = @"最近咋样，老哥?";
        staff.distance = 1.2;
        staff.works =[FakeDataHelper getFakeWorkList];
        staff.services = [FakeDataHelper getFakeServiceList];
        staff.bio = @"蓝翔技校美容美发专业毕业";
        [ar addObject:staff];
    }
    return ar;
}
+ (NSArray *)getFakeServiceList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Service *s = [Service new];
        s.name = @"精剪";
        s.originalPrice = 10;
        s.salePrice = 5;
        [ar addObject:s];
    }
    return ar;
}

+(NSArray *)getFakeCouponList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Coupon *coupon = [Coupon new];
        coupon.imgUrl = @"http://i2.skinpp.com.cn/2013/09/11/20130911233809_195_w580.jpg";
        coupon.name = @"仅售10元，价值218元的烫染洗";
        coupon.address = @"济南高新区牛王庄路西";
        coupon.groupName = @"阿东造型";
        coupon.distance = 1;
        [ar addObject:coupon];
    }
    return ar;
}

+(NSArray *)getFakeAddressLit
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Address *address = [Address new];
        address.userName = @"张三";
        address.phoneNumber = @"125555555555";
        address.detailAddress = @"济南高新区牛王庄路西,鸿腾三馆对面,左转走300米";
        address.id = i;
        address.isDefault = 0;
        [ar addObject:address];
    }
    return ar;
}

+ (NSArray *)getFakeAppointmentList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Appointment *a = [Appointment new];
        a.service = [FakeDataHelper getFakeServiceList][i];
        a.staff = [FakeDataHelper getFakeStaffList][i];
        a.price = 12;
        a.date = [NSDate date];
        [ar addObject:a];
    }
    return ar;
}

+ (NSArray *)getFakeOrderList
{
    NSMutableArray *ar = [NSMutableArray array];
    for (int i = 0; i < 10 ; i++) {
        Order *o = [Order new];
        o.id = i;
        o.address = [FakeDataHelper getFakeAddressLit][i];
        o.product = [FakeDataHelper getFakeProductList][i];
        o.group = [FakeDataHelper getFakeGroupList][i];
        o.status = OrderStatusEnum_Paid;
        o.price = 149.0;
        o.count = 2;
        [ar addObject:o];
    }
    return ar;
}

+(Address *)getFakeDefaultAddress
{
    return [[FakeDataHelper  getFakeAddressLit] objectAtIndex:1];
}

+ (void)setUserCreateGroupSuccess
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"UserAdmin"];
}

+ (void)setUserJoinGroupSuccess
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"UserJoinGroup"];
}

+ (BOOL)isUserGroupAdmin
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserAdmin"] isEqualToString:@"1"];
}
+ (BOOL)isUserGroupStaff
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserJoinGroup"] isEqualToString: @"1"];
}

+ (void)savePickedCity:(NSString *)cityName
{
    if(cityName.length == 0){
        cityName = EMPTY_STRING;
    }
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"pickedCity"];
}

+ (NSString *)getPickedCity
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"pickedCity"];
}

+ (bool)isLogin
{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    return str.length > 0;
}
+ (void)login
{
   [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"login"];
}
+ (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserAdmin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserJoinGroup"];
}

@end
