//
//  ViewController.m
//  chatLayout
//
//  Created by 张浩波 on 14/12/25.
//  Copyright (c) 2014年 张浩波. All rights reserved.
//

#import "ViewController.h"
#import "ChatTableViewCellFrame.h"
#import "ChatTableViewCell.h"
#import "ChatMessage.h"
#define marginTop 7.0f
#define INPUT_MAX_HEIGHT 100.0f
#define INPUT_MAX_COUNT 500
#define TEXTVIEW_HEIGHT 33.0f
#define TEXTVIEW_BG_HEIGHT 40.0f
#define INPUTVIEW_HEIGHT (TEXTVIEW_HEIGHT + 2 * marginTop)

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ChatTableViewCellDelegate>{
    NSMutableArray  *_allMessagesFrame;
    BOOL keyboardShowing;
    CGFloat originalHeight;
    CGFloat textview_contentsize_height;
}

@property (nonatomic,strong) UITableView *chatTableView;

@property (nonatomic,strong) UIView *inputView;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) TapView *tapView;

@end

@implementation ViewController
@synthesize chatTableView,inputView,textView,tapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubviews];
    [self initData];
    [self setNotification];
    [chatTableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [chatTableView setContentOffset:CGPointMake(0, chatTableView.contentSize.height - chatTableView.bounds.size.height) animated:NO];
}

-(void)loadSubviews{
    self.view.backgroundColor = UIColorFromRGB(0xd8d8d8);
    [self loadInputView];
    [self loadchatTableView];
    [self loadTapView];
}

-(void)initData{
    textview_contentsize_height = TEXTVIEW_HEIGHT;
    originalHeight = textView.contentSize.height;
    _allMessagesFrame = [NSMutableArray array];
    NSString *previousTime = nil;
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"]];
    
    for (NSDictionary *dict in array) {
        
        ChatTableViewCellFrame *messageFrame = [[ChatTableViewCellFrame alloc] init];
        ChatMessage *message = [[ChatMessage alloc] init];
        message.dict = dict;
        message.statusType = MessageSendStatusType_failed;
        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        messageFrame.chatMessage = message;
        previousTime = message.time;
        [_allMessagesFrame addObject:messageFrame];
    }
}

-(void)loadchatTableView{
    chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - INPUTVIEW_HEIGHT) style:UITableViewStylePlain];
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatTableView.allowsSelection = NO;
    chatTableView.backgroundColor = [UIColor clearColor];
    chatTableView.dataSource = self;
    chatTableView.delegate = self;
    [self.view addSubview:chatTableView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((chatTableView.frame.size.width - 1)/2 , -320, 1, 320)];
    lineView.backgroundColor = UIColorFromRGB(0xc8c8c8);
    [chatTableView addSubview:lineView];
    
    UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake((chatTableView.frame.size.width - 25)/2, -25, 25, 25)];
    roundView.backgroundColor = UIColorFromRGB(0xc8c8c8);
    roundView.layer.cornerRadius = 12.5f;
    roundView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    roundView.layer.shadowOffset = CGSizeMake(0, 2);
    [chatTableView addSubview:roundView];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(12.5, 12.5);
    [indicator startAnimating];
    [roundView addSubview:indicator];
}

-(void)loadInputView{
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - INPUTVIEW_HEIGHT, self.view.frame.size.width, INPUTVIEW_HEIGHT)];
    inputView.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [self.view addSubview:inputView];
    
    UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, inputView.frame.size.width, 1.0f)];
    shadow.backgroundColor = [UIColor lightGrayColor];
    [inputView addSubview:shadow];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(5, marginTop, inputView.frame.size.width - 10, TEXTVIEW_HEIGHT)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.textColor = [UIColor blackColor];
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeySend;
    textView.layer.cornerRadius = 3.0f;
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [inputView addSubview:textView];
}

-(void)loadTapView{
    tapView = [[TapView alloc] initWithFrame:chatTableView.frame tapBlock:^{
        [self.view endEditing:YES];
    }];
    tapView.hidden = YES;
    [self.view addSubview:tapView];
}

-(void)setNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    keyboardShowing = YES;
    tapView.hidden = NO;
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        keyboardShowing = NO;
    }];
}

#pragma mark - tableView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 设置数据
    cell.delegate = self;
    cell.chatCellFrame = _allMessagesFrame[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_allMessagesFrame[indexPath.row] cellHeight];
}

