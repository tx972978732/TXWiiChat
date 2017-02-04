//
//  WCContactInfoViewController.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/11/7.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCContactInfoViewController.h"
#import "WCUIStoreManager.h"
#import "AddContactHelper.h"

@interface WCContactInfoViewController ()
@property(nonatomic,strong)AllUsers *dataSourceContact;
@property(nonatomic,strong)Contact *localContact;
@property(nonatomic,strong)Contact *contactInfo;
@property(nonatomic,strong)NSString *modelTag;
@property(nonatomic,strong)UIAlertController *alertController;
@property(nonatomic,strong)UIButton *addContactBtn;
@property(nonatomic,strong)UIButton *sendMessageBtn;
@property(nonatomic,strong)UIButton *faceTimeRequestBtn;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)UserSource *ContactInfoVCUserSource;
@end
static contactRelationship relationships;
NSString *const contactInfoVCCellIdentifier = @"contactInfoVCCellIdentifier";

@implementation WCContactInfoViewController
- (id)initWithUserInfo:(AllUsers*)info Relationship:(contactRelationship)relationship{
    self = [super init];
    NSLog(@"dataSourceContact info1 :%@",info);
    if (self) {
        self.dataSourceContact = info;
        NSLog(@"dataSourceContact info2 :%@",self.dataSourceContact);
        relationships = relationship;
        self.dataSourceArray = [[WCUIStoreManager sharedWCUIStoreManager]getContactInfoUIDataSource];
        self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.modelTag = @"addContact";
        //[self.view addSubview:self.tableView];
    }
    return self;
}

