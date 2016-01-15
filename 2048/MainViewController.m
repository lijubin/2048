//
//  MainViewController.m
//  2048
//
//  Created by 李居彬 on 15/6/17.
//  Copyright (c) 2015年 ljb. All rights reserved.
//

#import "MainViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MainViewController ()
@property(nonatomic,weak)UILabel *labMax;
@property(nonatomic,weak)UILabel *labScore;
@property(nonatomic,weak)UILabel *labHisScore;
@property(nonatomic,weak)UIButton * menu;
@property(strong,nonatomic)NSMutableDictionary *dict;//颜色字典
@property(strong,nonatomic)NSArray *twoFour;//2和4随机数组
@property(strong,nonatomic)NSMutableArray *SwipeArray;//手势过滤数组
@property(strong,nonatomic)NSMutableArray *numbers;//历史最高分数组
@property(strong,nonatomic)NSMutableArray *ScoresArray;//排行榜记录
@property(strong,nonatomic)NSMutableArray *dateArrary;//日期纪录
@property(strong,nonatomic)NSMutableDictionary *DataDict;//存储纪录

@property(assign,nonatomic)int maxNum;
@property(assign,nonatomic)int maxNum1;//最大值
@property(assign,nonatomic)int score;//当前得分
@property(assign,nonatomic)int hisScore;
@property(assign,nonatomic)int hisScore1;//历史最高分
@property(assign,nonatomic)int lastHisScore;//最后一次历史纪录
@property(assign,nonatomic)int SoundZT;//声音状态
//@property(strong,nonatomic) NSUserDefaults *udf;
@end

@implementation MainViewController
@synthesize args;

#pragma mark 控件初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:240/255.0 alpha:1.0f];
    //读取缓存
    [self getCaches];
    //设置按钮布局
    [self setUpMaxLab];
    //设置滑块按钮布局
    [self setUpMoreLab];
    //设置轻扫手势
    [self setSwipeGesture];
}

