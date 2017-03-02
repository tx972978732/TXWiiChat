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

@interface WCMessageRootTableViewController ()<NSXMLParserDelegate>
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)ODRefreshControl *refreshController;
@property(nonatomic,strong)NSString *currentParse;
@property(nonatomic,strong)MBProgressHUD *myHUD;
@property(atomic,assign)BOOL cancelHUD;
@end
static float HUDProgress = 0.0f;

@implementation WCMessageRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    
//    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0,80, 0);
//    self.tableView.contentInset = insets;
//    self.tableView.scrollIndicatorInsets = insets;
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(test)];
    _refreshController = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    _refreshController.tintColor = [UIColor lightGrayColor];
    [_refreshController addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
    
    
    NSURL *url = [NSURL URLWithString:@"http://php.weather.sina.com.cn/xml.php?city=%B1%B1%BE%A9&password=DJOYnieT8234jlsK&day=0"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error!=nil&&response==nil) {
            if (error.code==NSURLErrorAppTransportSecurityRequiresSecureConnection) {
                NSLog(@"error:%ld",error.code);
            }
        }
        if (response!=nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            NSString *responseData = [NSString stringWithFormat:@"%@",data];
            //NSLog(@"responseData:%@",responseData);
            NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
            parser.delegate = self;
            [parser parse];
        }
    }];
    [dataTask resume];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MBProgressHUD*)myHUD{
    if (_myHUD) {
        return _myHUD;
    }
    return _myHUD;
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
            usleep(50000);
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

    });

}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"解析完毕");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_myHUD hideAnimated:YES];

    });
    HUDProgress = 0.0f;

}

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
