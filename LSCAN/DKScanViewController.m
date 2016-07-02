//
//  DKScanViewController.m
//  aixiba
//
//  Created by Cocoa Lee on 9/16/15.
//  Copyright © 2015 Wash8. All rights reserved.
//

#define  Proportion          230/640.0
#define MY_WIDTH [UIScreen   mainScreen].bounds.size.width
#define MY_HEIGHT  [UIScreen mainScreen].bounds.size.height

#import <AudioToolbox/AudioToolbox.h>
#import "DKScanViewController.h"
#import "ResultModel.h"
#import "DateTools.h"
#import "BlocksKit+UIKit.h"
static SystemSoundID shake_sound_male_id = 0;

@interface DKScanViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) NSString *stringValue;
@property (nonatomic,strong) NSArray *arrayOfAllMatches;


@end

@implementation DKScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCamera];
    [self initView];
    
}


-(void)initView
{
    
    [super viewDidLoad];
           //    背景
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MY_WIDTH, 120)];
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = 0.5;
    [self.view addSubview:topView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0,120, 50, MY_HEIGHT-120)];
    leftView.backgroundColor = [UIColor blackColor];
    leftView.alpha = 0.5;
    [self.view addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(MY_WIDTH - 50,120, 50, MY_HEIGHT-120)];
    rightView.backgroundColor = [UIColor blackColor];
    rightView.alpha = 0.5;
    [self.view addSubview:rightView];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(50,120 + MY_WIDTH - 100,MY_WIDTH - 100, MY_HEIGHT-120-(MY_WIDTH - 100))];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.5;
    [self.view addSubview:bottomView];
    
    // angle
    
    UIImageView *angle1 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 120, 28, 28)];
    angle1.image = [UIImage imageNamed:@"angle_01.png"];
    [self.view addSubview:angle1];
    
    
    UIImageView *angle2 = [[UIImageView alloc] initWithFrame:CGRectMake(MY_WIDTH - 78, 120, 28, 28)];
    angle2.image = [UIImage imageNamed:@"angle_02.png"];
    [self.view addSubview:angle2];
    
    UIImageView *angle3 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 120 + (MY_WIDTH - 100)-28, 28, 28)];
    angle3.image = [UIImage imageNamed:@"angle_03.png"];
    [self.view addSubview:angle3];
    
    UIImageView *angle4 = [[UIImageView alloc] initWithFrame:CGRectMake(MY_WIDTH - 78, 120 + (MY_WIDTH - 100)-28, 28, 28)];
    angle4.image = [UIImage imageNamed:@"angle_04.png"];
    [self.view addSubview:angle4];
    
    
    
    //    提示
    
    UILabel * presentation = [[UILabel alloc] initWithFrame:CGRectMake(0, 120 + (MY_WIDTH - 100) + 50, MY_WIDTH, 30)];
    presentation.textAlignment = NSTextAlignmentCenter;
    presentation.text = @"将二维码放入框内,即可自动扫描";
    presentation.font = [UIFont systemFontOfSize:14];
    presentation.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    [self.view addSubview:presentation];
    
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25,25, 30, 30)];
    backImageView.image = [UIImage imageNamed:@"scan_back.png"];
    [self.view addSubview:backImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 20, 80, 80);
    [button addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50,120,(MY_WIDTH - 100), 2)];
    _line.image = [UIImage imageNamed:@"scan_line.png"];
    [self.view addSubview:_line];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
    
    
}
-(void)backToMain
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [timer invalidate];
}

-(void)lineAnimation
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 120+2*num, (MY_WIDTH - 100), 2);
        if (2*num >(MY_WIDTH - 102)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 120+2*num, (MY_WIDTH - 100), 2);
        if (num < 1) {
            upOrdown = NO;
        }
    }

}

- (void)setupCamera
{
    
    UIDevice *currentDevice=[UIDevice currentDevice];
    NSLog(@"设备的类别－－－－－%@",currentDevice.name);
    if ([currentDevice.name rangeOfString:@"Simulator"].length > 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"模拟器中无法使用相机" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    
    
    

    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    
    if(authStatus == AVAuthorizationStatusRestricted ||
       authStatus == AVAuthorizationStatusDenied){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置－隐私－相机”选项中，允许访问您的手机相机。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
        [alert show];
        
        
        return;
        
    }
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    CGSize size = self.view.bounds.size;
    //    扫描区域
    CGRect cropRect = CGRectMake(50, 120, MY_WIDTH - 100, MY_WIDTH - 100);
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = MY_WIDTH * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        _output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                            cropRect.origin.x/size.width,
                                            cropRect.size.height/fixHeight,
                                            cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = MY_HEIGHT * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        _output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                            (cropRect.origin.x + fixPadding)/fixWidth,
                                            cropRect.size.height/size.height,
                                            cropRect.size.width/fixWidth);
    }
    
    
    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.frame;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ( (metadataObjects.count==0) )
    {
        return;
    }
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        _stringValue = metadataObject.stringValue;
        NSLog(@"%@",_stringValue);
        
        

        
        NSError *error;
        NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:_stringValue options:0 range:NSMakeRange(0, [_stringValue length])];
        _arrayOfAllMatches = arrayOfAllMatches;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:[NSString stringWithFormat:@"%@",_stringValue] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        if (arrayOfAllMatches.count >0) {
            [alertView addButtonWithTitle:@"在Safari中打开链接"];
        }
        [alertView show];

        
        

        
        
        
        ResultModel *obj = [[ResultModel alloc] init];
        obj.resultString = _stringValue;
        NSDate *date           = [NSDate date];
        obj.date = date;
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:obj];
        }];
        
        
        [self playSound];
        [_session stopRunning];
        [timer invalidate];
    }
    
    
}


#pragma mark -alertDelegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
  
    NSLog(@"buttonIndex  == %ld",(long)buttonIndex);
    [_session startRunning];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
    if (buttonIndex == 2) {
        
        
        if (_arrayOfAllMatches.count == 1) {
            
            for (NSTextCheckingResult *match in _arrayOfAllMatches)
            {
                NSString* substringForMatch = [_stringValue substringWithRange:match.range];
                NSLog(@"substringForMatch %@",substringForMatch);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:substringForMatch]];
            }
            
        }
        else {
            UIActionSheet *myActionSheet;
            myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            for (NSTextCheckingResult *match in _arrayOfAllMatches)
            {
                NSString* substringForMatch = [_stringValue substringWithRange:match.range];
                [myActionSheet addButtonWithTitle:substringForMatch];
                
            }
            [myActionSheet showInView:self.view];
        }

    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
    _session = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        NSTextCheckingResult *match = _arrayOfAllMatches[buttonIndex - 1];
        
        NSString* substringForMatch = [_stringValue substringWithRange:match.range];
        NSLog(@"substringForMatch %@",substringForMatch);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:substringForMatch]];
        
        
    }
}


-(void) playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ding" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);
        //如果无法再下面播放，可以尝试在此播放
    }
    AudioServicesPlaySystemSound(shake_sound_male_id);
    //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
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