#pragma mark - 读取缓存数据
- (void)getCaches {
    self.maxNum = 0;
    self.maxNum1 = 0;//最大值
    self.score = 0;//当前得分
    self.hisScore = 0;
    self.hisScore1 = 0;//历史最高分
    self.SoundZT = 1;
    self.twoFour = [NSArray arrayWithObjects:@"2",@"2",@"4",@"2",@"2",@"4",@"2",@"2",@"2",@"2", nil];
    //获取数据
    self.numbers = [[NSMutableArray alloc]init];
    self.ScoresArray = [[NSMutableArray alloc]init];
    self.dateArrary = [[NSMutableArray alloc]init];
    if (args == 2) {//重置
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DataDict"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"DataDict"];
    if (dict == nil) {
        self.DataDict = [NSMutableDictionary dictionary];
    } else {
        self.DataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        self.numbers = [self.DataDict objectForKey:@"numbers"];
        NSLog(@"%@",self.numbers);
        self.ScoresArray = [self.DataDict objectForKey:@"ScoresArray"];
        self.dateArrary = [self.DataDict objectForKey:@"dateArrary"];
        self.maxNum = [[self.numbers objectAtIndex:0] intValue];
        self.maxNum1 = [[self.numbers objectAtIndex:0] intValue];
        self.hisScore = [[self.numbers objectAtIndex:1] intValue];
        self.hisScore1 = [[self.numbers objectAtIndex:1] intValue];
        self.SoundZT = [[self.numbers objectAtIndex:2] intValue];
    }
}

#pragma mark - 排行榜 积分 按钮设置
- (void)setUpMaxLab {
    UILabel *labMax = [[UILabel alloc]init];
    self.labMax = labMax;
    UILabel *labScore = [[UILabel alloc]init];
    self.labScore = labScore;
    UILabel *labHisScore = [[UILabel alloc]init];
    self.labHisScore = labHisScore;
    CGFloat labMaxX = padding;
    CGFloat labMaxY = 25;
    CGFloat labMaxW = WIDTH+padding;
    CGFloat labMaxH = WIDTH+padding;
    labMax.frame=CGRectMake(labMaxX,labMaxY, labMaxW, labMaxH);
    CGFloat labScoreX = CGRectGetMaxX(labMax.frame)+padding;
    CGFloat labScoreY = labMaxY;
    CGFloat labScoreW = ([UIScreen mainScreen].bounds.size.width - labScoreX - 2*padding) * 0.5;
    CGFloat labScoreH = labMaxH * 0.7;
    labScore.frame=CGRectMake(labScoreX,labScoreY,labScoreW,labScoreH);
    CGFloat labHisScoreX = CGRectGetMaxX(labScore.frame)+padding;
    CGFloat labHisScoreY = labMaxY;
    CGFloat labHisScoreW = labScoreW;
    CGFloat labHisScoreH = labScoreH;
    labHisScore.frame=CGRectMake(labHisScoreX,labHisScoreY, labHisScoreW, labHisScoreH);
    labMax.backgroundColor = [UIColor yellowColor];
    labScore.backgroundColor = [UIColor blackColor];
    labHisScore.backgroundColor = [UIColor blackColor];
    labMax.textColor = [UIColor blackColor];
    labScore.textColor = [UIColor whiteColor];
    labHisScore.textColor = [UIColor whiteColor];
    labMax.font = [UIFont systemFontOfSize:30];
    labScore.font = [UIFont systemFontOfSize:20];
    labMax.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    labScore.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    labHisScore.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    labMax.layer.cornerRadius = 10.0f;
    labMax.layer.masksToBounds = YES;
    labScore.layer.cornerRadius = 10.0;
    labScore.layer.masksToBounds = YES;
    labHisScore.layer.cornerRadius = 10.0;
    labHisScore.layer.masksToBounds = YES;
    labMax.adjustsFontSizeToFitWidth = YES;//自动适应大小
    labScore.adjustsFontSizeToFitWidth = YES;
    labHisScore.adjustsFontSizeToFitWidth = YES;
    //自动折行设置
    labScore.numberOfLines = 0;
    labHisScore.numberOfLines = 0;
    labHisScore.font = [UIFont systemFontOfSize:15];
    labMax.textAlignment = NSTextAlignmentCenter;
    labScore.textAlignment = NSTextAlignmentCenter;
    labHisScore.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labMax];
    [self.view addSubview:labScore];
    [self.view addSubview:labHisScore];
    UIButton * menu=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.menu = menu;
    [menu setTitle:@"菜单" forState:UIControlStateNormal];
    CGFloat menuX = labScore.frame.origin.x;
    CGFloat menuY = CGRectGetMaxY(labScore.frame) + 1;
    CGFloat menuW = WIDTH;
    CGFloat menuH = WIDTH * 0.7;
    menu.frame=CGRectMake(menuX,menuY, menuW, menuH);
    menu.backgroundColor = [UIColor orangeColor];
    menu.layer.cornerRadius = 10.0;
    menu.layer.masksToBounds = YES;
    [menu setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    menu.titleLabel.font = [UIFont systemFontOfSize:20];
    [menu addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menu];
    
    UIButton * charts=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [charts setTitle:@"排行榜" forState:UIControlStateNormal];
    CGFloat chartsX = CGRectGetMaxX(menu.frame) + 2 * padding;
    CGFloat chartsY = menuY;
    CGFloat chartsW = WIDTH;
    CGFloat chartsH = menuH;
    charts.frame=CGRectMake(chartsX,chartsY,chartsW,chartsH);
    charts.backgroundColor = [UIColor orangeColor];
    charts.layer.cornerRadius = 10.0;
    charts.layer.masksToBounds = YES;
    [charts setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    charts.titleLabel.font = [UIFont systemFontOfSize:20];
    [charts addTarget:self action:@selector(phb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:charts];
}

#pragma mark - 设置滑块按钮布局
- (void)setUpMoreLab {
    //设置滑块颜色
    self.dict = [[NSMutableDictionary alloc]init];
    [self.dict setObject:[UIColor lightGrayColor] forKey:@"0"];
    [self.dict setObject:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0f] forKey:@"2"];
    [self.dict setObject:[UIColor colorWithRed:233/255.0 green:215/255.0 blue:202/255.0 alpha:1.0f] forKey:@"4"];
    [self.dict setObject:[UIColor colorWithRed:190/255.0 green:107/255.0 blue:54/255.0 alpha:1.0f] forKey:@"8"];
    [self.dict setObject:[UIColor brownColor] forKey:@"16"];
    [self.dict setObject:[UIColor colorWithRed:168/255.0 green:229/255.0 blue:133/255.0 alpha:1.0f] forKey:@"32"];
    [self.dict setObject:[UIColor colorWithRed:148/255.0 green:206/255.0 blue:229/255.0 alpha:1.0f] forKey:@"64"];
    [self.dict setObject:[UIColor colorWithRed:205/255.0 green:130/255.0 blue:227/255.0 alpha:1.0f] forKey:@"128"];
    [self.dict setObject:[UIColor colorWithRed:209/255.0 green:36/255.0 blue:148/255.0 alpha:1.0f] forKey:@"256"];
    [self.dict setObject:[UIColor colorWithRed:76/255.0 green:127/255.0 blue:235/255.0 alpha:1.0f] forKey:@"512"];
    [self.dict setObject:[UIColor colorWithRed:239/255.0 green:216/255.0 blue:71/255.0 alpha:1.0f] forKey:@"1024"];
    [self.dict setObject:[UIColor orangeColor] forKey:@"2048"];
    [self.dict setObject:[UIColor redColor] forKey:@"4096"];
    [self.dict setObject:[UIColor magentaColor] forKey:@"8192"];
    //生成滑块
    [self setLabValue:lab0_0 = [[UILabel alloc]init]];
    [self setLabValue:lab0_1 = [[UILabel alloc]init]];
    [self setLabValue:lab0_2 = [[UILabel alloc]init]];
    [self setLabValue:lab0_3 = [[UILabel alloc]init]];
    [self setLabValue:lab1_0 = [[UILabel alloc]init]];
    [self setLabValue:lab1_1 = [[UILabel alloc]init]];
    [self setLabValue:lab1_2 = [[UILabel alloc]init]];
    [self setLabValue:lab1_3 = [[UILabel alloc]init]];
    [self setLabValue:lab2_0 = [[UILabel alloc]init]];
    [self setLabValue:lab2_1 = [[UILabel alloc]init]];
    [self setLabValue:lab2_2 = [[UILabel alloc]init]];
    [self setLabValue:lab2_3 = [[UILabel alloc]init]];
    [self setLabValue:lab3_0 = [[UILabel alloc]init]];
    [self setLabValue:lab3_1 = [[UILabel alloc]init]];
    [self setLabValue:lab3_2 = [[UILabel alloc]init]];
    [self setLabValue:lab3_3 = [[UILabel alloc]init]];
    //给滑块设置随机数
    [self randNum:1];
    [self randNum:1];
}

#pragma mark - label初始化
-(void)setLabValue:(UILabel *)_label
{
    static int i = 0;
    static int j = -1;
    j++;
    if (j == 4) {
        i++;
        j = 0;
    }
    CGFloat labelX = (WIDTH*j)+padding*(j+1);
    CGFloat labelY = (CGRectGetMaxY(self.menu.frame)+2*padding)+(WIDTH+padding)*i;
    CGFloat labelW = WIDTH;
    CGFloat labelH = WIDTH;
    _label.frame=CGRectMake(labelX,labelY, labelW, labelH);
    _label.backgroundColor = [UIColor lightGrayColor];
    _label.textColor = [UIColor blackColor];
    _label.font = [UIFont systemFontOfSize:30];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _label.layer.cornerRadius = 10.0;
    _label.layer.masksToBounds = YES;
    _label.adjustsFontSizeToFitWidth = YES;
    
    [self.view addSubview:_label];
    if (i == 3 && j == 3) {
        i = 0;
        j = -1;
    }
}

#pragma mark - 设置手势
- (void)setSwipeGesture {
    UISwipeGestureRecognizer * recoginzer;
    recoginzer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recoginzer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:recoginzer];
    recoginzer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recoginzer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:recoginzer];
    recoginzer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recoginzer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:recoginzer];
    recoginzer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recoginzer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:recoginzer];
}

