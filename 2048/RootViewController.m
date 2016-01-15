//
//  RootViewController.m
//  2048
//
//  Created by 李居彬 on 15/6/16.
//  Copyright (c) 2015年 ljb. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize delegate,SoundZT;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:240/255.0 alpha:1.0f];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    NSMutableArray *numbers = [[NSMutableArray alloc]init];
    NSMutableDictionary * DataDict = [[NSMutableDictionary alloc]init];
    SoundZT = 1;
    if (udf) {
        DataDict = [udf objectForKey:@"DataDict"];
        if (DataDict == nil) {
            DataDict = [[NSMutableDictionary alloc]init];
        } else{
            numbers = [DataDict objectForKey:@"numbers"];
            SoundZT = [[numbers objectAtIndex:2] intValue];
        }
    }
    inBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    inBtn.frame=CGRectMake(320/2-(WIDTH*2)/2,80, WIDTH*2, WIDTH);
    [inBtn setTitle:@"重新开始" forState:UIControlStateNormal];
    inBtn.backgroundColor = [UIColor orangeColor];
    inBtn.layer.cornerRadius = 10.0;
    inBtn.layer.masksToBounds = YES;
    inBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [inBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [inBtn addTarget:self action:@selector(inBtnFunction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inBtn];
    
    outBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    outBtn.frame=CGRectMake(320/2-(WIDTH*2)/2,WIDTH+90, WIDTH*2, WIDTH);
    [outBtn setTitle:@"继续" forState:UIControlStateNormal];
    outBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    outBtn.layer.cornerRadius = 10.0;
    outBtn.layer.masksToBounds = YES;
    outBtn.backgroundColor = [UIColor orangeColor];
    [outBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [outBtn addTarget:self action:@selector(outBtnFunction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outBtn];

    replaceBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    replaceBtn.frame=CGRectMake(320/2-(WIDTH*2)/2,2*WIDTH+100, WIDTH*2, WIDTH);
    [replaceBtn setTitle:@"重置" forState:UIControlStateNormal];
    replaceBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    replaceBtn.layer.cornerRadius = 10.0;
    replaceBtn.layer.masksToBounds = YES;
    replaceBtn.backgroundColor = [UIColor orangeColor];
    [replaceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [replaceBtn addTarget:self action:@selector(plBtnFunction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:replaceBtn];
    
    soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    soundBtn.frame = CGRectMake(240, 30, 60, 40);
    [soundBtn addTarget:self action:@selector(soundTap) forControlEvents:UIControlEventTouchUpInside];
    if (SoundZT) {
        [soundBtn setImage:[UIImage imageNamed:@"super.png"] forState:UIControlStateNormal];
    }else{
        [soundBtn setImage:[UIImage imageNamed:@"silent.png"] forState:UIControlStateNormal];
    }
    [self.view addSubview:soundBtn];
    //显示菜单
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)inBtnFunction
{
    if (SoundZT) {
        [self playSound];
    }
    [self.delegate setArgs:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController pushViewController:mainVC animated:YES];
}

-(void)outBtnFunction
{
    if (SoundZT) {
        [self playSound];
    }
    [self.delegate setArgs:0];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)plBtnFunction
{
    if (SoundZT) {
        [self playSound];
    }
    UIActionSheet * actionSheet =[[UIActionSheet alloc]initWithTitle:@"重置会清除历史最高分和排行榜纪录等，将恢复到初始状态,确定重置吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"重置" otherButtonTitles:@"", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.delegate setArgs:2];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

-(void)soundTap
{
    if (SoundZT) {
        [self playSound];
        SoundZT = 0;
        [soundBtn setImage:[UIImage imageNamed:@"silent.png"] forState:UIControlStateNormal];
    }else{
        SoundZT = 1;
        [soundBtn setImage:[UIImage imageNamed:@"super.png"] forState:UIControlStateNormal];
    }
    [self.delegate setArgs:3];
}

-(void)playSound
{
    SystemSoundID pmph;
    NSURL *tapSound = [[NSBundle mainBundle] URLForResource:@"music.wav" withExtension:nil];
    
    CFURLRef baseURL = (__bridge CFURLRef)tapSound;
    AudioServicesCreateSystemSoundID(baseURL, &pmph);
    AudioServicesPlaySystemSound(pmph);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
