//
//  MainViewController.m
//  LSCAN
//
//  Created by Lee on 6/10/16.
//  Copyright © 2016 Lee. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+HexColor.h"
#import "DKScanViewController.h"
#import "ResultModel.h"
#import "DetailViewController.h"
#import "Header.h"
#import "SettingViewController.h"
#import "MainTableViewCell.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *coclorArray;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)RLMResults<ResultModel *> *models;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _coclorArray = @[@"#66CCCC",@"#CCFF66",@"#FF99CC",@"#FF9966"];
    
    [self initData];
        [self initView];

}

-(void)initView {
    
    self.view.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
    _dataArray = [NSMutableArray array];
//    self.navigationController.navigationBarHidden = YES;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245 alpha:1];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    
    UIButton *button = [UIButton new];
    [self.view addSubview:button];
    button.backgroundColor = [UIColor colorWithHexColorString:@"#FF9900"];
    button.bounds = CGRectMake(0, 0, 80,80);
    button.center = CGPointMake(SCREEN_SIZE.width/2.0, SCREEN_SIZE.height - 60);
    button.layer.cornerRadius = 40;
    button.layer.masksToBounds = NO;
    button.layer.shadowOffset = CGSizeMake(0, 0);
    button.layer.shadowColor = [UIColor grayColor].CGColor;
    button.layer.shadowOpacity = 0.5;
    [button setTitle:@"扫一扫" forState:normal];
    [button setTitleColor:[UIColor whiteColor] forState:normal];
    [button.titleLabel setFont:LANTING];
    [button addTarget:self action:@selector(toScanViewController) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [settingButton setImage:[UIImage imageNamed:@"setting"] forState:normal];
//    settingButton.bounds = CGRectMake(0, 0, 30, 30);
//    [settingButton addTarget:self action:@selector(toSettingViewController) forControlEvents:UIControlEventTouchUpInside];
//    //button.tintColor = [UIColor blueColor];
////    settingButton.backgroundColor = [UIColor redColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationController.navigationBarHidden = YES;

}


-(void)initData {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLogin"] == NULL) {
      
        NSArray *tipsArray = @[@"使用指南",@"扫一扫快速读取二维码内容",@"滑动可删除扫描历史记录",@"风到这里就是粘，粘住过客的思念",@"雨到了这里缠成线，缠着我们流连人世间",@"If falling stars are hiding in your eyes"];
        for (int i = 0; i < tipsArray.count; i++) {
            ResultModel *firstList = [[ResultModel alloc] init];
            firstList.resultString = tipsArray[i];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm transactionWithBlock:^{
                [realm addObject:firstList];
            }];
        }
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isFirstLogin"];
        
   
    }
    RLMResults<ResultModel *> *models = [ResultModel allObjects];
    _models = models;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _models.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = (MainTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (_models.count > 0) {
        ResultModel *model = _models[indexPath.section];
        cell.contentLabel.text = [NSString stringWithFormat:@" %@", model.resultString];
        cell.contentLabel.font  = LANTING;
        cell.contentLabel.textColor = [UIColor colorWithHexColorString:@"#666666"];
    }
    
    
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ResultModel *model = _models[indexPath.row];
//
//    DetailViewController *detatil = [[DetailViewController alloc] initWithContent:model.resultString];
//    
//    [self.navigationController pushViewController:detatil animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        ResultModel *model = _models[indexPath.section];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:model];
        [realm commitWriteTransaction];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//        
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}



-(void)toScanViewController {
    DKScanViewController * scan = [DKScanViewController new];
    [self.navigationController pushViewController:scan animated:YES];
}

-(void)toSettingViewController{
    SettingViewController *setting = [SettingViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setting];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    RLMResults<ResultModel *> *models = [ResultModel allObjects];
    _models = models;
    [_tableView reloadData];
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
