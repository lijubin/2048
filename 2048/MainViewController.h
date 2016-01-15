//
//  MainViewController.h
//  2048
//
//  Created by 李居彬 on 15/6/17.
//  Copyright (c) 2015年 ljb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "RootViewController.h"
#import "ScoreViewController.h"
#import "PassArgs.h"

#define padding 10
#define WIDTH ([UIScreen mainScreen].bounds.size.width-5*padding)/4
#define X1 4
#define Y1 4
@interface MainViewController : UIViewController<UIAlertViewDelegate,PassArgs>
{
    UILabel *lab0_0;
    UILabel *lab0_1;
    UILabel *lab0_2;
    UILabel *lab0_3;
    UILabel *lab1_0;
    UILabel *lab1_1;
    UILabel *lab1_2;
    UILabel *lab1_3;
    UILabel *lab2_0;
    UILabel *lab2_1;
    UILabel *lab2_2;
    UILabel *lab2_3;
    UILabel *lab3_0;
    UILabel *lab3_1;
    UILabel *lab3_2;
    UILabel *lab3_3;
}

@property(assign,nonatomic) int args;

-(void)setLabValue:(UILabel *)_label;
-(int)geti:(int)i j:(int)j;
-(void)seti:(int)i j:(int)j v:(int)value;
-(int)randNum:(int)index;
-(void)setbackColorv:(int)value label:(UILabel *)label;
-(int) isEnd;
-(void)setArgs:(int)_args;

@end
