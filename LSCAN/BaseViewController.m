//
//  BaseViewController.m
//  LSCAN
//
//  Created by Lee on 6/10/16.
//  Copyright © 2016 Lee. All rights reserved.
//




#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
//    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    
//    pan.delegate = self;
//    
//    [self.view addGestureRecognizer:pan];
//    
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (self.childViewControllers.count == 1) {
//        return NO;
//    }
//    return YES;
//}


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
