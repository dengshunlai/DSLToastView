//
//  ViewController.m
//  DSLToastView
//
//  Created by 邓顺来 on 16/7/11.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "ViewController.h"
#import "DSLToastView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *texts;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar sizeToFit];
    _tableView.tableHeaderView = searchBar;
    
    _texts = @[@"加载失败",@"信息错误\n请重新输入",@"很长很长很长很长很长很长很长很长很长很长很长很长",
               @"UITableViewDataSource\nUITableViewDelegate\nUIWebViewDelegate\n延长显示时间",
               @"底部toast",@"M-V-C\nM-V-V-M",@"很长很长很长很长很长很长很长很长很长很长很长很长"];
    
    //设置成喜欢的风格 一次设置永久生效 使用[DSLToastView reset];重置
//    [DSLToastView configureToastWithBlock:^(DSLToastView *sharedToast) {
//        sharedToast.backgroundColor = [UIColor orangeColor];
//        sharedToast.textColor = [UIColor whiteColor];
//        sharedToast.layer.cornerRadius = 20;
//        sharedToast.stayTime = 1.5;
//        sharedToast.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]}.mutableCopy;
//        sharedToast.topSpace = 100;
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)alert:(UIBarButtonItem *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否执行此操作？" delegate:self
                                          cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *text = @"";
    if (indexPath.row <= 2) {
        text = @"显示在中间";
    } else if (indexPath.row == 3) {
        text = @"延长显示时间2.5秒";
    } else if (indexPath.row > 3 && indexPath.row < 7) {
        text = @"显示在底部";
    } else {
        text = @"显示在顶部";
    }
    cell.textLabel.text = text;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row <= 2) {
        //显示在中间
        [DSLToastView toastWithText:_texts[indexPath.row]];
    } else if (indexPath.row == 3) {
        //延长显示时间，默认1秒
        [DSLToastView toastWithText:_texts[indexPath.row] stayTime:2.5];
    } else if (indexPath.row > 3 && indexPath.row < 7) {
        //显示在底部
        [DSLToastView toastWithText:_texts[indexPath.row] position:DSLToastViewPositionBottom];
    } else {
        //显示在顶部
        [DSLToastView toastWithText:[NSString stringWithFormat:@"hello %ld",(long)indexPath.row] position:DSLToastViewPositionTop];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //延迟显示
        [DSLToastView toastWithText:@"操作成功！" delay:0.7];
    }
}

@end
