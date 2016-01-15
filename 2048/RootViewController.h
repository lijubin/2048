//
//  RootViewController.h
//  2048
//
//  Created by 李居彬 on 15/6/16.
//  Copyright (c) 2015年 ljb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MainViewController.h"
#import "PassArgs.h"

@interface RootViewController : UIViewController<UIActionSheetDelegate>
{
    UIButton * inBtn;
    UIButton * outBtn;
    UIButton * replaceBtn;
    UIButton * soundBtn;
}
@property(strong,nonatomic) id<PassArgs> delegate;
@property(assign,nonatomic) int  SoundZT;

@end
