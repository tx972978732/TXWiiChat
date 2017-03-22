//
//  WCScanQRCodeViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/3/20.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import "WCScanQRCodeViewController.h"
#import "WCScanBGView.h"
#import "masonry.h"
#import "MBProgressHUD.h"

@interface WCScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong,readwrite)AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic,strong)WCScanBGView *scanBGView;
@property(nonatomic,strong)UIImageView *scanRectView, *lineView;
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)MBProgressHUD *loadHUD;
@end

@implementation WCScanQRCodeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描二维码";
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(chosePicInAlbum:)];
    NSNotificationCenter *notify = [NSNotificationCenter defaultCenter];
    [notify addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [notify addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (!_videoPreviewLayer) {
            [self loadUIView];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_loadHUD hideAnimated:YES];// always use MBPHUD on main_queue
            });
            [self startScan];
        }
    });
    _loadHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _loadHUD.mode = MBProgressHUDModeIndeterminate;
    _loadHUD.bezelView.color = [UIColor blackColor];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self stopScan];
}

- (void)dealloc{
    [self.videoPreviewLayer removeFromSuperlayer];
    self.videoPreviewLayer = nil;
    [self stopScan];
    [self stopScanLineAnimation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - load view

-(void)loadUIView{
    CGFloat width = kScreen_Width *2/3;
    CGFloat padding = (kScreen_Width - width)/2;
    CGRect scanRect = CGRectMake(padding, kScreen_Height/10, width, width);
    //设置videoPreviewLayer
    if (!_videoPreviewLayer) {
        NSError *err;
        //创建媒体会话
        AVCaptureSession *captureSession = [AVCaptureSession new];
        //创建会话设备
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建会话输入
        AVCaptureDeviceInput *captureInput = [[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&err];
        if (!captureInput) {
            NSLog(@"create captureInput fail:%@",err.localizedDescription);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        //添加会话输入
        [captureSession addInput:captureInput];
        //创建会话输出
        AVCaptureMetadataOutput *captureMetadataOutput = [AVCaptureMetadataOutput new];
        //设置输出代理及队列
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_queue_create("captureMetadataOutput_queue", NULL)];
        //添加会话输出
        [captureSession addOutput:captureMetadataOutput];
        //设置输出可用条码类型
        if (![captureMetadataOutput.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            //不支持二维码扫描则弹出友好提示、退出扫描
            UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"您的摄像头不支持二维码识别" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                WEAKSELF
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [AlertController addAction:cancelAction];
            [self presentViewController:AlertController animated:YES completion:nil];
        }else{
            [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        }
        //设置扫描区域，默认摄像头拍摄为横屏模式（手机头朝左）@Param：rectOfInterest 比例属性，通过比例计算输出范围
        captureMetadataOutput.rectOfInterest = CGRectMake(CGRectGetMinY(scanRect)/CGRectGetHeight(self.view.frame), CGRectGetMinX(scanRect)/CGRectGetWidth(self.view.frame), CGRectGetHeight(scanRect)/CGRectGetHeight(self.view.frame), CGRectGetWidth(scanRect)/CGRectGetWidth(self.view.frame));
        //设置PreviewLayer 将输出数据展示在View上
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
        //设置layer视图为保存横纵比进行填充
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_videoPreviewLayer setFrame:self.view.bounds];
        }
    }
    
    //添加视图
    dispatch_async(dispatch_get_main_queue(), ^{
        //设置scanBGView
        if (!_scanBGView) {
            _scanBGView = [[WCScanBGView alloc]initWithFrame:self.view.bounds];
            _scanBGView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
            _scanBGView.scanRect = scanRect;
        }
        //设置scanRectView
        if (!_scanRectView) {
            _scanRectView = [[UIImageView alloc]initWithFrame:scanRect];
            _scanRectView.image = [[UIImage imageNamed:@"scan_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 25, 25)];
            _scanRectView.clipsToBounds = YES;
        }
        //设置lineView
        if (!_lineView) {
            _lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -2, CGRectGetWidth(scanRect), 2)];
            _lineView.image = [UIImage imageNamed:@"scan_line"];
            _lineView.contentMode = UIViewContentModeScaleToFill;
        }
        //设置tipLabel
        if (!_tipLabel) {
            _tipLabel = [UILabel new];
            _tipLabel.textAlignment = NSTextAlignmentCenter;
            _tipLabel.font = [UIFont fontWithName:@"Arial" size:16];
            _tipLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
            _tipLabel.text = @"请将二维码对准框内";
        }
        //隐藏 HUD
        [_loadHUD hideAnimated:YES];
        [self.view.layer addSublayer:_videoPreviewLayer];
        [self.view addSubview:_scanBGView];
        [self.view addSubview:_scanRectView];
        [self.view addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(_scanRectView.bottom).with.offset(@15);
            make.height.equalTo(@30);
        }];
        [_scanRectView addSubview:_lineView];
        //启动会话
        [_videoPreviewLayer.session startRunning];
        [self startScanLineAnimation];
    });
}

#pragma mark - scan line animation
- (void)startScanLineAnimation{
    [self stopScanLineAnimation];
    //扫描线动画，从扫描区域Y：-2处沿Y轴向下移动至扫描区域Y：height+2处
    CABasicAnimation *scanAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    scanAnimation.fromValue = @(-CGRectGetHeight(_lineView.frame));
    scanAnimation.toValue = @(CGRectGetHeight(_scanRectView.frame)+CGRectGetHeight(_lineView.frame));
    //设置动画效果
    scanAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scanAnimation.repeatCount = CGFLOAT_MAX;
    scanAnimation.duration = 1.5;
    //convertTime获取本地时间，Param：CACurrentMediaTime 系统时间（距离最近一次启动设备的时间），Param：toLayer 为nil则直接返回参数1
    CFTimeInterval timeInterval = [self.lineView.layer convertTime:CACurrentMediaTime() toLayer:nil];
    //不加上timeInterval 则时间起点为layer自己的时间线起点，很可能已经超出了自己设置的起点时间，导致得不到延时效果。
    scanAnimation.beginTime = .5f + timeInterval;
    //scanAnimation.timeOffset = 1.0f; 动画偏移1秒
    [self.lineView.layer addAnimation:scanAnimation forKey:@"Scan_Animation"];
}

- (void)stopScanLineAnimation{
    [self.lineView.layer removeAllAnimations];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //验证数据内容，是否为二维码
    if (metadataObjects.count>0) {
        __block AVMetadataMachineReadableCodeObject *result = nil;
        [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataMachineReadableCodeObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.type isEqualToString:AVMetadataObjectTypeQRCode]) {
                result = obj;
                *stop = YES;
            }
        }];
        if (!result) {
            result = [metadataObjects firstObject];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程中对扫描结果进行确认
            [self checkResult:result];
        });
    }
}

- (void)checkResult:(AVMetadataMachineReadableCodeObject*)result{
    NSString *resultStr = result.stringValue;
    if (resultStr.length<=0) {
        return;
    }
    //得到结果 立即停止扫描
    [self stopScan];
    //提供机器震动反馈，提示扫描结束
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    //将最终结果交给回调block处理
    if (_scanResultBlock) {
        _scanResultBlock(self,resultStr);
    }
}

#pragma mark - chose picture

- (void)chosePicInAlbum:(UIBarButtonItem*)item{
    
}

#pragma mark - notification
- (void)applicationDidBecomeActive:(UIApplication*)application{
    [self startScan];
}

- (void)applicationWillResignActive:(UIApplication*)application{
    [self stopScan];
}

#pragma mark - public method

- (BOOL)isScaning{
    return _videoPreviewLayer.session.isRunning;
}

- (void)startScan{
    [self.videoPreviewLayer.session startRunning];
    [self startScanLineAnimation];
}

- (void)stopScan{
    [self.videoPreviewLayer.session stopRunning];
    [self stopScanLineAnimation];
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
