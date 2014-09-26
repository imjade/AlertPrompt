//
//  BGAlertPrompt.m
//  NewBaoGu
//
//  Created by iMac - UserDefault on 13-9-27.
//  Copyright (c) 2013年 xiaokang. All rights reserved.
//

#import "BGAlertPrompt.h"
#define leftSpace 20.0f
#define itemWidth 280.0f
#define itemHight 196.0f

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface BGAlertPrompt ()
@property(nonatomic, strong) UITextField *plainTextField;
@property(nonatomic, strong) UITextField *secretTextField;
@end

@implementation BGAlertPrompt
@synthesize mianTab = _mianTab;
@synthesize titleLab = _titleLab;
@synthesize phoneLab = _phoneLab;
@synthesize cancelBtn = _cancelBtn;
@synthesize submitBtn = _submitBtn;
@synthesize plainTextField = plainTextField_;
@synthesize secretTextField = secretTextField_;
@synthesize delegate;
@synthesize phoneNumber;
-(void)dealloc {
    _titleLab = nil;
    _phoneLab = nil;
    phoneNumber = nil;
    _mianTab = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_currentxtFiled resignFirstResponder];
}

- (id)initWithTitle:(NSString *)title phoneNumber:(NSString *)telphoneNumber delegate:(id<BGAlertPromptDelegate>)promptDelegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitles {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xe0e4e4);
        self.delegate = promptDelegate;
        self.phoneNumber = telphoneNumber;
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        _bgView = [self returnView];
        [window addSubview:_bgView];
        self.frame = CGRectMake(0, 0, itemWidth, itemHight);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7.f;
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 30)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.text = title;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont boldSystemFontOfSize:16.f];
        [self addSubview:_titleLab];
        
        _phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLab.frame.origin.y + _titleLab.frame.size.height, self.frame.size.width, 30)];
        _phoneLab.textAlignment = NSTextAlignmentCenter;
        _phoneLab.font = [UIFont systemFontOfSize:12.f];
        _phoneLab.backgroundColor = [UIColor clearColor];
        _phoneLab.textColor = [UIColor blackColor];
        _phoneLab.text = telphoneNumber;
        [self addSubview:_phoneLab];
        _mianTab = [[UITableView alloc] initWithFrame:CGRectMake(12.0f, _phoneLab.frame.origin.y +_phoneLab.frame.size.height +5, 260.f, 80.f)];
        _mianTab.delegate = self;
        _mianTab.dataSource = self;
        _mianTab.scrollEnabled = NO;
        _mianTab.backgroundColor = [UIColor clearColor];
        _mianTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_mianTab];
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(_mianTab.frame.origin.x, _mianTab.frame.origin.y + _mianTab.frame.size.height - 15, 260.f/2, 44);
        _cancelBtn.tag = 0;
        [_cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
        
        _submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _submitBtn.frame = CGRectMake(_cancelBtn.frame.origin.x + _cancelBtn.frame.size.width, _mianTab.frame.origin.y + _mianTab.frame.size.height - 15, 260.f/2, 44);
        _submitBtn.tag = 1;
        [_submitBtn setTitle:otherButtonTitles forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_submitBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiddenNotify:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)layoutSubviews {
	// We assume keyboard is on.
//    self.center = CGPointMake(160.0f, (460.0f - itemHight)/2 + 12.0f);
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self.center = window.center;
    self.titleLab.frame = CGRectMake(0, 20, self.frame.size.width, 20);
    self.phoneLab.frame = CGRectMake(0, self.titleLab.frame.origin.y + self.titleLab.frame.size.height, self.frame.size.width, 20);
    self.mianTab.frame = CGRectMake(12.0f, self.phoneLab.frame.origin.y +self.phoneLab.frame.size.height +5, 260.f, 88);
}

-(UIView *)returnView {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *cView = [[UIView alloc] initWithFrame:window.bounds];
    cView.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.5];
    cView.alpha = .3f;
    cView.userInteractionEnabled = YES;
    
    return cView;
}
-(void)show {
//    self.center =
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    self.center = window.center;
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = .6;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.delegate = self;
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
    
}
-(void)hidden {
    [_currentxtFiled resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_bgView removeFromSuperview];
    }];
//    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    hideAnimation.duration = 0.4;
//    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
//                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
//                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
//    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
//    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    hideAnimation.delegate = self;
//    [self.layer addAnimation:hideAnimation forKey:nil];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [plainTextField_ becomeFirstResponder];
}
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44.f;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *AlertPromptCellIdentifier = @"AlertPromptCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:AlertPromptCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AlertPromptCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView  *upView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 43.0f)];
//        upView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Accountxt_up.png"]];
        upView.tag = 3333;
        upView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:upView];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f,upView.frame.origin.y +upView.frame.size.height, upView.frame.size.width, 1.f)];
        line.backgroundColor = UIColorFromRGB(0xdee8ef);
        [upView addSubview:line];
        
//        UIView  *downView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 46.0f)];
//        downView.tag = 4444;
//        downView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Accountxt_down.png"]];
//        downView.backgroundColor = [UIColor clearColor];
//        [cell.contentView addSubview:downView];
//        [downView release];
    }
	
//	if (![cell.contentView.subviews count]) {
		if (indexPath.row) {
            if (!secretTextField_) {
                [cell.contentView addSubview:self.secretTextField];
            }
		} else {
            if (!plainTextField_) {
                [cell.contentView addSubview:self.plainTextField];
            }
			
		}
//	}
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}
- (UITextField *)plainTextField {
    
	if (!plainTextField_) {
		plainTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 38.0f)];
        plainTextField_.borderStyle = UITextBorderStyleNone;
		plainTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        plainTextField_.secureTextEntry = YES;
        plainTextField_.delegate = self;
        plainTextField_.backgroundColor = [UIColor clearColor];
		plainTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
		plainTextField_.placeholder = @"输入密码";
	}
	return plainTextField_;
}

- (UITextField *)secretTextField {
	
	if (!secretTextField_) {
		secretTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 38.0f)];
		secretTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		secretTextField_.secureTextEntry = YES;
        secretTextField_.borderStyle = UITextBorderStyleNone;
        secretTextField_.delegate = self;
        secretTextField_.backgroundColor = [UIColor clearColor];
		secretTextField_.clearButtonMode = UITextFieldViewModeWhileEditing;
		secretTextField_.placeholder = @"确认密码";
	}
	return secretTextField_;
}

#pragma mark - BGAlertPromptDelegate
-(void)btnClick:(UIButton *)sender {
    
    [self hidden];
    if ([self.delegate respondsToSelector:@selector(alertPrompt:clickedButtonAtIndex:)]) {
        [self.delegate alertPrompt:self clickedButtonAtIndex:sender.tag];
    }
    
}
#pragma mark -=====> keyboardShowNotify ====>
-(void)keyboardShowNotify:(NSNotification*)aNotification{
    
    double duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.frame;
                         frame.origin.y -= 50;
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];

}
-(void)keyboardWillHiddenNotify:(NSNotification *)aNotification {
    double duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.frame;
                         frame.origin.y +=  50;
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _currentxtFiled = textField;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
    [textField resignFirstResponder];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
