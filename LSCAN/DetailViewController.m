//
//  DetailViewController.m
//  LSCAN
//
//  Created by Lee on 6/10/16.
//  Copyright © 2016 Lee. All rights reserved.
//

#import "DetailViewController.h"
#import "Header.h"
#import "UIColor+HexColor.h"
@interface DetailViewController ()

@property (nonatomic,strong)NSString *content;

@end


@implementation DetailViewController

-(id)initWithContent:(NSString *)content {
    self = [super init];
    if (self) {
        _content = content;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *scrollView= [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    UILabel *label = [UILabel new];
    [scrollView addSubview:label];
    label.text = _content;
    CGSize size = [_content boundingRectWithSize:CGSizeMake(SCREEN_SIZE.width, MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]} context:nil].size;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByClipping;
    label.font = [UIFont systemFontOfSize:30];
    label.frame = CGRectMake(0, 0, SCREEN_SIZE.width, size.height);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = LANTING;
    label.textColor =  [UIColor colorWithHexColorString:@"#666666"];
    
    
    scrollView.contentSize = size;
    
  
    
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
