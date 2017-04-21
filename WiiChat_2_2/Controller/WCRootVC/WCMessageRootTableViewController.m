//
//  WCMessageRootTableViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/3.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCMessageRootTableViewController.h"
#import "WCAddContactViewController.h"
#import "ODRefreshControl.h"
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "AFNetworking.h"
#import "WCPopMenuView.h"
#import "WCScanQRCodeViewController.h"

@interface WCMessageRootTableViewController ()<NSXMLParserDelegate>
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)ODRefreshControl *refreshController;
@property(nonatomic,strong)NSString *currentParse;
@property(nonatomic,strong)MBProgressHUD *myHUD;
@property(nonatomic,strong)WCPopMenuView *popMenu;
@property(atomic,assign)BOOL cancelHUD;
@property(atomic,assign)BOOL isPopMenuShowed;//切换视图时隐藏popMenu
@end
static float HUDProgress = 0.0f;

@implementation WCMessageRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _searchController = ({
        UISearchController *searchC = [[UISearchController alloc]initWithSearchResultsController:nil];
        searchC.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        searchC.searchResultsUpdater = self;
        searchC.searchBar.delegate = self;
        searchC.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchC.hidesNavigationBarDuringPresentation = YES;
        searchC.definesPresentationContext = YES;
        searchC;} );
    self.tableView.tableHeaderView = _searchController.searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPopMenu)];
    _refreshController = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    _refreshController.tintColor = [UIColor lightGrayColor];
    [_refreshController addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability:%@",AFStringFromNetworkReachabilityStatus(status));
        if (status==AFNetworkReachabilityStatusReachableViaWiFi) {
                NSURL *url = [NSURL URLWithString:@"http://php.weather.sina.com.cn/xml.php?city=%B1%B1%BE%A9&password=DJOYnieT8234jlsK&day=0"];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    if (error!=nil&&response==nil) {
                        if (error.code==NSURLErrorAppTransportSecurityRequiresSecureConnection) {
                            NSLog(@"error:%ld",error.code);
                        }
                    }
                    if (response!=nil) {
                        //response-响应反馈   responseObject-响应结果返回的数据
                        NSLog(@"response encode name:%@",response.textEncodingName);
                        NSLog(@"response mime type:%@",response.MIMEType);
                        NSLog(@"response url:%@",response.URL);
                        NSLog(@"response file name:%@",response.suggestedFilename);
                        
                        NSLog(@"responseObject:%@",responseObject);
                        //NSLog(@"responseData:%@",responseData);
                        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:responseObject];
                        parser.delegate = self;
                        [parser parse];
                    }
                    });
                }];
                [task resume];
            
            
            
            
//            NSURL *url = [NSURL URLWithString:@"http://php.weather.sina.com.cn/xml.php?city=%B1%B1%BE%A9&password=DJOYnieT8234jlsK&day=0"];
//            NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//            NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                if (error!=nil&&response==nil) {
//                    if (error.code==NSURLErrorAppTransportSecurityRequiresSecureConnection) {
//                        NSLog(@"error:%ld",error.code);
//                    }
//                }
//                if (response!=nil) {
//                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
//                    NSString *responseData = [NSString stringWithFormat:@"%@",data];
//                    //NSLog(@"responseData:%@",responseData);
//                    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
//                    parser.delegate = self;
//                    [parser parse];
//                }
//            }];
//            [dataTask resume];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    NSLog(@"MessageRootVC WiiDisappear");
    if (_isPopMenuShowed==YES) {
        [self.popMenu dismissPopMenuAnimatedOnMenuSelected:NO];
        _isPopMenuShowed = NO;
    }
}

