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
#import "DateTools.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,SlideDeleteCellDelegate>

@property (nonatomic,strong) NSArray        *coclorArray;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,strong) RLMResults<ResultModel*> *models;
@property (nonatomic,assign) float          offsetY;
@property (nonatomic,strong) UIButton       *scanButton;
@property (nonatomic,strong) UIView         *bgView;
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
    
    _dataArray             = [NSMutableArray array];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView             = tableView;
    tableView.delegate     = self;
    tableView.dataSource   = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithRed:67/255.0 green:70/255.0 blue:76/255.0 alpha:1];
    

    UIButton *button           = [UIButton new];
    [self.view addSubview:button];
    button.backgroundColor     = [UIColor colorWithHexColorString:@"#FF9900"];
    button.bounds              = CGRectMake(0, 0, 80,80);
    button.center              = CGPointMake(SCREEN_SIZE.width/2.0, SCREEN_SIZE.height - 60);
    button.layer.cornerRadius  = 40;
    button.layer.masksToBounds = NO;
    button.layer.shadowOffset  = CGSizeMake(0, 0);
    button.layer.shadowColor   = [UIColor grayColor].CGColor;
    button.layer.shadowOpacity = 0.5;
    [button setTitle:@"扫一扫" forState:normal];
    [button setTitleColor:[UIColor whiteColor] forState:normal];
    [button.titleLabel setFont:LANTING];
    [button addTarget:self action:@selector(toScanViewController) forControlEvents:UIControlEventTouchUpInside];
    _scanButton                = button;

    self.navigationController.navigationBarHidden = YES;
    
    
    
    
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    //  毛玻璃view 视图
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    //添加到要有毛玻璃特效的控件中
//    effectView.frame = self.view.bounds;
//    [self.view addSubview:effectView];
//    //设置模糊透明度
//    effectView.alpha = .5f;
    
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _bgView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
    [self.view addSubview: _bgView];
    _bgView.hidden = YES;

}


-(void)initData {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLogin"] == NULL) {
      
        NSArray *tipsArray = @[@"使用指南",@"扫一扫快速读取二维码内容",@"滑动可删除扫描历史记录",@"风到这里就是粘，粘住过客的思念",@"雨到了这里缠成线，缠着我们流连人世间",@"If falling stars are hiding in your eyes"];
        for (int i = 0; i < tipsArray.count; i++) {
            ResultModel *firstList = [[ResultModel alloc] init];
            NSDate *date           = [NSDate date];
            firstList.date         = date;
            firstList.resultString = tipsArray[i];
            RLMRealm *realm        = [RLMRealm defaultRealm];
            [realm transactionWithBlock:^{
                [realm addObject:firstList];
            }];
        }
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isFirstLogin"];
        
   
    }
    RLMResults<ResultModel *> *models = [ResultModel allObjects];
    _models = models;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = (MainTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (_models.count > 0) {
        ResultModel *model = _models[indexPath.row];
        cell.contentLabel.text = [NSString stringWithFormat:@" %@", model.resultString];
        cell.contentLabel.font  = LANTING;
        cell.contentLabel.textColor = [UIColor colorWithHexColorString:@"#666666"];
        
        
        NSDate *date = model.date;
        NSString *day = [NSString stringWithFormat:@"%ld",(long)date.day];
        NSString *hour = [NSString stringWithFormat:@"%ld",(long)date.hour];
        NSString *minute = [NSString stringWithFormat:@"%ld",(long)date.minute];
        
        
        NSString *str = [NSString stringWithFormat:@"%@\n%@:%@",day,hour,minute];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20]} range:NSMakeRange(0, day.length)];
        [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(day.length, attStr.length - day.length)];
        [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, attStr.length)];
        cell.dateLabel.attributedText = attStr;
    }
    cell.delegate =self;
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ResultModel *model = _models[indexPath.row];
    _bgView.hidden = NO;
    DetailViewController *detatil = [[DetailViewController alloc] initWithContent:model.resultString];
    detatil.hiddenBlock = ^(){
        _bgView.hidden = YES;
    };
    detatil.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:detatil animated:YES completion:^{
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(void)slideToDeleteCell:(SlideDeleteCell *)slideDeleteCell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:slideDeleteCell];
    ResultModel *model = _models[indexPath.row];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:model];
    [realm commitWriteTransaction];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


-(void)toScanViewController {
    DKScanViewController * scan = [DKScanViewController new];
    [self.navigationController pushViewController:scan animated:YES];
}

-(void)toSettingViewController{
    SettingViewController *setting = [SettingViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setting];
    [self presentViewController:nav animated:NO completion:^{
        
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _offsetY = scrollView.contentOffset.y;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_offsetY<scrollView.contentOffset.y) {
        NSLog(@"向上划");
        [self scanBUttonAnamation:YES];
    }
    else{
        NSLog(@"向下划");
        [self scanBUttonAnamation:NO];
    }
    
}



-(void)scanBUttonAnamation:(BOOL)isUP {
    if (isUP) {
        [UIView animateWithDuration:0.25 animations:^{
          
             _scanButton.frame = CGRectMake(_scanButton.frame.origin.x, SCREEN_SIZE.height + 100, _scanButton.frame.size.width, _scanButton.frame.size.height);

        }];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
             _scanButton.frame = CGRectMake(_scanButton.frame.origin.x, SCREEN_SIZE.height - 100, _scanButton.frame.size.width, _scanButton.frame.size.height);
        }];
    }
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
