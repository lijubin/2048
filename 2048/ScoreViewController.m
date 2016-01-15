//
//  ScoreViewController.m
//  2048
//
//  Created by 李居彬 on 15/6/18.
//  Copyright (c) 2015年 ljb. All rights reserved.
//

#import "ScoreViewController.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController
@synthesize array,dateArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * temp = [[NSString alloc]init];
    if ([array count] > 0) {
        for (int i = 0; i < [array count] - 1; i++) {
            for (int j = i+1; j < [array count]; j++) {
                if ([[array objectAtIndex:i] intValue] < [[array objectAtIndex:j] intValue]) {
                    temp = [array objectAtIndex:i];
                    [array replaceObjectAtIndex:i withObject:[array objectAtIndex:j]];
                    [array replaceObjectAtIndex:j withObject:temp];
                    temp = [dateArray objectAtIndex:i];
                    [dateArray replaceObjectAtIndex:i withObject:[dateArray objectAtIndex:j]];
                    [dateArray replaceObjectAtIndex:j withObject:temp];
                }
            }
        }
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(CancelBtn)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //self.view.frame
    UITableView * tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    UILabel * label1=[[UILabel alloc]init];
    UILabel * label2=[[UILabel alloc]init];
    label1.frame = CGRectMake(10, 70, 40, 20);
    label1.text = @"排名";
    label1.font=[UIFont systemFontOfSize:20];
    label1.textColor = [UIColor blueColor];
    label2.frame = CGRectMake(70, 70, 40, 20);
    label2.font=[UIFont systemFontOfSize:20];
    label2.textColor = [UIColor blueColor];
    label2.text = @"分数";
    if ([array count] > 0) {
        [self.view addSubview:label1];
        [self.view addSubview:label2];
    }
}

-(void)CancelBtn
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellWithIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellWithIdentifier];
    }
    NSString * str = [array objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%d\t\t%@",[indexPath row]+1,str];
    if ([indexPath row] == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:25];
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = [UIColor orangeColor];
    }
    cell.detailTextLabel.text = [dateArray objectAtIndex:[indexPath row]];;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    return cell;
}

- (void)didReceiveMemoryWarning {
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
