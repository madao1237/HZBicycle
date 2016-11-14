//
//  HBSearchBar.m
//  HZBicycle
//
//  Created by MADAO on 16/11/14.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "HBSearchBar.h"

@interface HBSearchBar()<UITextFieldDelegate> {
    struct{
        unsigned int didBeginEdit : 1;
        unsigned int didEditChanged : 1;
        unsigned int didEditEnded : 1;
    }_delegateFlag;
}
#pragma mark - Subviews

/**
 搜索栏图标
 */
@property (nonatomic, strong) UIImageView *iconView;

/**
 搜索输入框
 */
@property (nonatomic, strong) UITextField *searchTextField;

@end

#pragma mark - Constant
static CGFloat const kInsetsNormal = 10.f;
static CGFloat const kWidthIconView = 30.f;
static NSString *const kPlaceholderSearch = @"请输入地址或编号";

@implementation HBSearchBar

#pragma mark - Init
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        //设置阴影
        self.layer.cornerRadius = 5.f;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    //设置子视图
    @WEAKSELF;
    self.iconView = [[UIImageView alloc] init];
    self.iconView.image = ImageInName(@"main_search");
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf).with.offset(kInsetsNormal);
        make.height.width.mas_equalTo(@(kWidthIconView));
    }];
    
    //设置输入框
    self.searchTextField = [[UITextField alloc] init];
    self.searchTextField.delegate = self;
    self.searchTextField.placeholder = kPlaceholderSearch;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.tintColor = HB_COLOR_DARKBLUE;
    [self addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconView.mas_right).with.offset(kInsetsNormal);
        make.top.equalTo(weakSelf.mas_top).with.offset(kInsetsNormal);
        make.height.mas_equalTo(@(kWidthIconView));
        make.right.equalTo(weakSelf.mas_right).with.offset(-kInsetsNormal);
    }];
    //添加输入框动作
    [self.searchTextField addTarget:self action:@selector(handleEditingChanged:) forControlEvents:UIControlEventEditingChanged];

}

#pragma mark - LifeCycle
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.8;
}

#pragma mark - Setter
- (void)setDelegate:(id<HBSearchBarDelegete>)delegate {
    _delegate = delegate;
    if ([_delegate respondsToSelector:@selector(searchBarDidBeginEdit:)]) {
        _delegateFlag.didBeginEdit = YES;
    }
    if ([_delegate respondsToSelector:@selector(searchBar:textDidChanged:)]) {
        _delegateFlag.didEditChanged = YES;
    }
    if ([_delegate respondsToSelector:@selector(searchBar:didFinishEdit:)]) {
        _delegateFlag.didEditEnded = YES;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_delegateFlag.didBeginEdit) {
        [_delegate searchBarDidBeginEdit:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_delegateFlag.didEditEnded) {
        [_delegate searchBar:self didFinishEdit:textField.text];
    }
}

- (void)handleEditingChanged:(UITextField *)sender {
    if (_delegateFlag.didEditChanged) {
        [_delegate searchBar:self textDidChanged:sender.text];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
