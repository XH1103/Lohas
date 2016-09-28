
//
//  IsLoginManager.m
//  LOHAS乐活_App
//
//  Created by mac51 on 9/19/16.
//  Copyright © 2016 Aaron. All rights reserved.
//

#import "IsLoginManager.h"

@implementation IsLoginManager

//获取单例类
+ (IsLoginManager *)shareManage{

    static IsLoginManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[super allocWithZone:nil] init];
        }
    });
    
    return manager;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareManage];
}
-(id)copy {
    return self;
}

-(NSString *)getUidFromNSHomeDirectory{
    //读取数据
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kLohasUidSave];
    //判断是否读取成功
    if (dic == nil) {
        //读取数据失败，没有登陆
        return nil;
    }
    NSString *uid = dic[@"uid"];
    if (uid == nil) {
        //保存的数据有误 重新登陆
        return nil;
    }
    
    return uid;

}

-(NSString *)getUseIDFromNSHomeDirectory{
    
    //读取数据
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kLohasUseIDSave];
    //判断是否读取成功
    if (dic == nil) {
        //读取数据失败，没有登陆
        return nil;
    }
    NSString *useID = dic[@"useID"];
    if (useID == nil) {
        //保存的数据有误 重新登陆
        return nil;
    }
    
    return useID;
    
}
-(NSString *)getTokenFromNSHomeDirectory{
    //读取数据
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kLohasTokenSave];
    //判断是否读取成功
    if (dic == nil) {
        //读取数据失败，没有登陆
        return nil;
    }
    NSString *token = dic[@"token"];
    if (token == nil) {
        //保存的数据有误 重新登陆
        return nil;
    }
    
    return token;
    
}
-(BOOL)judgeNeedsPush:(UIViewController *)vc{
   
    NSString *uid = [[IsLoginManager shareManage]getUidFromNSHomeDirectory];
    
    if (uid == nil) {
        LoginViewController *login = [[LoginViewController alloc]init];
        login.title = @"登录";
        login.hidesBottomBarWhenPushed = YES;
        login.navigationItem.hidesBackButton = YES;
        [vc.navigationController pushViewController:login animated:YES];
        return NO;
    }
    return YES;
}

-(void)clearLoginInfo {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLohasUidSave];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLohasUseIDSave];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLohasTokenSave];
}

@end