#pragma mark - tableviewcell代理方法
-(void)chatTableViewCell:(ChatTableViewCell *)cell didLongPressedOnContentButton:(ChatMessage *)chatMessage{
    NSLog(@"long click content");
}

-(void)chatTableViewCell:(ChatTableViewCell *)cell didOnClickHeadIcon:(MessageType)messageType{
    switch (messageType) {
        case MessageTypeMe:
            NSLog(@"click my icon");
            break;
        case MessageTypeOther:
            NSLog(@"click other icon");
            break;
        default:
            break;
    }
}

-(void)chatTableViewCell:(ChatTableViewCell *)cell didOnClickResendButton:(ChatMessage *)chatMessage{
    NSIndexPath *indexPath = [chatTableView indexPathForCell:cell];
    NSLog(@"click resend button %ld",(long)indexPath.row);
    ChatTableViewCellFrame *cellFrame =  _allMessagesFrame[indexPath.row];
    cellFrame.chatMessage.statusType = MessageSendStatusType_waiting;
    [chatTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - uiscrollview 代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!keyboardShowing){
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        float reload_distance = 10;
        if(y > h + reload_distance + 80) {
            if (!textView.isFirstResponder) {
                //NSLog(@"scroll to end");
                [textView becomeFirstResponder];
            }
        }
    }
}

#pragma mark uitextviewdelegate
- (void)textViewDidChange:(UITextView *)_textView{
    [self updateContentView];
}

-(void)updateContentView{
    //    commentTextView.scrollEnabled = YES;
    //    CGFloat height = [textView.text sizeWithFont:textView.font constrainedToSize:CGSizeMake(textView.frame.size.width, INPUT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping].height;
    CGFloat textview_contentsize_height_will = textView.contentSize.height;
    if (textview_contentsize_height_will < originalHeight ) {
        textview_contentsize_height = originalHeight;
    }else if (textview_contentsize_height_will >= INPUT_MAX_HEIGHT) {
        textview_contentsize_height = INPUT_MAX_HEIGHT;
    }else{
        textview_contentsize_height = textview_contentsize_height_will;
    }
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textview_contentsize_height);
    
    CGFloat inputViewHeight = textview_contentsize_height + 2 * marginTop;
    
    inputView.frame = CGRectMake(inputView.frame.origin.x, self.view.frame.size.height - inputViewHeight, inputView.frame.size.width, inputViewHeight);
    
    chatTableView.frame = CGRectMake(chatTableView.frame.origin.x, chatTableView.frame.origin.y, chatTableView.frame.size.width, self.view.frame.size.height - inputViewHeight);
    [chatTableView setContentOffset:CGPointMake(0, chatTableView.contentSize.height - chatTableView.bounds.size.height) animated:NO];
}

-(void)textViewEditChanged:(NSNotification *)obj{
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > INPUT_MAX_COUNT) {
                textView.text = [toBeString substringToIndex:INPUT_MAX_COUNT];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > INPUT_MAX_COUNT) {
            textView.text = [toBeString substringToIndex:INPUT_MAX_COUNT];
        }
    }
}

-(BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        if (![_textView.text.trimmedString isEqualToString:@""]) {
            NSString *content = _textView.text.trimmedString;
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            NSDate *date = [NSDate date];
            fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
            NSString *time = [fmt stringFromDate:date];
            [self addMessageWithContent:content time:time];
            // 2、刷新表格
            [chatTableView reloadData];
            // 3、滚动至当前行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
            [chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            // 4、清空文本框内容
            _textView.text = @"";
            _textView.contentSize = CGSizeMake(0, TEXTVIEW_HEIGHT);
            [self updateContentView];
        }
        return NO;
        
    }
    
    return YES;
    
}

#pragma mark 给数据源增加内容

- (void)addMessageWithContent:(NSString *)content time:(NSString *)time{
    ChatTableViewCellFrame *mf = [[ChatTableViewCellFrame alloc] init];
    ChatMessage *msg = [[ChatMessage alloc] init];
    msg.content = content;
    msg.time = time;
    msg.icon = @"icon01.png";
    msg.type = MessageTypeMe;
    mf.chatMessage = msg;
    [_allMessagesFrame addObject:mf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface TapView(){
    TapBlock _tapBlock;
}

@end

@implementation TapView

-(id)initWithFrame:(CGRect)frame tapBlock:(TapBlock)tapBlock{
    self = [super initWithFrame:frame];
    if (self) {
        _tapBlock = tapBlock;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.view == self){
        self.hidden = YES;
        if (_tapBlock) _tapBlock();
    }
}

@end