#pragma mark - button按钮功能
-(void)btn
{
    if (self.SoundZT) {
        [self playSound];
    }
    
    RootViewController * rootVC = [[RootViewController alloc]init];
    rootVC.title = @"菜单";
    rootVC.delegate = self;
    rootVC.SoundZT = self.SoundZT;
    [self.navigationController pushViewController:rootVC animated:YES];
}

#pragma mark - 排行榜
-(void)phb
{
    if (self.SoundZT) {
        [self playSound];
    }
    ScoreViewController * scoreVC = [[ScoreViewController alloc]init];
    scoreVC.title = @"排行榜";
    scoreVC.array = self.ScoresArray;
    scoreVC.dateArray = self.dateArrary;
    [self.navigationController pushViewController:scoreVC animated:YES];
}

#pragma mark - 排行榜排序
-(void)SortScores
{
    //日期处理
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * today = [dateFormatter stringFromDate:date];
    
    NSString * temp = [[NSString alloc]init];
    if (self.ScoresArray == nil) {
        self.ScoresArray = [[NSMutableArray alloc]init];
        self.dateArrary = [[NSMutableArray alloc]init];
    }
    if ([self.ScoresArray count] < 10) {
        [self.ScoresArray addObject:[NSString stringWithFormat:@"%d",self.score]];
        [self.dateArrary addObject:today];
    }else {
        for (int i = 0; i < [self.ScoresArray count] - 1; i++) {
            for (int j = i+1; j < [self.ScoresArray count]; j++) {
                if ([[self.ScoresArray objectAtIndex:i] intValue] > [[self.ScoresArray objectAtIndex:j] intValue]) {
                    temp = [self.ScoresArray objectAtIndex:i];
                    [self.ScoresArray replaceObjectAtIndex:i withObject:[self.ScoresArray objectAtIndex:j]];
                    [self.ScoresArray replaceObjectAtIndex:j withObject:temp];
                    
                    temp = [self.dateArrary objectAtIndex:i];
                    [self.dateArrary replaceObjectAtIndex:i withObject:[self.dateArrary objectAtIndex:j]];
                    [self.dateArrary replaceObjectAtIndex:j withObject:temp];
                }
            }
        }
        if (self.score > [[self.ScoresArray objectAtIndex:0] intValue]) {
            [self.ScoresArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",self.score]];
            [self.dateArrary replaceObjectAtIndex:0 withObject:today];
        }
    }
}

#pragma mark - label的get和set //获取label值
-(int)geti:(int)i j:(int)j
{
    int value = 0;
    UILabel * label;
    if (i == 0) {
        if (j == 0) {
            label = lab0_0;
        }else if(j == 1) {
            label = lab0_1;
        }else if(j == 2) {
            label = lab0_2;
        }else if(j == 3) {
            label = lab0_3;
        }
    }else if(i == 1) {
        if (j == 0) {
            label = lab1_0;
        }else if(j == 1) {
            label = lab1_1;
        }else if(j == 2) {
            label = lab1_2;
        }else if(j == 3) {
            label = lab1_3;
        }
    }else if (i == 2) {
        if (j == 0) {
            label = lab2_0;
        }else if(j == 1) {
            label = lab2_1;
        }else if(j == 2) {
            label = lab2_2;
        }else if(j == 3) {
            label = lab2_3;
        }
    }else if (i == 3) {
        if (j == 0) {
            label = lab3_0;
        }else if(j == 1) {
            label = lab3_1;
        }else if(j == 2) {
            label = lab3_2;
        }else if(j == 3) {
            label = lab3_3;
        }
    }
    value = [label.text intValue];
    return value;
}

#pragma mark - 设置label值
-(void)seti:(int)i j:(int)j v:(int)value
{
    UILabel * temp = [self getLabeli:i j:j];
    if (value != 0) {
        temp.text = [NSString stringWithFormat:@"%d",value];
    }else{
        temp.text = @"";
    }
    if (self.maxNum != 0) {
        self.labMax.text = [NSString stringWithFormat:@"%d",self.maxNum];
    }else{
        self.labMax.text = @"";
    }
    if (self.score != 0) {
        self.labScore.text = [NSString stringWithFormat:@"分数\n%d",self.score];
    }else{
        self.labScore.text = @"分数\n";
    }
    self.hisScore = self.score > self.hisScore?self.score:self.hisScore;
    if (self.hisScore != 0) {
        self.labHisScore.text = [NSString stringWithFormat:@"历史最高成绩\n%d",self.hisScore];
    }else{
        self.labHisScore.text = @"历史最高成绩\n";
    }
    if((self.maxNum > self.maxNum1 || self.hisScore > self.hisScore1)
       && self.hisScore != self.lastHisScore) {
        //归档
        self.numbers = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d",self.maxNum],[NSString stringWithFormat:@"%d",self.hisScore],[NSString stringWithFormat:@"%d",self.SoundZT], nil];
        [self.DataDict setObject:self.numbers forKey:@"numbers"];
        [[NSUserDefaults standardUserDefaults] setObject:self.DataDict forKey:@"DataDict"];

        self.lastHisScore = self.hisScore;
    }
    [self setbackColorv:[self geti:i j:j] label:temp];
}

//获取label
-(UILabel *)getLabeli:(int)i j:(int)j
{
    UILabel * temp;
    if (i == 0) {
        if (j == 0) {
            temp = lab0_0;
        }else if(j == 1) {
            temp = lab0_1;
        }else if(j == 2) {
            temp = lab0_2;
        }else if(j == 3) {
            temp = lab0_3;
        }
    }else if(i == 1) {
        if (j == 0) {
            temp = lab1_0;
        }else if(j == 1) {
            temp = lab1_1;
        }else if(j == 2) {
            temp = lab1_2;
        }else if(j == 3) {
            temp = lab1_3;
        }
    }else if (i == 2) {
        if (j == 0) {
            temp = lab2_0;
        }else if(j == 1) {
            temp = lab2_1;
        }else if(j == 2) {
            temp = lab2_2;
        }else if(j == 3) {
            temp = lab2_3;
        }
    }else if (i == 3) {
        if (j == 0) {
            temp = lab3_0;
        }else if(j == 1) {
            temp = lab3_1;
        }else if(j == 2) {
            temp = lab3_2;
        }else if(j == 3) {
            temp = lab3_3;
        }
    }
    return temp;
}

//设置label颜色
-(void)setbackColorv:(int)value label:(UILabel *)label
{
    UIColor * color = [self.dict objectForKey:[NSString stringWithFormat:@"%d",value]];
    if (color != nil) {
        label.backgroundColor = color;
    }
    if (value > 8192) {
        label.backgroundColor = [UIColor purpleColor];
    }
}

#pragma mark - 滑动功能
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recoginzer
{
    int ischange = 0;
    if (self.SoundZT) {
        [self playSound];
    }
    if (recoginzer.direction == UISwipeGestureRecognizerDirectionUp) {
        for (int y = 0; y < 4; y++) {
            for (int x = 0; x < 3; x++) {
                for (int z = x+1; z<4; z++) {
                    if ([self geti:x j:y] == 0
                        && [self geti:z j:y] != 0) {
                        [self seti:x j:y v:[self geti:z j:y]];
                        [self seti:z j:y v:0];
                        ischange++;
                    }
                    if ([self geti:x j:y] == [self geti:z j:y]
                        && [self geti:x j:y] != 0) {
                        [self seti:x j:y v:[self geti:z j:y]*2];
                        [self seti:z j:y v:0];
                        ischange++;
                        self.score += [self geti:x j:y];
                        self.maxNum = [self geti:x j:y] > self.maxNum?[self geti:x j:y]:self.maxNum;
                        break;
                    }
                    if ([self geti:x j:y] != [self geti:z j:y]
                        && [self geti:x j:y] != 0
                        && [self geti:z j:y] != 0) {
                        break;
                    }
                }
            }
        }
        
    }
    if (recoginzer.direction == UISwipeGestureRecognizerDirectionDown) {
        for (int y = 0; y < 4; y++) {
            for (int x = 3; x >= 0; x--) {
                for (int z = x-1; z>=0; z--) {
                    if ([self geti:x j:y] == 0
                        && [self geti:z j:y] != 0) {
                        [self seti:x j:y v:[self geti:z j:y]];
                        [self seti:z j:y v:0];
                        ischange++;
                    }
                    if ([self geti:x j:y] == [self geti:z j:y]
                        && [self geti:x j:y] != 0) {
                        [self seti:x j:y v:[self geti:z j:y]*2];
                        [self seti:z j:y v:0];
                        ischange++;
                        self.score += [self geti:x j:y];
                        self.maxNum = [self geti:x j:y] > self.maxNum?[self geti:x j:y]:self.maxNum;
                        break;
                    }
                    if ([self geti:x j:y] != [self geti:z j:y]
                        && [self geti:x j:y] != 0
                        && [self geti:z j:y] != 0) {
                        break;
                    }
                }
            }
        }
    }
    if (recoginzer.direction == UISwipeGestureRecognizerDirectionLeft) {
        for (int x = 0; x < 4; x++) {
            for (int y = 0; y < 3; y++) {
                for (int z = y+1; z < 4;z++) {
                    if ([self geti:x j:y] == 0
                        && [self geti:x j:z] != 0) {
                        [self seti:x j:y v:[self geti:x j:z]];
                        [self seti:x j:z v:0];
                        ischange++;
                    }
                    if ([self geti:x j:y] == [self geti:x j:z]
                        && [self geti:x j:y] != 0) {
                        [self seti:x j:y v:[self geti:x j:z]*2];
                        [self seti:x j:z v:0];
                        ischange++;
                        self.score += [self geti:x j:y];
                        self.maxNum = [self geti:x j:y] > self.maxNum?[self geti:x j:y]:self.maxNum;
                        break;
                    }
                    if ([self geti:x j:y] != [self geti:x j:z]
                        && [self geti:x j:y] != 0
                        && [self geti:x j:z] != 0) {
                        break;
                    }
                }
            }
        }
    }
    if (recoginzer.direction == UISwipeGestureRecognizerDirectionRight) {
        for (int x = 0; x < 4; x++) {
            for (int y = 3; y >= 0; y--) {
                for (int z = y-1; z >= 0;z--) {
                    if ([self geti:x j:y] == 0
                        && [self geti:x j:z] != 0) {
                        [self seti:x j:y v:[self geti:x j:z]];
                        [self seti:x j:z v:0];
                        ischange++;
                    }
                    if ([self geti:x j:y] == [self geti:x j:z]
                        && [self geti:x j:y] != 0) {
                        [self seti:x j:y v:[self geti:x j:z]*2];
                        [self seti:x j:z v:0];
                        ischange++;
                        self.score += [self geti:x j:y];
                        self.maxNum = [self geti:x j:y] > self.maxNum?[self geti:x j:y]:self.maxNum;
                        break;
                    }
                    if ([self geti:x j:y] != [self geti:x j:z]
                        && [self geti:x j:y] != 0
                        && [self geti:x j:z] != 0) {
                        break;
                    }
                }
            }
        }
    }
    if (ischange) {
        [self randNum:1];
    }
}

//设置随机数
-(int)randNum:(int)index
{
    //index 判断是否生产随机数，
    srand((unsigned)time(0));
    int baseNum = 0;//基数
    CGPoint point;
    NSValue * value;
    NSMutableArray * nums = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < X1; i++) {
        for (int j = 0; j < Y1; j++) {
            if([self geti:i j:j] == 0) {
                point.x = i;
                point.y = j;
                value = [NSValue valueWithCGPoint:point];
                [nums addObject:value];
            }
        }
    }
    
    //index = 0 校验是否结束
    //index = 1 生成随机数
    if ([nums count] > 0) {
        if (index == 1) {
            int location = 0;//位置
            location = rand()%([nums count]);
            value = [nums objectAtIndex:location];
            point = [value CGPointValue];
            baseNum = rand()%10;//随机2、4
            [self seti:point.x j:point.y v:[[self.twoFour objectAtIndex:baseNum] intValue]];
            UILabel * label = [self getLabeli:point.x j:point.y];
            [self setAnimation:label];
        }
    }
    if([nums count] <= 1) {
        int isend = [self isEnd];//是否结束游戏
        if (isend == 0) {
            //归档
            //排序
            [self SortScores];
            [self.DataDict setObject:self.ScoresArray forKey:@"ScoresArray"];
            [self.DataDict setObject:self.dateArrary forKey:@"dateArrary"];
            [[NSUserDefaults standardUserDefaults] setObject:self.DataDict forKey:@"DataDict"];

            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"运行提示" message:@"游戏结束!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    return [nums count];
}

//返回值 0 结束，1，正常
-(int)isEnd
{
    int isEnd = 0;//是否结束
    
    //up
    for (int i = 1; i < X1; i++) {
        for (int j = 0; j < Y1; j++) {
            if ([self geti:i j:j] == [self geti:i-1 j:j]
                && [self geti:i j:j] != 0) {
                isEnd = 1;
            }else if ([self geti:i-1 j:j] == 0
                      && [self geti:i j:j] != 0) {
                isEnd = 1;
            }
        }
    }
    //down
    for (int i = X1-2; i >= 0; i--) {
        for (int j = Y1 - 1; j >= 0; j--) {
            if ([self geti:i j:j] == [self geti:i+1 j:j]
                && [self geti:i j:j] != 0) {
                isEnd = 1;
            }else if ([self geti:i+1 j:j] == 0
                      && [self geti:i j:j] != 0) {
                isEnd = 1;
            }
        }
    }
    //left
    for (int j = 1; j < Y1; j++) {
        for (int i = 0; i<X1; i++) {
            if ([self geti:i j:j] == [self geti:i j:j-1]
                && [self geti:i j:j] != 0) {
                isEnd = 1;
            }else if ([self geti:i j:j-1] == 0
                      && [self geti:i j:j] != 0) {
                isEnd = 1;
            }
        }
    }
    //right
    for (int j = Y1-2; j >= 0; j--) {
        for (int i = X1-1; i>=0; i--) {
            if ([self geti:i j:j] == [self geti:i j:j+1]
                && [self geti:i j:j] != 0) {
                isEnd = 1;
            }else if ([self geti:i j:j+1] == 0
                      && [self geti:i j:j] != 0) {
                isEnd = 1;
            }
        }
    }
    return isEnd;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self setLabValue:lab0_0 = [[UILabel alloc]init]];
        [self setLabValue:lab0_1 = [[UILabel alloc]init]];
        [self setLabValue:lab0_2 = [[UILabel alloc]init]];
        [self setLabValue:lab0_3 = [[UILabel alloc]init]];
        [self setLabValue:lab1_0 = [[UILabel alloc]init]];
        [self setLabValue:lab1_1 = [[UILabel alloc]init]];
        [self setLabValue:lab1_2 = [[UILabel alloc]init]];
        [self setLabValue:lab1_3 = [[UILabel alloc]init]];
        [self setLabValue:lab2_0 = [[UILabel alloc]init]];
        [self setLabValue:lab2_1 = [[UILabel alloc]init]];
        [self setLabValue:lab2_2 = [[UILabel alloc]init]];
        [self setLabValue:lab2_3 = [[UILabel alloc]init]];
        [self setLabValue:lab3_0 = [[UILabel alloc]init]];
        [self setLabValue:lab3_1 = [[UILabel alloc]init]];
        [self setLabValue:lab3_2 = [[UILabel alloc]init]];
        [self setLabValue:lab3_3 = [[UILabel alloc]init]];
        self.score = 0;
        [self randNum:1];
        [self randNum:1];
    }
}

