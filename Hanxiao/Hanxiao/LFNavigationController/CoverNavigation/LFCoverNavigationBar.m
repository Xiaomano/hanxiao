//
//  LFCoverNavigationBar.m
//  LFNavigationController2
//
//  Created by 福有李 on 2017/11/22.
//  Copyright © 2017年 福有李. All rights reserved.
//

#import "LFCoverNavigationBar.h"
#import "UINavigationItem+AttributeExt.h"
#import "LFRuntime.h"
#import "UIImage+YYWebImage.h"


@interface LFCoverNavigationBar (){
    
    UIButton *_backBtn;
    UIButton *_transfromBtn;
    UIView *_backgroundView;
    UINavigationItem *_oldItem;
}

@property (nonatomic,readonly) UIButton *backBtn;
@property (nonatomic,readonly) UIButton *transfromBtn;
@property (nonatomic,readonly) UIView *backgroundView;
@end

@implementation LFCoverNavigationBar
//@synthesize back
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIView *)backgroundView{
    if (_backgroundView == nil) {
        @synchronized(self){
            [self _stepBackgroundView];
        }
    }
    return _backgroundView;
}

-(UIButton *)backBtn{
    if(_backBtn == nil){
        @synchronized(self){
            [self _stepBackBtn];
        }
    }
    return _backBtn;
}

-(UIButton *)transfromBtn{
    if(_transfromBtn == nil){
        @synchronized(self){
            [self _stepTransfromBtn];
        }
    }
    return _transfromBtn;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)backAction:(UIButton *)btn{
    
    UINavigationController *navigationController = [self targetForAction:@selector(popViewControllerAnimated:) withSender:self];
    
    [navigationController popViewControllerAnimated:YES];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:5];
//    _backBtn.backgroundColor = [UIColor redColor];
//    [UIView commitAnimations];
}
-(void)_stepBackBtn{
    [UINavigationBar appearance];
    _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _backBtn.opaque = YES;
    _backBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_backBtn setTitle:@"" forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_backBtn attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    _backBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 22, 5, 20);
    [self.animatedViews addObject:_backBtn];
}

-(void)_stepTransfromBtn{
    _transfromBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _transfromBtn.opaque = NO;
    _transfromBtn.translatesAutoresizingMaskIntoConstraints = NO;
    _transfromBtn.alpha = 0;
    [_transfromBtn setTitle:@"" forState:UIControlStateNormal];
    [_transfromBtn addTarget:self action:@selector(backAction:)
            forControlEvents:UIControlEventTouchUpInside];
    _transfromBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 22, 5, 20);
    [self addSubview:_transfromBtn];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_transfromBtn attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_transfromBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.animatedViews addObject:_transfromBtn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self sendSubviewToBack:_backgroundView];
}

-(void)_stepBackgroundView{
    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    _backgroundView.alpha = 1;
    [self insertSubview:_backgroundView atIndex:0];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundView)]];
    [_backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor constant:-[UIApplication sharedApplication].statusBarFrame.size.height].active = YES;
    [_backgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_backgroundView(==150)]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundView)]];
    [self.animatedViews addObject:_backgroundView];
    [self sendSubviewToBack:_backgroundView];
}

-(void)swap{
    UIButton *btn = _transfromBtn;
    _transfromBtn = _backBtn;
    _backBtn = btn;
}


-(void)lf_updateViews:(UINavigationItem *)item animated:(BOOL)animated{
    if (!item.navigationHidden) {
        [self lf_sync_item:item animated:animated];
    }
    
    //    [self.owner setNavigationBarHidden:item.navigationHidden animated:NO];
    _oldItem = item;
}

-(void)lf_willTransfrom:(UINavigationItem *)item animated:(BOOL)animated type:(LFNavigationControllerTransformType)tye{
    
    
}

//-(void)setHidden:(BOOL)hidden{
//    
//    NSLog(@"隐藏");
//    [super setHidden:hidden];
//}

