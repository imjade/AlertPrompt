//
//  ViewController.m
//  AlertPrompt
//
//  Created by jadeYu on 14-9-26.
//  Copyright (c) 2014年 JadeYu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *btnPrompt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPrompt.frame = CGRectMake(100, 100, 100, 40);
    [btnPrompt setTitle:@"Prompt" forState:UIControlStateNormal];
    btnPrompt.backgroundColor = [UIColor orangeColor];
    [btnPrompt addTarget:self
                  action:@selector(btnPromptClick:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPrompt];
}
- (void)btnPromptClick:(id)sender
{
    BGAlertPrompt *loginPrompt = [[BGAlertPrompt alloc] initWithTitle:@"请输入密码" phoneNumber:@"" delegate:self cancelButtonTitle:@"关闭" otherButtonTitle:@"确定"];
    [loginPrompt show];
}

- (void)alertPrompt:(BGAlertPrompt *)alertPrompt clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"text_1:%@...text_2:%@",alertPrompt.plainTextField.text,alertPrompt.secretTextField.text);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