#pragma mark - 音效和动画设置
-(void)playSound
{
    SystemSoundID pmph;
    NSURL *tapSound = [[NSBundle mainBundle] URLForResource:@"music.wav" withExtension:nil];
    
    CFURLRef baseURL = (__bridge CFURLRef)tapSound;
    AudioServicesCreateSystemSoundID(baseURL, &pmph);
    AudioServicesPlaySystemSound(pmph);
}

//设置label动画效果
- (void)setAnimation:(UILabel *)_label
{
    //方式1
    /*
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];//动画持续时间
    //定义动画加速或减速方式//设置动画曲线，控制动画速度
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    //设置动画方式，并指出动画发生的位置
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_label cache:YES];
    [_label exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [UIView commitAnimations];//提交UIView动画
     */

    //方式2
    
    /* 过渡效果
     fade     //交叉淡化过渡(不支持过渡方向)
     push     //新视图把旧视图推出去
     moveIn   //新视图移到旧视图上面
     reveal   //将旧视图移开,显示下面的新视图
     cube     //立方体翻滚效果
     oglFlip  //上下左右翻转效果
     suckEffect   //收缩效果，如一块布被抽走(不支持过渡方向)
     rippleEffect //滴水效果(不支持过渡方向)
     pageCurl     //向上翻页效果
     pageUnCurl   //向下翻页效果
     cameraIrisHollowOpen  //相机镜头打开效果(不支持过渡方向)
     cameraIrisHollowClose //相机镜头关上效果(不支持过渡方向)
     */
    CATransition *animation = [CATransition animation];
    animation.delegate = self;//代理
    animation.duration = 0.25f; //动画时长
    //设置动画的“时机”效果。就是动画自身的“节奏”：比如：开始快，结束时变慢；开始慢，结束时变快；匀速；等，在动画过程中的“时机”效果。
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //
    animation.fillMode = kCAFillModeForwards;
    //过度效果
    animation.type = @"reveal";
    //过渡方向
    animation.subtype = @"formLeft";
    //动画开始起点(在整体动画的百分比)
    animation.startProgress = 0.0;
    //动画停止终点(在整体动画的百分比)
    animation.endProgress = 1.0;
    //设置是否动画完成后，动画效果从设置的layer上移除。默认为YES。
    animation.removedOnCompletion = NO;
    
    [_label.layer addAnimation:animation forKey:@"animation"];
}

