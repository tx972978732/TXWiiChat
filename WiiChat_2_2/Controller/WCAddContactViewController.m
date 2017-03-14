//
//  WCAddContactViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/2.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCAddContactViewController.h"
#import "WCUIStoreManager.h"
#import "AddContactHelper.h"
#import "WCContactInfoViewController.h"
#import "WCSearchResultTableController.h"
#import "WCProfileRootTableViewController.h"

@interface WCAddContactViewController ()
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)WCSearchResultTableController *searchResultsTableController;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UILabel *headerLabel;
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)AllUsers *filterUser;
@property(nonatomic,strong)UIAlertController *alertController;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@end


NSString *const addContactVCCellIdentifier = @"addContactVCCellIdentifier";

@implementation WCAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加朋友";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundView = self.backgroundView;
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.automaticallyAdjustsScrollViewInsets = YES;//滚动视图从NavBar下开始
    self.extendedLayoutIncludesOpaqueBars  = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;//滚动视图沿伸至屏幕边缘
    self.dataSource = [[WCUIStoreManager sharedWCUIStoreManager]getAddContactUIDataSource];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (_searchControllerWasActive) {
        _searchController.active = _searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (_searchControllerSearchFieldWasFirstResponder) {
            [_searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    self.searchController.searchResultsUpdater = nil;
    self.searchController.searchBar.delegate = nil;
    self.searchResultsTableController.tableView.delegate = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}


#pragma mark - load
-(WCSearchResultTableController*)searchResultsTableController{
    if (_searchResultsTableController) {
        return _searchResultsTableController;
    }
    _searchResultsTableController = [[WCSearchResultTableController alloc]init];
    _searchResultsTableController.tableView.delegate = self;
    return _searchResultsTableController;
}
-(UISearchController*)searchController{
    if (_searchController) {
        return _searchController;
    }
    _searchController = [[UISearchController alloc]initWithSearchResultsController:self.searchResultsTableController];
    [_searchController.searchBar sizeToFit];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;
    //    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchController.hidesNavigationBarDuringPresentation = YES;
    _searchController.dimsBackgroundDuringPresentation = YES;
    //    _searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    //_searchController.searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchController.searchBar.bounds.size];
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    _searchController.searchBar.barTintColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0];
    _searchController.searchBar.placeholder = @"WiiChat号/手机号";
    _searchController.searchBar.returnKeyType = UIReturnKeySearch;
    self.definesPresentationContext = YES;
    return _searchController;
}


#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView!=self.tableView) {
        return 65;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if ([_searchController isActive]&&![_searchController.searchBar.text isEqualToString:@""]) {
    //        return 0.01f;
    //    }
    if (tableView!=self.tableView) {
        return 0.0001f;
    }
    return  80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView!=self.tableView) {
        return 0.0001f;
    }
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //****点击UI切换
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击搜索cell");
    if (tableView!=self.tableView) {//判断若不是AddContactVC的tableview 即为SearchResultVC 执行搜索任务
        NSLog(@"点击搜索");
        NSMutableDictionary *searchDic = [NSMutableDictionary dictionaryWithObject:self.searchResultsTableController.searchText forKey:@"wiiID"];
        id searchResult = [[AddContactHelper sharedAddContactHelper] searchSourceDataSourceWithInfo:searchDic];
        NSLog(@"searchResult:%@",searchResult);
        if ([(AllUsers*)searchResult isKindOfClass:[NSManagedObject class]]) {
            self.filterUser = searchResult;
            if ([[AddContactHelper sharedAddContactHelper] isFriendContact:searchResult]) {
                [self alreadyAddedIntoContact];
            }else{
                [self neverAddedIntoContact];
            }
        }else if ([(NSString*)searchResult isKindOfClass:[NSString class]]){
            NSLog(@"isKindOf NSString");
            if ([self respondsToSelector:NSSelectorFromString(searchResult)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:NSSelectorFromString(searchResult) withObject:nil];
#pragma clang diagnostic pop

                NSLog(@"respondsToSelector%@",searchResult);
            }
        }
    }else{
        WCProfileRootTableViewController *testVC = [[WCProfileRootTableViewController alloc]init];
        [self.navigationController pushViewController:testVC animated:YES];
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView!=self.tableView) {
        return nil;
    }
    static NSString *headerViewIdentifier = @"headerViewIdentifier";
    UITableViewHeaderFooterView *myHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewIdentifier];
    if (!myHeaderView) {
        myHeaderView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerViewIdentifier];
    }
    
    myHeaderView.contentView.backgroundColor = [UIColor clearColor];
//        UIView *headerView = [[UIView alloc]init];
//        headerView.backgroundColor = [UIColor clearColor];
        self.headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
        self.headerLabel.textAlignment = NSTextAlignmentCenter;
        self.headerLabel.text = @"我的WiiChat号:1";
        self.headerLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
        self.headerLabel.textColor = [UIColor darkTextColor];
        [myHeaderView addSubview:self.headerLabel];
        return myHeaderView;
    
}





