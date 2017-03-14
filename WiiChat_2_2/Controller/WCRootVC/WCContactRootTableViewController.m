//
//  WCContactRootTableViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/3.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCContactRootTableViewController.h"
#import "WCContactInfoViewController.h"
#import "WCFetchResultControllerDataBase.h"
#import "User.h"
#import "Contact.h"
#import "WCUIStoreManager.h"
#import "WCAddContactViewController.h"
#import "WCContactInfoViewController.h"
#import "AddContactHelper.h"

@interface WCContactRootTableViewController ()
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)WCFetchResultControllerDataBase *fetchResultControllerDataBase;
//@property(nonatomic,strong)NSMutableArray *UIDataSource; 已将数据内容剥离出去
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation WCContactRootTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    /*//self.UIDataSource = [[WCUIStoreManager sharedWCUIStoreManager]getRootContactUIDataSource];
    //self.tableView.dataSource = self;     数据相关内容剥离至其他类   */
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];//字母索引栏透明
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];//让分割线接触右边框
    self.automaticallyAdjustsScrollViewInsets = YES;//滚动视图从NavBar下开始
    self.extendedLayoutIncludesOpaqueBars  = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;//滚动视图沿伸至屏幕边缘
   // self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self loadAddContactBtn];
    [self loadSearchBar];
    [self setupFetchedResultsController];
    // [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.fetchResultControllerDataBase.paused = NO;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //恢复SearchBar UI状态
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.fetchResultControllerDataBase.paused = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - load
- (void)setupFetchedResultsController{
    self.fetchResultControllerDataBase = [[WCFetchResultControllerDataBase alloc]initWithTableView:self.tableView];
    self.fetchResultControllerDataBase.fetchResultController = [Contact contactFetchedResultsController];
    NSLog(@"RootContactVC setUpFetchResultController");
}

-(void)loadSearchBar{
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0];
    self.searchController.searchBar.placeholder = @"搜索";
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

-(void)loadAddContactBtn{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
}


#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 25;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                NSLog(@"新的朋友");
                break;
            case 1:
                NSLog(@"群聊");
                break;
            case 2:
                NSLog(@"标签");
                break;
            case 3:
                NSLog(@"公众号");
                break;
            default:
                break;
        }
    }else{
        NSIndexPath *tempPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
        Contact *contact = [self.fetchResultControllerDataBase.fetchResultController objectAtIndexPath:tempPath];
        WCContactInfoViewController  *contacInfo = [[WCContactInfoViewController alloc]initWithContactInfo:contact Relationship:alreadyAddedIntoContact];
        [self.navigationController pushViewController:contacInfo animated:YES];
    }
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


#pragma mark - UISearchResultsUpdating Delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}
#pragma mark -  UISearchBarDelegate Delegate
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

#pragma mark - other method
-(void)addContact{
    NSLog(@"添加好友");
    WCAddContactViewController *addContactVC = [[WCAddContactViewController alloc]init];
    [self.navigationController pushViewController:addContactVC animated:YES];
}

#pragma mark - UIStateRestoration
NSString *const RootContactViewControllerTitleKey = @"RootContactViewControllerTitleKey";
NSString *const RootContactSearchControllerIsActiveKey = @"RootContactSearchControllerIsActiveKey";
NSString *const RootContactSearchBarTextKey = @"RootContactSearchBarTextKey";
NSString *const RootContactSearchBarIsFirstResponderKey = @"RootContactSearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:RootContactViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:RootContactSearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:RootContactSearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:RootContactSearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:RootContactViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:RootContactSearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:RootContactSearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:RootContactSearchBarTextKey];
}


@end