#pragma mark - 代理
//实现代理，用于 程序重置、菜单界面的返回值处理
-(void)setArgs:(int)_args
{
    args = _args;
    if (args == 1
        || args == 2) {
        if (args == 2) {
            self.maxNum = 0,self.maxNum1 = 0;//最大值
            self.hisScore = 0,self.hisScore1 = 0;//历史最高分
            self.SoundZT = 1;
            self.labMax.text = @"";
            self.labHisScore.text = @"历史最高成绩\n";
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DataDict"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.numbers removeAllObjects];
            [self.ScoresArray removeAllObjects];
            [self.dateArrary removeAllObjects];
        }
        self.score = 0;//当前得分
        self.labScore.text = @"分数\n";
        [self setLabValue:lab0_0 = [[UILabel alloc]init]];
        [self setLabValue:lab0_1 = [[UILabel alloc]init]];
        [self setLabValue:lab0_2 = [[UILabel alloc]init]];
        [self setLabValue:lab0_3 = [[UILabel alloc]init]];
        [self setLabValue:lab1_0 = [[UILabel alloc]init]];
        [self setLabValue:lab1_1 = [[UILabel alloc]init]];
        [self setLabValue:lab1_2 = [[UILabel alloc]init]];
        [self setLabValue:lab1_3 = [[UILabel alloc]init]];
        [self setLabValue:lab2_0 = [[UILabel alloc]init]];
        [self setLabValue:lab2_1 = [[UILabel alloc]init]];
        [self setLabValue:lab2_2 = [[UILabel alloc]init]];
        [self setLabValue:lab2_3 = [[UILabel alloc]init]];
        [self setLabValue:lab3_0 = [[UILabel alloc]init]];
        [self setLabValue:lab3_1 = [[UILabel alloc]init]];
        [self setLabValue:lab3_2 = [[UILabel alloc]init]];
        [self setLabValue:lab3_3 = [[UILabel alloc]init]];
        
        [self randNum:1];
        [self randNum:1];
    }
    if (args == 3) {
        if (self.SoundZT == 1) {
            self.SoundZT = 0;
        }else {
            self.SoundZT = 1;
        }
        self.numbers = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d",self.maxNum],[NSString stringWithFormat:@"%d",self.hisScore],[NSString stringWithFormat:@"%d",self.SoundZT], nil];
        [self.DataDict setObject:self.numbers forKey:@"numbers"];
        [[NSUserDefaults standardUserDefaults] setObject:self.DataDict forKey:@"DataDict"];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
