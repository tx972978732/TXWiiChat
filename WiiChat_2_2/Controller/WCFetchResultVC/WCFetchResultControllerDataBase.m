//
//  WCFetchResultControllerDataBase.m
//  WiiChat_2_2
//
//  Created by 童煊 on 2016/10/3.
//  Copyright © 2016年 童煊. All rights reserved.
//

#import "WCFetchResultControllerDataBase.h"

@interface WCFetchResultControllerDataBase()
@property(nonatomic,strong)UITableView *tableView;
@end

NSString *const fetchResultControllerDBCellIdentifier = @"fetchResultControllerDBCellIdentifier";

@implementation WCFetchResultControllerDataBase

#pragma mark - life cycle
-(instancetype)initWithTableView:(UITableView*)tableView{
    self = [super init];
    if (self) {
        self.UIDataSourceArray = [[WCUIStoreManager sharedWCUIStoreManager]getRootContactUIDataSource];
        self.tableView = tableView;
        self.tableView.dataSource = self;
    }
    return  self;
}

-(void)dealloc{
    
}

- (void)setFetchResultController:(NSFetchedResultsController *)fetchResultController{
    _fetchResultController = fetchResultController;
    fetchResultController.delegate = self;
    [fetchResultController performFetch:NULL];

}

//#pragma mark - UITableViewController Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 4;
    }
    return self.fetchResultController.sections[section-1].numberOfObjects;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fetchResultController.sections.count+1;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fetchResultControllerDBCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fetchResultControllerDBCellIdentifier];
    }
    if (indexPath.section==0) {
        cell.imageView.image = [UIImage imageNamed:[self.UIDataSourceArray[indexPath.row] valueForKey:@"image"]];
        cell.textLabel.text = [self.UIDataSourceArray[indexPath.row] valueForKey:@"title"];
    }else{
        NSIndexPath *tempPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
        Contact *contact = [self.fetchResultController objectAtIndexPath:tempPath];
        cell.imageView.image = [UIImage imageWithData:contact.wiiHeadImg];
        cell.textLabel.text = contact.wiiName;
    }
    return cell;
}



- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }
    return self.fetchResultController.sections[section-1].indexTitle;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==_fetchResultController.sections.count) {
        NSString *result = [NSString stringWithFormat:@"%lu位联系人",_fetchResultController.fetchedObjects.count];
        return result;
    }else{
        return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return NO;
    }
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    if ([title isEqualToString:UITableViewIndexSearch])
//    {
//        [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
//        return NSNotFound;
//    }
//    else
//    {
//        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index]-1; // -1 添加了搜索标识
//    }

    return index;
}

//
//// Moving/reordering
//
//// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}
//
//// Index
//
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView __TVOS_PROHIBITED{
    return self.fetchResultController.sectionIndexTitles;
}// return list of section titles to display in section index view (e.g. "ABCD...Z#")
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index __TVOS_PROHIBITED{
//    
//}// tell table which section corresponds to section title/index (e.g. "B",1))
//
//// Data manipulation - insert and delete support
//
//// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
//// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}
//
//// Data manipulation - reorder / moving support
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
//    
//}
//
#pragma mark - NSFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{
    if (indexPath.section!=0) {
        switch (type) {
            case NSFetchedResultsChangeUpdate:
            {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                Contact *contact = [self.fetchResultController objectAtIndexPath:indexPath];
                cell.textLabel.text = contact.wiiName;
            }
                break;
                
            default:
                break;
        }
    }
}

/* Notifies the delegate of added or removed sections.  Enables NSFetchedResultsController change tracking.
 
	controller - controller instance that noticed the change on its sections
	sectionInfo - changed section
	index - index of changed section
	type - indicates if the change was an insert or delete
 
	Changes on section info are reported before changes on fetchedObjects.
 */
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    if (sectionIndex!=0) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            default:
                break;
        }
    }

}

/* Notifies the delegate that section and object changes are about to be processed and notifications will be sent.  Enables NSFetchedResultsController change tracking.
 Clients may prepare for a batch of updates by using this method to begin an update block for their view.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

/* Notifies the delegate that all section and object changes have been sent. Enables NSFetchedResultsController change tracking.
 Clients may prepare for a batch of updates by using this method to begin an update block for their view.
 Providing an empty implementation will enable change tracking if you do not care about the individual callbacks.
 */

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

/* Asks the delegate to return the corresponding section index entry for a given section name.	Does not enable NSFetchedResultsController change tracking.
 If this method isn't implemented by the delegate, the default implementation returns the capitalized first letter of the section name (seee NSFetchedResultsController sectionIndexTitleForSectionName:)
 Only needed if a section index is used.
 */

//- (nullable NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName API_AVAILABLE(macosx(10.12),ios(4.0)){
//    
//}
- (void)setPaused:(BOOL)paused
{
    _paused = paused;
    if (paused) {
        self.fetchResultController.delegate = nil;
    } else {
        self.fetchResultController.delegate = self;
        [self.fetchResultController performFetch:NULL];
        [self.tableView reloadData];
    }
}

@end