-(void)lf_didTransfrom:(UINavigationItem *)item animated:(BOOL)animated type:(LFNavigationControllerTransformType)tye{
    
    BOOL isNabarTransfrom = [self isNavbarTransfrom:item];
    if (isNabarTransfrom) { //如果变换，直接把layer绘出来。然后调用系统的隐藏显示

//        self.hidden = item.navigationHidden;
        [self.owner setNavigationBarHidden:item.navigationHidden animated:animated];
        
        BOOL isNabarTransfrom = [self isNavbarTransfrom:item];
        
        if (isNabarTransfrom) {
            if (item.navigationHidden == NO && tye == LFNavigationControllerTransformTypePush) {
                [self lf_sync_item:item animated:NO];
            }
            if (item.navigationHidden == NO && tye == LFNavigationControllerTransformTypePop) {
                [self lf_sync_item:item animated:NO];
            }
        }
    }else{//自定义的动画
        [self lf_sync_item:item animated:animated];
    }
    
    
    
    _oldItem = item;
    
}

//-(void)lf_navigation_pop_item:(UINavigationItem *)item animated:(BOOL)animated{
//
//    BOOL isNabarTransfrom = [self isNavbarTransfrom:item];
//    if (isNabarTransfrom) { //如果变换，直接把layer绘出来。然后调用系统的隐藏显示
//        if (item.navigationHidden == NO) {
//            [self lf_sync_item:item animated:NO];
//        }
//
//        [self.owner setNavigationBarHidden:item.navigationHidden animated:animated];
//    }else{//自定义的动画
//        [self lf_sync_item:item animated:animated];
//    }
//
//    _oldItem = item;
//}
//
//-(void)lf_navigation_push_item:(UINavigationItem *)item animated:(BOOL)animated{
//
//    BOOL isNabarTransfrom = [self isNavbarTransfrom:item];
//    if (isNabarTransfrom) { //如果变换，直接把layer绘出来。然后调用系统的隐藏显示
//        if (item.navigationHidden == NO) {
//            [self lf_sync_item:item animated:NO];
//        }
//
//        [self.owner setNavigationBarHidden:item.navigationHidden animated:animated];
//    }else{//自定义的动画
//        [self lf_sync_item:item animated:animated];
//    }
//
//    _oldItem = item;
//
//}

-(BOOL)isNavbarTransfrom:(UINavigationItem *)item{
    if (_oldItem == nil) {
        return NO;
    }else{
        if (_oldItem.navigationHidden == item.navigationHidden) {
            return NO;
        }
        return YES;
    }
}


-(void)lf_sync_item:(UINavigationItem *)item animated:(BOOL)animated{
    
//    animated = NO;
    UIImage *image = item.backImage;
    if (item == self.owner.viewControllers.firstObject.navigationItem ||
        item.leftBarButtonItem != nil) {
        image = nil;
    }
    UIColor *tintColor = item.tintColor;
    if (tintColor == nil) {
        tintColor = [UIColor blueColor];
    }
    self.tintColor = tintColor;
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:tintColor}];

    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
    }

    ;
//    [self.transfromBtn setBackgroundColor:tintColor];
    
    if (image == nil) {
        self.transfromBtn.userInteractionEnabled = NO;
        self.backBtn.userInteractionEnabled = NO;
    }else{
        self.transfromBtn.userInteractionEnabled = YES;
        self.backBtn.userInteractionEnabled = YES;
    }

    [self.transfromBtn setImage:[image yy_imageByTintColor:tintColor] forState:UIControlStateNormal];
    [self.transfromBtn setImage:image forState:UIControlStateNormal];
    [self.transfromBtn setTintColor:tintColor];

    NSLog(@"animated = %@",animated?@"YES":@"NO");
    self.backBtn.alpha = 0.0f;
    NSLog(@"backBtn.alpha = %f",self.backBtn.alpha);
    self.transfromBtn.layer.opacity = 1.0f;
    NSLog(@"transfromBtn.alpha = %f",self.transfromBtn.alpha);
    [self swap];
    
    NSLog(@"backBtn.alpha = %f",self.backBtn.alpha);
    NSLog(@"transfromBtn.alpha = %f",self.transfromBtn.alpha);
    
    self.backgroundView.backgroundColor = item.backgroundColor;

    if (animated) {
        [UIView commitAnimations];
    }
}

@end
