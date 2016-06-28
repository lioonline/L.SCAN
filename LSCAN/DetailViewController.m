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
#import <Masonry.h>
#import "BlocksKit+UIKit.h"

@interface DetailViewController ()<UIActionSheetDelegate>

@property (nonatomic,strong)NSString *content;

@property (nonatomic,strong)UIView *cardView;

@property (nonatomic,strong)   NSArray *arrayOfAllMatches;
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
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    _cardView = [UIView new];
    _cardView.backgroundColor = [UIColor whiteColor];
    __weak DetailViewController *weakSelf = self;
    [self.view addSubview:_cardView];

    [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.equalTo(@100);
        make.left.equalTo(weakSelf.view.mas_left).with.equalTo(@15);
        make.right.equalTo(weakSelf.view.mas_right).with.equalTo(@-15);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.equalTo(@-100);

    }];
    
    _cardView.clipsToBounds = YES;
    _cardView.layer.cornerRadius = 6;
    
    UILabel *contentLabel = [UILabel new];
    [_cardView addSubview:contentLabel];
    contentLabel.text = _content;
    contentLabel.font  = LANTING;
    contentLabel.textColor = [UIColor colorWithHexColorString:@"#666666"];

    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.lineBreakMode =  NSLineBreakByClipping;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cardView.mas_top).with.equalTo(@10);
        make.right.equalTo(_cardView.mas_right).with.equalTo(@-10);
        make.left.equalTo(_cardView.mas_left).with.equalTo(@10);
        make.bottom.equalTo(_cardView.mas_bottom).with.equalTo(@-54);
    }];
    
    
    
    UIButton *open = [UIButton new];
    [_cardView addSubview:open];
    [open mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom);
        make.right.equalTo(_cardView.mas_right).with.equalTo(@-10);
        make.left.equalTo(_cardView.mas_left).with.equalTo(@10);
        make.bottom.equalTo(_cardView.mas_bottom).with.equalTo(@-10);
    }];
    
    [open setTitle:@"在浏览器中打开链接" forState:normal];
    open.layer.cornerRadius = 22;
    open.layer.borderWidth = 1;
    open.layer.borderColor = [UIColor blueColor].CGColor;
    [open setTitleColor:[UIColor blueColor] forState:normal];
   
    
    
    
    
    NSError *error;
    NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:_content options:0 range:NSMakeRange(0, [_content length])];
    _arrayOfAllMatches = arrayOfAllMatches;
    if (arrayOfAllMatches.count >0) {
        open.hidden = NO;
        
       [open bk_whenTapped:^{
          
           if (arrayOfAllMatches.count == 1) {
               
               for (NSTextCheckingResult *match in arrayOfAllMatches)
               {
                   NSString* substringForMatch = [_content substringWithRange:match.range];
                   NSLog(@"substringForMatch %@",substringForMatch);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:substringForMatch]];
               }
               
           }
           else {
               UIActionSheet *myActionSheet;
               myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
               for (NSTextCheckingResult *match in arrayOfAllMatches)
               {
                   NSString* substringForMatch = [_content substringWithRange:match.range];
                   [myActionSheet addButtonWithTitle:substringForMatch];
                   
               }
               [myActionSheet showInView:self.view];
           }
       }];
        

        
    }
    else{
        open.hidden = YES;
    }
    
//    for (NSTextCheckingResult *match in arrayOfAllMatches)
//    {
//        NSString* substringForMatch = [_content substringWithRange:match.range];
//         NSLog(@"substringForMatch %@",substringForMatch);
//    }
    
    
    
    [self.view bk_whenTapped:^{
        
        if (_hiddenBlock) {
            _hiddenBlock();
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        NSTextCheckingResult *match = _arrayOfAllMatches[buttonIndex - 1];
        
        NSString* substringForMatch = [_content substringWithRange:match.range];
        NSLog(@"substringForMatch %@",substringForMatch);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:substringForMatch]];
        

    }
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
