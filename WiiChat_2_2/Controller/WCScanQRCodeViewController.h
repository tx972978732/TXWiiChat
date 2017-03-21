//
//  WCScanQRCodeViewController.h
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/3/20.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import "WCBaseViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface WCScanQRCodeViewController : WCBaseViewController
typedef void(^scanQRCodeResultBlock)(WCScanQRCodeViewController *vc,NSString *resultStr);

@property(nonatomic,copy)scanQRCodeResultBlock scanResultBlock;
@property(nonatomic,strong,readonly)AVCaptureVideoPreviewLayer *videoPreviewLayer;

- (BOOL)isScaning;
- (void)startScan;
- (void)stopScan;

@end
