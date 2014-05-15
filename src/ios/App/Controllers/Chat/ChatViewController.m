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
#import "ChatViewController.h"
#import "Message.h"
#import "Staff.h"
#import "WebSocketUtil.h"

@interface ChatViewController ()

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *datasource;

@property (strong, nonatomic) UIImage *willSendImage;

@property (strong, nonatomic) UIImageView *incomingImageView;
@property (strong, nonatomic) UIImageView *outgoingImageView;

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FAKIcon *leftIcon = [FAKIonIcons ios7ArrowBackIconWithSize:NAV_BAR_ICON_SIZE];
        [leftIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftNavItemImg =[leftIcon imageWithSize:CGSizeMake(NAV_BAR_ICON_SIZE, NAV_BAR_ICON_SIZE)];

        self.title = @"聊天";
        self.currentPage = 1;

        self.delegate = self;
        self.dataSource = self;

        self.datasource = [NSMutableArray array];
    }

    return self;
}

- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newMessageReceived:)
                                                 name:NOTIFICATION_NEW_MESSAGE_RECEIVED
                                               object:nil];

    [self setBackgroundColor:[UIColor whiteColor]];

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshActionHandler:^{
        weakSelf.currentPage += 1;
        [weakSelf getMessages];
    }];

    [self.tableView.pullToRefreshView setSize:CGSizeMake(25, 25)];
    [self.tableView.pullToRefreshView setBorderWidth:2];
    [self.tableView.pullToRefreshView setBorderColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setImageIcon:[UIImage imageNamed:@"centerIcon"]];

    [self updateMessageConversation];
    [self getMessages];
}

- (void)newMessageReceived:(NSNotification *)notification
{
    NSDictionary *newMessage = (NSDictionary *)notification.object;
    if ([[newMessage objectForKey:@"FromId"] intValue] == self.incomingUser.id) {
        [self.datasource addObject:[[Message alloc] initWithDic:newMessage]];
        [self.tableView reloadData];

        [JSMessageSoundEffect playMessageReceivedSound];

        [self scrollToBottomAnimated:YES];
    }
}

- (void)setIncomingUser:(User *)incomingUser
{
    _incomingUser = incomingUser;

    self.incomingImageView = [[UIImageView alloc] initWithImage:nil];
    [self.incomingImageView setImageWithURL:incomingUser.avatarUrl placeholderImage:[UIImage imageNamed:@"AvatarDefault"]];
}

- (void)setOutgoingUser:(User *)outgoingUser
{
    _outgoingUser = outgoingUser;

    self.outgoingImageView = [[UIImageView alloc] initWithImage:nil];
    [self.outgoingImageView setImageWithURL:outgoingUser.avatarUrl placeholderImage:[UIImage imageNamed:@"AvatarDefault"]];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.outgoingUser.id] forKey:@"FromId"];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.incomingUser.id] forKey:@"ToId"];
    [reqData setObject:text forKey:@"Body"];
    [reqData setObject:@"1" forKey:@"MediaType"];
    [reqData setObject:[NSNumber numberWithInt:WHMessageTypeNewMessage] forKey:@"Type"];

    if ([WebSocketUtil sharedInstance].isOpen) {
        NSString *message = [Util parseJsonFromObject:reqData];
        [[WebSocketUtil sharedInstance].webSocket send:message];
    }

    Message *msg = [Message new];
    msg.body = text;
    msg.from = self.outgoingUser;
    msg.to = self.incomingUser;
    msg.mediaType = WHMessageMediaTypeNone;
    msg.date = [NSDate date];

    [self.datasource addObject:msg];
    [JSMessageSoundEffect playMessageSentSound];

    [self finishSend];
}

- (void)cameraPressed:(id)sender
{
    [self.inputToolBarView.textView resignFirstResponder];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
}

