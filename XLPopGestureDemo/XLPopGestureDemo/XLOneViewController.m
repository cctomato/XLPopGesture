//
//  XLOneViewController.m
//  XLPopGestureDemo
//
//  Created by cai cai on 2017/3/30.
//  Copyright © 2017年 cai cai. All rights reserved.
//

#import "XLOneViewController.h"
#import "UINavigationController+XLPopGesture.h"

@interface XLOneViewController ()

@end

@implementation XLOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    self.title = [NSString stringWithFormat:@"页面%ld", self.index];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)]];
}

- (void)clickTap
{
    XLOneViewController *vc = [[XLOneViewController alloc] init];
    vc.index = self.index + 1;
    [self.navigationController pushViewController:vc animated:YES];
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