#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (![_searchController isActive]) {
//        return 1;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if ([_searchController isActive]&&![_searchController.searchBar.text isEqualToString:@""]) {
//        
//        return 1;
//    }
    return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:addContactVCCellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:addContactVCCellIdentifier];
    }
    //    if ([_searchController isActive]&&![_searchController.searchBar.text isEqualToString:@""]) {
    //        cell.textLabel.text = [NSString stringWithFormat:@"搜索:%@",_searchController.searchBar.text];
    //        cell.imageView.image = [UIImage imageNamed:@"searchIcon2"];
    //        cell.accessoryType = UITableViewCellAccessoryNone;
    //        cell.detailTextLabel.text = nil;
    //
    //    }
    //    else{
    cell.imageView.image = [UIImage imageNamed:[self.dataSource[indexPath.section+1][indexPath.row] valueForKey:@"image"]];
    cell.textLabel.text = [self.dataSource[indexPath.section+1][indexPath.row] valueForKey:@"title"];
    cell.detailTextLabel.text = [self.dataSource[1][indexPath.row] valueForKey:@"detail"];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // }
//    self.tableViewCell = cell;
    return cell;
}

#pragma mark - UISearchResultsUpdating Delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"搜索结果view");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
//    _searchResultsTableController.searchText = searchController.searchBar.text;
//    [_searchResultsTableController.tableView reloadData];
    WCSearchResultTableController *tableController = (WCSearchResultTableController *)_searchController.searchResultsController;
    tableController.searchText = self.searchController.searchBar.text;
    [tableController.tableView reloadData];

}
#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}
#pragma mark -  UISearchBarDelegate Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [[self.tableView headerViewForSection:0] setOpaque:NO];
    [[self.tableView headerViewForSection:0] setAlpha:0];
    _searchController.searchBar.barTintColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0];
    if (![self.effectView superview]) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effectView = [[UIVisualEffectView alloc]initWithEffect:blur];//搜索时 背景毛玻璃效果
        self.effectView.frame = self.view.frame;
        [self.tableView addSubview:self.effectView];
    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;  {
    [searchBar setShowsCancelButton:YES];
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UIButton") class]]) {
            UIButton * cancelBtn =(UIButton *)view;
            cancelBtn.tintColor = [UIColor greenColor];
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //_searchController.searchBar.barTintColor = [UIColor whiteColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.effectView removeFromSuperview];
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (![searchBar.text isEqualToString:@""]) {
        [self.effectView removeFromSuperview];
        self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    }else{
        if (![self.effectView superview]) {
            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            self.effectView = [[UIVisualEffectView alloc]initWithEffect:blur];//搜索时 背景毛玻璃效果
            self.effectView.frame = self.view.frame;
            [self.tableView addSubview:self.effectView];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"取消搜索");
    [[self.tableView headerViewForSection:0] setOpaque:YES];
    [[self.tableView headerViewForSection:0] setAlpha:1];
    //[self.effectView removeFromSuperview];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    //[self.tableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"点击搜索");
    NSMutableDictionary *searchDic = [NSMutableDictionary dictionaryWithObject:searchBar.text forKey:@"wiiID"];
    id searchResult = [[AddContactHelper sharedAddContactHelper] searchSourceDataSourceWithInfo:searchDic];
    if ([(AllUsers*)searchResult isKindOfClass:[NSManagedObject class]]) {
        if ([[AddContactHelper sharedAddContactHelper] isFriendContact:searchResult]) {
            self.filterUser = searchResult;
            [self alreadyAddedIntoContact];
        }else{
            [self neverAddedIntoContact];
        }
    }else if ([(NSString*)searchResult isKindOfClass:[NSString class]]){
        if ([self respondsToSelector:NSSelectorFromString(searchResult)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:NSSelectorFromString(searchResult) withObject:nil];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark - help method

-(void)neverAddedIntoContact{
    NSLog(@"陌生人");
    //_searchController.active = NO;
    //[searchBar resignFirstResponder];
    [self.effectView removeFromSuperview];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.tableView reloadData];
    WCContactInfoViewController *contactInfoVC = [[WCContactInfoViewController alloc]initWithUserInfo:self.filterUser Relationship:neverAddedIntoContact];
    [self.navigationController pushViewController:contactInfoVC animated:YES];

}

-(void)alreadyAddedIntoContact{
    NSLog(@"已经添加为好友");
    //[_searchController.searchBar resignFirstResponder];
    [self.effectView removeFromSuperview];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.tableView reloadData];
    WCContactInfoViewController *contactInfoVC = [[WCContactInfoViewController alloc]initWithUserInfo:self.filterUser Relationship:alreadyAddedIntoContact];
    [self.navigationController pushViewController:contactInfoVC animated:YES];

}

-(void)isLocalUser{
    NSLog(@"不能添加自己为好友");
    self.alertController = [UIAlertController alertControllerWithTitle:@"你不能添加自己" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [self.alertController addAction:cancelAction];
    [self presentViewController:self.alertController animated:YES completion:nil];
}

-(void)noSuchUserInDataBase{
    NSLog(@"该用户不存在");
    self.alertController = [UIAlertController alertControllerWithTitle:@"该用户不存在" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [self.alertController addAction:cancelAction];
    [self presentViewController:self.alertController animated:YES completion:nil];

}

-(void)failToCheckUserInfo{
    NSLog(@"查询失败，请重试");
    self.alertController = [UIAlertController alertControllerWithTitle:@"查找该用户信息失败" message:@"请稍后再试或联系管理员" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"联系管理员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //*****发送错误报告
        
    }];
    [self.alertController addAction:cancelAction];
    [self.alertController addAction:reportAction];
    [self presentViewController:self.alertController animated:YES completion:nil];
}


NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = _searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    _searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
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
