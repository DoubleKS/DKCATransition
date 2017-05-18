//
//  AVViewController.m
//  转场动画
//
//  Created by doublek on 2017/5/13.
//  Copyright © 2017年 doublek. All rights reserved.
//

#import "AVViewController.h"
#import "DKCATransition.h"
@interface AVViewController ()

@property(nonatomic,strong)DKCATransition *transition;

@end

@implementation AVViewController

-(void)awakeFromNib{
    
    [super awakeFromNib];
    //设置转场样式为自定义
    self.modalPresentationStyle = UIModalPresentationCustom;
    //设置转场代理
    self.transition = [[DKCATransition alloc]init];
    self.transitioningDelegate = self.transition;
}




- (void)viewDidLoad {
    [super viewDidLoad];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
