//
//  WCBaseSearchViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2017/2/16.
//  Copyright © 2017年 童煊. All rights reserved.
//

#import "WCBaseSearchViewController.h"
#import "WCSearchResultTableController.h"
#import "AddContactHelper.h"
#import "WCBaseSearchController.h"

@interface WCBaseSearchViewController ()
@property(nonatomic,strong)UIView *searchBarView;
//@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)WCSearchResultTableController *searchResultVC;
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)AllUsers *filterUser;
@property(nonatomic,strong)dispatch_source_t timer;
@property(nonatomic,strong)WCBaseSearchController *mySearchController;
@end

@implementation WCBaseSearchViewController
- (instancetype)initBaseSearchViewController{
    self = [super init];
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.edgesForExtendedLayout = UIRectEdgeNone;//防止UINavigationBar 遮挡tableview
    [self addSearchController];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.mySearchController.active = YES;
    [self.mySearchController.searchBar becomeFirstResponder];

}

- (void)dealloc{
    NSLog(@"WCBaseSearchVC dealloc");
}

- (void)addSearchController{
    [self.navigationController.navigationBar addSubview:self.mySearchController.baseSearchBar];
}


- (WCBaseSearchController*)mySearchController{
    if (_mySearchController) {
        return _mySearchController;
    }
//   set search controller
    _mySearchController = [[WCBaseSearchController alloc]initWithSearchResultsController:self.searchResultVC searchBarFrame:CGRectMake(10, 7, kScreen_Width-75, 31)];
    _mySearchController.searchResultsUpdater = self;
    _mySearchController.hidesNavigationBarDuringPresentation = NO;
    _mySearchController.dimsBackgroundDuringPresentation = NO;
//   set search bar
    [_mySearchController.baseSearchBar setHeight:30];
    _mySearchController.baseSearchBar.layer.cornerRadius = 2;
    _mySearchController.baseSearchBar.layer.masksToBounds = YES;
    [_mySearchController.baseSearchBar setPlaceholder:@"搜索"];
    _mySearchController.baseSearchBar.delegate = self;
    _mySearchController.baseSearchBar.showsCancelButton = YES;
    _mySearchController.baseSearchBar.returnKeyType = UIReturnKeySearch;
    [_mySearchController.baseSearchBar sizeToFit];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popToMainVCAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    return _mySearchController;
}

- (WCSearchResultTableController*)searchResultVC{
    if (_searchResultVC) {
        return _searchResultVC;
    }
    _searchResultVC = [[WCSearchResultTableController alloc]init];
    _searchResultVC.tableView.delegate = self;
    return _searchResultVC;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if ([_searchController isActive]&&![_searchController.searchBar.text isEqualToString:@""]) {
    //        return 0.01f;
    //    }
        return 0.0001f;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 0.0001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //****点击UI切换
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击搜索cell");
        NSLog(@"点击搜索");
//        NSMutableDictionary *searchDic = [NSMutableDictionary dictionaryWithObject:self.searchResultVC.searchText forKey:@"wiiID"];
//        id searchResult = [[AddContactHelper sharedAddContactHelper] searchSourceDataSourceWithInfo:searchDic];
//        NSLog(@"searchResult:%@",searchResult);
//        if ([(AllUsers*)searchResult isKindOfClass:[NSManagedObject class]]) {
//            if ([[AddContactHelper sharedAddContactHelper] isFriendContact:searchResult]) {
//                self.filterUser = searchResult;
//                [self alreadyAddedIntoContact];
//            }else{
//                [self neverAddedIntoContact];
//            }
//        }else if ([(NSString*)searchResult isKindOfClass:[NSString class]]){
//            NSLog(@"isKindOf NSString");
//            if ([self respondsToSelector:NSSelectorFromString(searchResult)]) {
//                [self performSelector:NSSelectorFromString(searchResult) withObject:nil];
//                NSLog(@"respondsToSelector%@",searchResult);
//            }
//        }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}






#pragma mark - UISearchResultsUpdating Delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"搜索结果view");
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self.tableView reloadData];
    //    });
    //    _searchResultsTableController.searchText = searchController.searchBar.text;
    //    [_searchResultsTableController.tableView reloadData];
    WCSearchResultTableController *tableController = (WCSearchResultTableController *)_mySearchController.searchResultsController;
    tableController.searchText = self.mySearchController.baseSearchBar.text;
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
    _mySearchController.baseSearchBar.barTintColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0];
    if (![self.effectView superview]) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effectView = [[UIVisualEffectView alloc]initWithEffect:blur];//搜索时 背景毛玻璃效果
        self.effectView.frame = self.view.frame;
        [self.view addSubview:self.effectView];
    }
    return YES;
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;  {
    [searchBar setShowsCancelButton:NO];
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UIButton") class]]) {
            [(UIButton*)view removeFromSuperview];
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //_searchController.searchBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor clearColor];
    [self.effectView removeFromSuperview];
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (![searchBar.text isEqualToString:@""]) {
        [self.effectView removeFromSuperview];
        self.view.backgroundColor = [UIColor whiteColor];
    }else{
        if (![self.effectView superview]) {
            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            self.effectView = [[UIVisualEffectView alloc]initWithEffect:blur];//搜索时 背景毛玻璃效果
            self.effectView.frame = self.view.frame;
            [self.view addSubview:self.effectView];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBarCancleBtn clicked");
    [searchBar removeFromSuperview];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"点击搜索");
//    NSMutableDictionary *searchDic = [NSMutableDictionary dictionaryWithObject:searchBar.text forKey:@"wiiID"];
//    id searchResult = [[AddContactHelper sharedAddContactHelper] searchSourceDataSourceWithInfo:searchDic];
//    if ([(AllUsers*)searchResult isKindOfClass:[NSManagedObject class]]) {
//        if ([[AddContactHelper sharedAddContactHelper] isFriendContact:searchResult]) {
//            self.filterUser = searchResult;
//            [self alreadyAddedIntoContact];
//        }else{
//            [self neverAddedIntoContact];
//        }
//    }else if ([(NSString*)searchResult isKindOfClass:[NSString class]]){
//        if ([self respondsToSelector:NSSelectorFromString(searchResult)]) {
//            [self performSelector:NSSelectorFromString(searchResult) withObject:nil];
//        }
//    }
}

- (void)popToMainVCAction{
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
