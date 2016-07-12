//
//  ViewController.m
//  DSLToastView
//
//  Created by 邓顺来 on 16/7/11.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "ViewController.h"
#import "DSLToastView.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *texts;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _texts = @[@"加载失败",@"信息错误\n请重新输入",@"很长很长很长很长很长很长很长很长很长很长很长很长",
               @"🐔🍗🍔",@"Hello",@"UITableViewDataSource\nUITableViewDelegate\nUIWebViewDelegate"];
    
    //设置成喜欢的风格
    [DSLToastView configureToastWithBlock:^(DSLToastView *sharedToast) {
        sharedToast.backgroundColor = [UIColor orangeColor];
        sharedToast.textColor = [UIColor whiteColor];
        sharedToast.layer.cornerRadius = 20;
        sharedToast.stayTime = 1.5;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
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
    if (indexPath.row <= 5) {
        [DSLToastView toastWithText:_texts[indexPath.row]];
    }
    if (indexPath.row == 6) {
        [DSLToastView toastWithAttributedText:[[NSAttributedString alloc] initWithString:@"属性串"
                                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                                           NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                           NSStrikethroughStyleAttributeName:@(1)}]];
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

@end