- (void)dealloc{
    [self.searchController.view.superview removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma property

- (MBProgressHUD*)myHUD{
    if (_myHUD) {
        return _myHUD;
    }
    return _myHUD;
}

-(WCPopMenuView*)popMenu{
    if (!_popMenu) {
        self.isPopMenuShowed = NO;
        NSMutableArray *myPopMenuItems = [[NSMutableArray alloc]initWithCapacity:6];
        for (int i=0; i<5; i++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0:
                {
                    imageName = @"contacts_add_newmessage";
                    title = @"发起群聊";
                    break;
                }
                case 1:{
                    imageName = @"contacts_add_friend";
                    title = @"添加朋友";
                    break;
                }
                case 2: {
                    imageName = @"contacts_add_scan";
                    title = @"扫一扫";
                    break;
                }
                case 3: {
                    imageName = @"contacts_add_photo";
                    title = @"拍照";
                    break;
                }
                case 4: {
                    imageName = @"contacts_add_voip";
                    title = @"录视频";
                    break;
                }
                default:
                    break;
            }
            WCPopMenuItem *item = [[WCPopMenuItem alloc]initPopMenuItemWithImage:[UIImage imageNamed:imageName] title:title];
            [myPopMenuItems addObject:item];
        }
        _popMenu = [[WCPopMenuView alloc]initWithMenus:myPopMenuItems];
        WEAKSELF
        _popMenu.popMenuDidSelectBlock = ^(NSInteger index,WCPopMenuItem *menuItem){
            switch (index) {
                case 0:
                    [weakSelf test];
                    break;
                case 1:
                    [weakSelf test];
                    break;
                case 2:
                    [weakSelf scanBtnClicked];
                    break;
                case 3:
                    [weakSelf test];
                    break;
                default:
                    [weakSelf test];
                    break;
            }
            NSString * log = @"hello,world!";
            return log;
        };
    }
    return _popMenu;
}


#pragma mark - UISearchResultsUpdating delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}


#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.currentParse = elementName;
    NSLog(@"%@",self.currentParse);
    if ([self.currentParse isEqualToString:@"Weather"]) {
        NSLog(@"%@",self.currentParse);
    }
    WEAKSELF
    if ([self.currentParse isEqualToString:@"city"]) {
        HUDProgress = 0.0f;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD HUDForView:weakSelf.navigationController.view].progress = HUDProgress;
            
        });
        
    }
    else{
        if(![self.currentParse isEqualToString:@"savedate_zhishu"]&&HUDProgress<=1.0f) {
            HUDProgress +=0.02f;
            usleep(10000);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD HUDForView:weakSelf.navigationController.view].progress = HUDProgress;
                
            });
        }
    }

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(@"list:%@",string);
}
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        _myHUD = [MBProgressHUD showHUDAddedTo:weakSelf.navigationController.view animated:YES];
        _myHUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        _myHUD.label.text = @"Loading...";
        NSLog(@"start loading!");

    });

}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"解析完毕");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_myHUD hideAnimated:YES];

    });
    HUDProgress = 0.0f;

}

#pragma pravite method
- (void)showPopMenu{
    NSLog(@"show pop menu!");
    [self.popMenu showMenuOnView:self.view.superview atPoint:CGPointZero];
    //在UIViewControllerWrapperView中显示popMenu,Menu才不会随着tableView滚动
    //UITableViewController中的view属性指向其自身的tableView；
    
    if (_isPopMenuShowed==NO) {
        _isPopMenuShowed = YES;
    }else{
        _isPopMenuShowed = NO;
    }

}

#pragma popMenuItemClick_Method
- (void)scanBtnClicked{
    WCScanQRCodeViewController *scanVC = [WCScanQRCodeViewController new];
    WEAKSELF
    scanVC.scanResultBlock = ^(WCScanQRCodeViewController *vc,NSString *result){
        [weakSelf dealWithScanResult:result inViewController:vc];
    };
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)dealWithScanResult:(NSString*)result inViewController:(WCScanQRCodeViewController*)vc{
    NSURL *url = [NSURL URLWithString:result];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma test-MBPrgoressHUD
-(void)test{
    _myHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //    _myHUD.center = self.view.center;
    _myHUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    _myHUD.label.text = @"Loading...";
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            STRONGSELF
            [strongSelf.myHUD hideAnimated:YES];
            WCAddContactViewController *testVC = [[WCAddContactViewController alloc]init];
            [self.navigationController pushViewController:testVC animated:YES];
        });
    });
}

- (void)doSomeWorkWithProgress {

    
    self.cancelHUD = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
        if (self.cancelHUD) break;
        progress += 0.03f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [MBProgressHUD HUDForView:self.navigationController.view].progress = progress;
        });
        usleep(50000);
    }
}


-(void)refresh{
    NSLog(@"刷新界面");
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
        [self.refreshController endRefreshing];
    });
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