- (id)initWithContactInfo:(Contact*)info Relationship:(contactRelationship)relationship{
    self = [super init];
    if (self) {
        self.localContact = info;
        relationships = relationship;
        self.dataSourceArray = [[WCUIStoreManager sharedWCUIStoreManager]getContactInfoUIDataSource];
        self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.modelTag = @"contactInfo";
        //[self.view addSubview:self.tableView];
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ContactInfoVCUserSource = [[UserSource alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load view
-(void)loadBtn{
    self.sendMessageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.sendMessageBtn.frame = CGRectMake(50, 30, self.view.frame.size.width-100, 44);
    self.sendMessageBtn.backgroundColor = [UIColor greenColor];
    [self.sendMessageBtn setTitle:@"发送消息" forState:UIControlStateNormal];
    [self.sendMessageBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    self.sendMessageBtn.layer.cornerRadius = 5;
    self.sendMessageBtn.layer.borderWidth = 3.0f;
    self.sendMessageBtn.showsTouchWhenHighlighted = YES;
    [self.sendMessageBtn addTarget:self action:@selector(sendMessageToContact) forControlEvents:UIControlEventTouchUpInside];
    
    self.faceTimeRequestBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.faceTimeRequestBtn.frame = CGRectMake(50, 104, self.view.frame.size.width-100, 44);
    self.faceTimeRequestBtn.backgroundColor = [UIColor greenColor];
    [self.faceTimeRequestBtn setTitle:@"视频通话" forState:UIControlStateNormal];
    [self.faceTimeRequestBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    self.faceTimeRequestBtn.layer.cornerRadius = 5;
    self.faceTimeRequestBtn.layer.borderWidth = 3.0f;
    self.faceTimeRequestBtn.showsTouchWhenHighlighted = YES;
    [self.faceTimeRequestBtn addTarget:self action:@selector(faceTimeWithContact) forControlEvents:UIControlEventTouchUpInside];
    
    self.addContactBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addContactBtn.backgroundColor = [UIColor greenColor];
    self.addContactBtn.frame = CGRectMake(50, 30, self.view.frame.size.width-100, 44);
    [self.addContactBtn setTitle:@"添加到通讯录" forState:UIControlStateNormal];
    [self.addContactBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    self.addContactBtn.layer.cornerRadius = 5;
    self.addContactBtn.layer.borderWidth = 3.0f;
    self.addContactBtn.showsTouchWhenHighlighted = YES;
    [self.addContactBtn addTarget:self action:@selector(addContactToUser) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (relationships==alreadyAddedIntoContact) {//是否为好友 cell高度不同
        if (indexPath.section==0||(indexPath.section==2&&indexPath.row==1)) {
            return 60;
        }
        return 44;
    }else{
        if (indexPath.section==0) {
            return 60;
        }
        return 44;
    }
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 400;//底部高度不够会导致 footerView看得到 但无法响应事件
    }
    return 4;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //****点击UI切换
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"点击搜索cell");
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
    footerView.backgroundColor = [UIColor clearColor];
    [self loadBtn];
    if (section==2) {
        if (relationships==alreadyAddedIntoContact) {        //判断是否为好友 footerView不同
            [footerView addSubview:self.sendMessageBtn];
            [footerView addSubview:self.faceTimeRequestBtn];
            return footerView;
        }else{
            [footerView addSubview:self.addContactBtn];
            return footerView;
        }
    }
    return nil;
}





#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (relationships) {
        case alreadyAddedIntoContact:
            if (section==2) {
                return 3;
            }
            return 1;
            break;
        case neverAddedIntoContact:
            if (section==2) {
                return 4;
            }
            return 1;
        default:
            break;
    }
    if (section==2) {
        return 4;
    }
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contactInfoVCCellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:contactInfoVCCellIdentifier];
    }
    switch (relationships) {
        case alreadyAddedIntoContact:
            NSLog(@"alreadyAdded cell");
            if ([self.modelTag isEqualToString:@"addContact"]) {
                if (indexPath.section==0) {
                    cell.imageView.image = [UIImage imageWithData:self.dataSourceContact.wiiHeadImg];
                    cell.textLabel.text = self.dataSourceContact.wiiName;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"WiiChat号:%@",self.dataSourceContact.wiiID];
                    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
                    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                }else if (indexPath.section==1){
                    cell.textLabel.text = [[self.dataSourceArray lastObject][indexPath.section-1][indexPath.row] valueForKey:@"title"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    if (indexPath.row==0) {
                        cell.textLabel.text = [[self.dataSourceArray lastObject][indexPath.section-1][indexPath.row] valueForKey:@"title"];
                        cell.detailTextLabel.text = self.dataSourceContact.wiiAddress;
                    }else{
                        cell.textLabel.text = [[self.dataSourceArray lastObject][indexPath.section-1][indexPath.row] valueForKey:@"title"];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                }

            }else if ([self.modelTag isEqualToString:@"contactInfo"]){
                if (indexPath.section==0) {
                    cell.imageView.image = [UIImage imageWithData:self.localContact.wiiHeadImg];
                    cell.textLabel.text = self.localContact.wiiName;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"WiiChat号:%@",self.localContact.wiiID];
                    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
                    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                }else if (indexPath.section==1){
                    cell.textLabel.text = [[self.dataSourceArray lastObject][indexPath.section-1][indexPath.row] valueForKey:@"title"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    if (indexPath.row==0) {
                        cell.textLabel.text = [[self.dataSourceArray lastObject][indexPath.section-1][indexPath.row] valueForKey:@"title"];
                        cell.detailTextLabel.text = self.localContact.wiiAddress;
                    }else{
                        cell.textLabel.text = [[self.dataSourceArray lastObject][indexPath.section-1][indexPath.row] valueForKey:@"title"];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                }
            }
            break;
        case neverAddedIntoContact:
            NSLog(@"neverAdder cell");
            if (indexPath.section==0) {
                cell.imageView.image = [UIImage imageWithData:self.dataSourceContact.wiiHeadImg];
                cell.textLabel.text = self.dataSourceContact.wiiName;
            }else if (indexPath.section==1){
                cell.textLabel.text = [[self.dataSourceArray firstObject][indexPath.section-1][indexPath.row] valueForKey:@"title"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                if (indexPath.row==2) {
                    cell.textLabel.text = [[self.dataSourceArray firstObject][indexPath.section-1][indexPath.row] valueForKey:@"title"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                }else if(indexPath.row==0){
                    cell.textLabel.text = [[self.dataSourceArray firstObject][indexPath.section-1][indexPath.row] valueForKey:@"title"];
                    cell.detailTextLabel.text = self.dataSourceContact.wiiAddress;
                }else if (indexPath.row==1){
                    cell.textLabel.text = [[self.dataSourceArray firstObject][indexPath.section-1][indexPath.row] valueForKey:@"title"];
                    cell.detailTextLabel.text = self.dataSourceContact.wiiSignature;
                }else{
                    cell.textLabel.text = [[self.dataSourceArray firstObject][indexPath.section-1][indexPath.row] valueForKey:@"title"];
                    cell.detailTextLabel.text = @"来自WiiChat号搜索";//***添加手机号搜索
                }
            }
            break;
        default:
            break;
    }
    self.tableViewCell = cell;
    return cell;
}


#pragma mark - help method
-(void)sendMessageToContact{
    NSLog(@"发送消息");
}
-(void)faceTimeWithContact{
    NSLog(@"视频通话");
}
-(void)addContactToUser{
    //****添加验证功能
    NSLog(@"添加到通讯录");
    User *user = [self.ContactInfoVCUserSource getUser];
    //数据源中将好友信息添加到该帐号中
    NSString *synchronousResult = [[AddContactHelper sharedAddContactHelper]synchronizeContactInfo:self.dataSourceContact toUser:user];
    if (![synchronousResult isEqualToString:@"同步contact信息至数据源成功"]) {
        self.alertController = [UIAlertController alertControllerWithTitle:@"同步至数据源失败" message:@"请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        //***添加错误报告
        [self.alertController addAction:cancelAction];
        [self presentViewController:self.alertController animated:YES completion:nil];
    }else{
        //同步数据源成功后 本地进行数据添加
    self.contactInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:user.managedObjectContext];
    [self copyInfoFromDataSource:self.dataSourceContact toContact:self.contactInfo];
    [user addContactObject:self.contactInfo];
    NSError *err;
    if ([user.managedObjectContext hasChanges]) {
        if (![user.managedObjectContext save:&err]) {
            NSLog(@"添加好友失败，Error:%@",err);
        }
    }
    NSLog(@"成功添加好友,ID:%@,name:%@",self.contactInfo.wiiID,self.contactInfo.wiiName);
    self.alertController = [UIAlertController alertControllerWithTitle:@"成功添加好友" message:[NSString stringWithFormat:@"%@已经是您的好友了",self.contactInfo.wiiName]
                                                        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sendMessageAction = [UIAlertAction actionWithTitle:@"立即发送消息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //****添加转入聊天界面
        [self.navigationController popViewControllerAnimated:YES];//返回搜索界面
    }];
    [self.alertController addAction:cancelAction];
    [self.alertController addAction:sendMessageAction];
    [self presentViewController:self.alertController animated:YES completion:nil];
    }
}

-(void)copyInfoFromDataSource:(AllUsers*)allUsers toContact:(Contact*)contact{
    contact.wiiID = allUsers.wiiID;
    contact.wiiName = allUsers.wiiName;
    contact.wiiHeadImg = allUsers.wiiHeadImg;
    contact.wiiSex = allUsers.wiiSex;
    contact.wiiEmail = allUsers.wiiEmail;
    contact.wiiSignature = allUsers.wiiSignature;
    contact.wiiAddress = allUsers.wiiAddress;
    //contact.wiiPhoto = allUsers.wiiPhoto;  需要时再加载
    contact.rowName = [Contact convertRowNameFromWiiName:contact.wiiName];
    contact.sectionName = [Contact convertSectionNameFromWiiName:contact.wiiName];

}

#pragma mark - UIStateRestoration

NSString *const ViewControllerUserKey = @"ViewControllerUserKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the dataSourceContact
    [coder encodeObject:self.dataSourceContact forKey:ViewControllerUserKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the dataSourceContact
    self.dataSourceContact = [coder decodeObjectForKey:ViewControllerUserKey];
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
