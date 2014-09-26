//
//  BGAlertPrompt.h
//  NewBaoGu
//
//  Created by iMac - UserDefault on 13-9-27.
//  Copyright (c) 2013年 xiaokang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BGAlertPrompt;
@protocol BGAlertPromptDelegate <NSObject>

- (void)alertPrompt:(BGAlertPrompt *)alertPrompt clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
@interface BGAlertPrompt : UIView <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    
    UITextField *_currentxtFiled;
    UITextField *plainTextField_;
	UITextField *secretTextField_;
    id<BGAlertPromptDelegate> _delegate;
    UIView *_bgView;
    
}
@property (nonatomic,assign) id<BGAlertPromptDelegate> delegate;
@property (nonatomic,strong) UITableView *mianTab;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *phoneLab;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *submitBtn;
@property(nonatomic, strong, readonly) UITextField *plainTextField;
@property(nonatomic, strong, readonly) UITextField *secretTextField;
@property (nonatomic,copy) NSString *phoneNumber;
- (id)initWithTitle:(NSString *)title phoneNumber:(NSString *)telphoneNumber delegate:(id<BGAlertPromptDelegate>)promptDelegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitles;
-(void)show;

@end

