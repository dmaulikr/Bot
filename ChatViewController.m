//
//  ChatViewController.m
//  Bot
//
//  Created by tiny on 16/9/27.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageModel.h"

#define HEIGHT_CHATVIEW_BOTTOM 50
#define WIDTH_BOTTOM_BUTTON 30

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UIView *viewBottom;
    BOOL isCHat;
}
@property (nonatomic,strong)NSMutableArray *marrData;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initBottomView];
    
    isCHat = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initTableView {
    self.tableview.frame = CGRectMake(0, 0, SW, SH-64-HEIGHT_CHATVIEW_BOTTOM);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
}

- (void)initBottomView {
    viewBottom = [[UIView alloc] init];
    viewBottom.frame = CGRectMake(0, SH-HEIGHT_CHATVIEW_BOTTOM, SW, HEIGHT_CHATVIEW_BOTTOM);
    viewBottom.backgroundColor = HEX_RGB(0xe7e7e7);
    [self.view addSubview:viewBottom];
    
    UIButton *btnVoice = [UIButton buttonWithType:UIButtonTypeCustom];
    btnVoice.frame = CGRectMake(10, (HEIGHT_CHATVIEW_BOTTOM-30)/2, 30, 30);
    btnVoice.backgroundColor = HEX_RGB(0xffffff);
    [viewBottom addSubview:btnVoice];
    
    UITextView *tvInput = [[UITextView alloc] init];
    tvInput.frame = CGRectMake(btnVoice.right + 10, (HEIGHT_CHATVIEW_BOTTOM-WIDTH_BOTTOM_BUTTON)/2, SW-10*4-WIDTH_BOTTOM_BUTTON*2, WIDTH_BOTTOM_BUTTON);
    tvInput.returnKeyType = UIReturnKeyDone;
    tvInput.delegate = self;
    tvInput.layer.borderColor = HEX_RGB(0x000000).CGColor;
    tvInput.layer.borderWidth = 1;
    [viewBottom addSubview:tvInput];
    
    UIButton *btnEmoji = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEmoji.frame = CGRectMake(SW-10-WIDTH_BOTTOM_BUTTON, (HEIGHT_CHATVIEW_BOTTOM-WIDTH_BOTTOM_BUTTON)/2, WIDTH_BOTTOM_BUTTON, WIDTH_BOTTOM_BUTTON);
    btnEmoji.backgroundColor = HEX_RGB(0xffffff);
    [viewBottom addSubview:btnEmoji];
}

- (NSMutableArray *)marrData {
    if(!_marrData) {
        _marrData = [NSMutableArray array];
    }
    return _marrData;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.marrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *chatCellID = @"chatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCellID];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatCellID];
    }
    [cell.contentView removeAllSubviews];
    
    UILabel *labMessage = [[UILabel alloc] init];
    labMessage.frame = CGRectMake(10, 10, SW-20, 30);
    labMessage.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:labMessage];
    
    MessageModel *model = _marrData[indexPath.row];
    if(model.messageType == messageType_self) {
        labMessage.textAlignment = NSTextAlignmentRight;
        cell.contentView.backgroundColor = [UIColor greenColor];
    }else{
        labMessage.textAlignment = NSTextAlignmentLeft;
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    labMessage.text = model.message;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(isCHat) {
        [self scrollToBottom];
        isCHat = NO;
    }
}

- (void)requestBotMessage:(NSString *)string {
    [[HttpManager manager] requestInfoWithText:string withSuccess:^(NSString *string) {
        
        NSLog(@"string other: %@",string);
        MessageModel *model = [MessageModel new];
        model.messageType = messageType_Other;
        model.message = string;
        [self.marrData addObject:model];
        [self.tableview reloadData];
        isCHat = YES;
    } withFailed:^(NSString *string) {
        
    }];
}

- (void)saveMessageModel:(NSString *)string {
    DEBUGLOG(@"string self debug : %@",string);
    INFOLOG(@"string self info : %@",string);
    WARNINGLOG(@"string self warning : %@",string);
    ERRORLOG(@"string self error : %@",string);
    MessageModel *model = [MessageModel new];
    model.messageType = messageType_self;
    model.message = string;
    [self.marrData addObject:model];
    [self.tableview reloadData];
    isCHat = YES;
}

#pragma mark textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self saveMessageModel:textView.text];
        [self requestBotMessage:textView.text];
        textView.text = nil;
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark keyboardNotifications
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = [endFrameValue CGRectValue];
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = viewBottom.frame;
        if(frame.origin.y == SH-HEIGHT_CHATVIEW_BOTTOM) {
            frame.origin.y -= endFrame.size.height;
            viewBottom.frame = frame;
            CGRect tFrame = self.tableview.frame;
            tFrame.size.height -= endFrame.size.height;
            self.tableview.frame = tFrame;
            [self scrollToBottom];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = viewBottom.frame;
        frame.origin.y = SH - HEIGHT_CHATVIEW_BOTTOM;
        viewBottom.frame = frame;
        CGRect tFrame = self.tableview.frame;
        tFrame.size.height = SH - HEIGHT_CHATVIEW_BOTTOM - 64;
        self.tableview.frame = tFrame;
    }];
}

- (void)scrollToBottom {
    //判断tableView是否滑动到底部 如果没有 则滑动到底部
    CGPoint contentOffsetPoint = self.tableview.contentOffset;
    CGRect frame = self.tableview.frame;
    if(contentOffsetPoint.y == self.tableview.contentSize.height-frame.size.height || self.tableview.contentSize.height<frame.size.height)
    {
        //scroll ended
    }else
    {
        CGPoint bottomPoint = CGPointMake(0,self.tableview.contentSize.height-frame.size.height);
        [self.tableview setContentOffset:bottomPoint animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
