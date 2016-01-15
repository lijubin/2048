//
//  ScoreViewController.h
//  2048
//
//  Created by 李居彬 on 15/6/18.
//  Copyright (c) 2015年 ljb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSMutableArray * array;
@property (strong,nonatomic) NSMutableArray * dateArray;
@end
