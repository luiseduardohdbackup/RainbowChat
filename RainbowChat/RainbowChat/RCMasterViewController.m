//
//  RCMasterViewController.m
//  RainbowChat
//
//  Created by レー フックダイ on 4/27/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "RCMasterViewController.h"
#import "RCAppDelegate.h"
#import "RCDetailViewController.h"
#import "RCWelcomeViewController.h"
#import "KeychainItemWrapper.h"
#import "RCUser.h"

@interface RCMasterViewController ()

@property (strong, nonatomic) RCUser *currentUser;
@property (nonatomic) NSMutableArray *friends;
//@property (nonatomic) NSNumber *lastRefreshTime;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation RCMasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"LoginViewController.ffInstance = %@", self.ffInstance);
    NSLog(@"[FatFractal main] = %@", [FatFractal main]);
    
	[self checkForAuthentication];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)checkForAuthentication {
    if (![RCAppDelegate checkForAuthentication]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        RCWelcomeViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        welcomeViewController.delegate = self;
        welcomeViewController.ffInstance = self.ffInstance;
        [self presentViewController:welcomeViewController animated:YES completion:nil];
    } else {
        [self userIsAuthenticatedFromAppDelegateOnLaunch];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/* Do not need this method now since we do not allow user to edit the table
- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
         // Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}
*/

#pragma mark - Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [[self.fetchedResultsController sections] count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//    return [sectionInfo numberOfObjects];
    return _friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // We do not allow user to edit the table.
    return NO;
}

/* Do not need this method now since we do not allow user to edit the table
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}
*/

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark - Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
# warning - Need to send a specific class of toFriend ( maybe RCUser?)
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        RCUser *toFriend = [_friends objectAtIndex:indexPath.row];
        [[segue destinationViewController] setToUser:toFriend];
        [[segue destinationViewController] setFfInstance:self.ffInstance];
    }
}

#pragma mark - Data fetch

- (void)fetchFromCoreData {
#warning Need to implement
    /*
     Fetch existing friends.
     Create a fetch request for the Event entity; add a sort descriptor; then execute the fetch.
     */
}

- (void)fetchChangesFromBackEnd {
#warning Need to implement
    // Fetch any friends that have been updated on the backend
    // Guide to query language is here: http://fatfractal.com/prod/docs/queries/
    // and full syntax reference here: http://fatfractal.com/prod/docs/reference/#query-language
    // Note use of the "depthGb" parameter - see here: http://fatfractal.com/prod/docs/queries/#retrieving-related-objects-inline
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
# warning - Need to send a specific class of toFriend ( maybe RCUser?)
    RCUser *friend = (RCUser*)[_friends objectAtIndex:indexPath.row];
    cell.textLabel.text = friend.nickname;
}

#pragma mark - WelcomeViewControllerDelegate Methods
-(void)userDidAuthenticate {
    NSLog(@"Main View Controller refreshTableAndLoadData");
}

#pragma mark - Public Methods
- (void)refresh {
    DBGMSG(@"%s", __func__);
}

- (void)userIsAuthenticatedFromAppDelegateOnLaunch {
    DBGMSG(@"%s", __func__);
    if ([self.ffInstance loggedInUser]) {
        self.currentUser = (RCUser*)[self.ffInstance loggedInUser];
        [self refreshTableAndLoadData];
    }
}

- (void)refreshTableAndLoadData {
    DBGMSG(@"%s", __func__);
    // Clean friends array
    if (_friends) {
        [_friends removeAllObjects];
        _friends = nil;
    }
    
    // Load from backend
    NSString *uri = [NSString stringWithFormat:@"/FFUser/(userName ne 'anonymous' and userName ne 'system' and guid ne '%@')", self.currentUser.guid];
    _friends = [NSMutableArray array];
    [self.ffInstance registerClass:[RCUser class] forClazz:@"FFUser"];
    [self.ffInstance getArrayFromUri:uri onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse) {
        if (theObj) {
            _friends = (NSMutableArray*)theObj;
            NSLog(@"first friend = %@", (RCUser*)[_friends firstObject]);
            self.title = self.currentUser.nickname;
            [self.tableView reloadData];
        }
    }];
}
- (IBAction)refreshButtonPressed:(id)sender {
    [self refreshTableAndLoadData];
}

- (IBAction)logoutButtonPressed:(id)sender {
    DBGMSG(@"%s", __func__);
    [self.ffInstance logout];
    // Clear keychain
    KeychainItemWrapper *keychainItem = [RCAppDelegate keychainItem];
    if ([keychainItem objectForKey:(__bridge id)(kSecAttrAccount)] != nil) {
        [keychainItem setObject:nil forKey:(__bridge id)(kSecAttrAccount)];
        [keychainItem setObject:nil forKey:(__bridge id)(kSecValueData)];
    }
    // Navigate to Welcome View Controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RCWelcomeViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    welcomeViewController.delegate = self;
    welcomeViewController.ffInstance = self.ffInstance;
    [self presentViewController:welcomeViewController animated:YES completion:nil];
}


/* We do not need a fetchedResultsController since we have the managedObjectContext
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
 */
/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */



@end
