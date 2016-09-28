//
//  SendViewController.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/21/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "SendViewController.h"

@interface SendViewController (){
    UITextView *_textView;
}
@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 0.95;
    [self createBarItem];
    [self createUI];
}
-(void)createBarItem {
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 40, 30);
    [button1 setTitleColor:reddishBlueColor forState:UIControlStateNormal];
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button1.tag = 0;
    [button1 addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = item1;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 40, 30);
    [button2 setTitleColor:reddishBlueColor forState:UIControlStateNormal];
    [button2 setTitle:@"完成" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button2.tag = 1;
    [button2 addTarget:self action:@selector(barItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = item2;
    
}
-(void)barItemAction:(UIButton *)button{
    if (button.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (button.tag == 1){
        if (_textView.text.length) {
            NSString *token = [[IsLoginManager shareManage]getTokenFromNSHomeDirectory];
            NSString *urlString = [NSString stringWithFormat:@"http://api.ilohas.com/v2/club/add_note?token=%@&content=%@",token,_textView.text];
            //获取管理对象
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            //发起GET请求
            [manager GET:urlString
              parameters:nil
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSData *data = (NSData *)responseObject;
                     NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                     NSInteger status= [content[@"status"] integerValue];
                     if (status == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"请求失败");
                 }];
        }
    }
}
-(void)createUI {
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    _textView.backgroundColor = [UIColor yellowColor];
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:_textView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 320, 80, 80)];
    img.image = [UIImage imageNamed:@"btnaddpic@3x.png"];
    img.userInteractionEnabled = YES;
    img.layer.borderWidth = 1;
    img.layer.borderColor = [UIColor grayColor].CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [img addGestureRecognizer:tap];
    [self.view addSubview:img];
    
    UIView *img1 = [[UIView alloc] initWithFrame:CGRectMake(0, 410, kScreenWidth, 50)];
    img1.userInteractionEnabled = YES;
    img1.layer.borderWidth = 2;
    img1.layer.borderColor = [UIColor grayColor].CGColor;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1:)];
    [img1 addGestureRecognizer:tap1];
    UIImageView *location = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    location.image = [UIImage imageNamed:@"icop@3x.png"];
    location.userInteractionEnabled = YES;
    [img1 addSubview:location];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 100, 20)];
    l.textColor = [UIColor blackColor];
    l.text = @"所在位置";
    [img1 addSubview:l];
    [self.view addSubview:img1];

}
-(void)tapAction:(UITapGestureRecognizer *)tap{


}
-(void)tapAction1:(UITapGestureRecognizer *)tap{
    
    
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
