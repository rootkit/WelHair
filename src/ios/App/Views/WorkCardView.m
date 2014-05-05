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

#import "CircleImageView.h"
#import "Comment.h"
#import "UserManager.h"
#import "Work.h"
#import "WorkCardView.h"

@interface WorkCardView ()

@property (nonatomic, strong) Work *workData;

@property (nonatomic, strong) UIImageView *hairImgView;
@property (nonatomic, strong) ToggleButton *heartBtn;
@property (nonatomic, strong) UILabel *heartCountLbl;

@property (nonatomic, strong) CircleImageView *commentorImgView;
@property (nonatomic, strong) UILabel *commentCountLbl;
@property (nonatomic, strong) UILabel *commentContentLbl;
@property (nonatomic, strong) UILabel *commentorNameLbl;

@end

@implementation WorkCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        float width = frame.size.width;

        self.hairImgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, width - 4, width - 4)];
        [self addSubview:self.hairImgView];
        
        
       
        
        
        self.commentorImgView = [[CircleImageView alloc] initWithFrame:CGRectMake(5,
                                                                              MaxY(self.hairImgView)+ 5,
                                                                              30,
                                                                              30)];
        self.commentorImgView.borderWidth = 2;
        [self addSubview:self.commentorImgView];
        
        // comment
        self.commentorNameLbl =
        [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.commentorImgView) + 5,
                                                  Y(self.commentorImgView),
                                                  WIDTH(self) - (MaxX(self.commentorImgView) + 10),
                                                  12)];
        self.commentorNameLbl.font = [UIFont systemFontOfSize:12];
        self.commentorNameLbl.backgroundColor = [UIColor clearColor];
        self.commentorNameLbl.textColor = [UIColor colorWithHexString:@"ba725a"];
        

        [self addSubview:self.commentorNameLbl];
        
        self.commentContentLbl =
        [[UILabel alloc] initWithFrame:CGRectMake(X(self.commentorNameLbl),
                                                  MaxY(self.commentorNameLbl)+4,
                                                  WIDTH(self.commentorNameLbl),
                                                  12)];
        self.commentContentLbl.numberOfLines = 0;
        self.commentContentLbl.font = [UIFont systemFontOfSize:12];
        self.commentContentLbl.backgroundColor = [UIColor clearColor];
        self.commentContentLbl.textColor = [UIColor grayColor];

        [self addSubview:self.commentContentLbl];
        
        UIView *linerView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(self.commentContentLbl) + 5, WIDTH(self), 1)];
        linerView.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
        [self addSubview:linerView];
        
        
        self.commentCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, MaxY(linerView) + 5, width/2 ,20)];
        self.commentCountLbl.font = [UIFont systemFontOfSize:14];
        self.commentCountLbl.backgroundColor = [UIColor clearColor];
        self.commentCountLbl.textColor = [UIColor colorWithHexString:@"1f6ba7"];
        [self addSubview:self.commentCountLbl];
        
        // heart
        FAKIcon *heartIconOn = [FAKIonIcons ios7HeartIconWithSize:25];
        [heartIconOn addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
        FAKIcon *heartIconOff = [FAKIonIcons ios7HeartOutlineIconWithSize:25];
        [heartIconOff addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e43a3d"]];
        self.heartBtn = [ToggleButton buttonWithType:UIButtonTypeCustom];
        __weak WorkCardView *selfDelegate = self;
        [self.heartBtn setToggleButtonOnImage:[heartIconOn imageWithSize:CGSizeMake(25, 25)]
                                       offImg:[heartIconOff imageWithSize:CGSizeMake(25, 25)]
                           toggleEventHandler:^(BOOL isOn){
                               return [selfDelegate favClick:isOn];
                           }];
        self.heartBtn.frame = CGRectMake(WIDTH(self) - 25 - 15-20, Y(self.commentCountLbl),25, 25);
        [self addSubview:self.heartBtn];
        
        self.heartCountLbl =
        [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.heartBtn),
                                                  Y(self.commentCountLbl)+6,
                                                  30,
                                                  12)];
        self.heartCountLbl.numberOfLines = 0;
        self.heartCountLbl.textAlignment = NSTextAlignmentLeft;
        self.heartCountLbl.font = [UIFont systemFontOfSize:12];
        self.heartCountLbl.backgroundColor = [UIColor clearColor];
        self.heartCountLbl.textColor = [UIColor grayColor];
        [self addSubview:self.heartCountLbl];
        


    }

    return self;
}

- (float)setupWithData:(Work *)workData
{
    self.workData = workData;

    [self.hairImgView setImageWithURL:[NSURL URLWithString:workData.imgUrlList[0]]];

    self.commentCountLbl.text = [NSString stringWithFormat:@"评论(%d)", workData.commentCount];
    self.heartBtn.on = workData.isfav;
    self.heartCountLbl.text = [NSString stringWithFormat:@"(%d)", 111];


    [self.commentorImgView setImageWithURL:workData.creator.avatorUrl];
    self.commentorNameLbl.text = workData.creator.name;
    self.commentContentLbl.text = workData.creator.group.name;

    [self drawBottomShadowOffset:1 opacity:1];

    return HEIGHT(self);
}


- (BOOL)favClick:(BOOL)markFav
{
    if(![UserManager SharedInstance].userLogined){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_LOGIN_VIEW object:nil];
        return NO;
    }
    
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", [[UserManager SharedInstance] userLogined].id] forKey:@"CreatedBy"];
    [reqData setObject:[NSString stringWithFormat:@"%d", markFav ? 1 : 0] forKey:@"IsLike"];

    ASIFormDataRequest *request = [RequestUtil createPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_WORKS_LIKE, self.workData.id]]
                                                                andData:reqData];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(addLikeFinish:)];
    [request setDidFailSelector:@selector(addLikeFail:)];
    [request startAsynchronous];
    return YES;
}

- (void)addLikeFinish:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];

    if (request.responseStatusCode == 200) {
        NSDictionary *responseMessage = [Util objectFromJson:request.responseString];
        if (responseMessage) {
            if ([[responseMessage objectForKey:@"success"] intValue] == 1) {
                return;
            }
        }
    }
}

- (void)addLikeFail:(ASIHTTPRequest *)request
{
}


@end