#pragma mark -- UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;

    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
    }
    [self presentViewController:picker animated:YES completion:NULL];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *msg = [self.datasource objectAtIndex:indexPath.row];
    return (msg.to.id == self.incomingUser.id) ? JSBubbleMessageTypeOutgoing : JSBubbleMessageTypeIncoming;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleSquare;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *msg = [self.datasource objectAtIndex:indexPath.row];
    return msg.mediaType == WHMessageMediaTypeNone ? JSBubbleMediaTypeText : JSBubbleMediaTypeImage;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    return JSAvatarStyleSquare;
}

- (JSInputBarStyle)inputBarStyle
{
    return JSInputBarStyleFlat;
}

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *msg = [self.datasource objectAtIndex:indexPath.row];
    return msg.body;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *msg = [self.datasource objectAtIndex:indexPath.row];
    return msg.date;
}

- (UIImage *)avatarImageForIncomingMessage
{
    return self.incomingImageView.image;
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return self.outgoingImageView.image;
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *msg = [self.datasource objectAtIndex:indexPath.row];
    return msg.mediaUrl;

}

#pragma UIImagePicker Delegate

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.willSendImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.datasource addObject:[NSDictionary dictionaryWithObject:self.willSendImage forKey:@"Image"]];

    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rows inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];

    [JSMessageSoundEffect playMessageSentSound];

    [self scrollToBottomAnimated:YES];

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark Message List API

- (void)getMessages
{
    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:[NSString stringWithFormat:@"%d", self.currentPage] forKey:@"page"];
    [reqData setObject:[NSString stringWithFormat:@"%d", TABLEVIEW_PAGESIZE_DEFAULT] forKey:@"pageSize"];

    ASIHTTPRequest *request = [RequestUtil createGetRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_MESSAGES_LIST, self.incomingUser.id, self.outgoingUser.id]] andParam:reqData];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(finishGetMessages:)];
    [request setDidFailSelector:@selector(failGetMessages:)];
    [request startAsynchronous];
}

- (void)finishGetMessages:(ASIHTTPRequest *)request
{
    NSDictionary *rst = [Util objectFromJson:request.responseString];
    NSInteger total = [[rst objectForKey:@"total"] integerValue];
    NSArray *dataList = [rst objectForKey:@"messages"];

    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.datasource];

    if (self.currentPage == 1) {
        [arr removeAllObjects];
    } else {
        int more = self.datasource.count % TABLEVIEW_PAGESIZE_DEFAULT;
        if (more > 0) {
            int i;

            for (i = 0; i < more; i++) {
                [arr removeObjectAtIndex:i];
                i--;
            }
        }
    }

    for (NSDictionary *dicData in dataList) {
        [arr insertObject:[[Message alloc] initWithDic:dicData] atIndex:0];
    }

    self.datasource = arr;

    BOOL enableInfinite = total > self.datasource.count;
    if (self.tableView.showPullToRefresh != enableInfinite) {
        self.tableView.showPullToRefresh = enableInfinite;
    }

    [self.tableView stopRefreshAnimation];

    [self checkEmpty];

    [self.tableView reloadData];

    if (self.currentPage == 1) {
        [self scrollToBottomAnimated:YES];
    }
}

- (void)failGetMessages:(ASIHTTPRequest *)request
{
}

- (void)checkEmpty
{
    
}

- (void)updateMessageConversation
{

    NSMutableDictionary *reqData = [[NSMutableDictionary alloc] initWithCapacity:1];
    [reqData setObject:@(self.incomingUser.id) forKey:@"FromId"];
    [reqData setObject:@(self.outgoingUser.id) forKey:@"ToId"];
    [reqData setObject:@"0" forKey:@"NewMessageCount"];
    [reqData setObject:@"0" forKey:@"LastMessageId"];

    ASIFormDataRequest *request = [RequestUtil createPUTRequestWithURL:[NSURL URLWithString:API_MESSAGES_CONVERSATIONS_UPDATE]
                                                               andData:reqData];
    [self.requests addObject:request];

    [request startAsynchronous];
}

@end
