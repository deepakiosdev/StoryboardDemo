//
//  TableNumberViewController.m
//  StoryboardDemo
//
//  Created by Deepak on 09/03/14.
//  Copyright (c) 2014 Deepak. All rights reserved.
//

#import "TableNumberViewController.h"
#import "User.h"

static NSString * const kTableNumberCellIdentifier = @"TableNumberCell";

@interface TableNumberViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
    CGFloat kKeyBoardHeight;
}
@property (weak, nonatomic) IBOutlet UIView *textView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *rollNumbers;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;

@property (strong, nonatomic) NSMutableArray *insertedIndexPaths;
@property (strong, nonatomic) NSMutableArray *deletedIndexPaths;

@end

@implementation TableNumberViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"error performing fetch");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Register notification when keyboard will be show
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
    
	// Register notification when keyboard will be hide
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self
														name:UIKeyboardWillShowNotification
													  object:nil];
        
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:UIKeyboardWillHideNotification
													  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note
{
	// Get the keyboard size
	CGRect keyboardBounds;
    
	[[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    
	/*CGRect frame = self.tableView.frame;
    NSLog(@"tableView.frame:%@",NSStringFromCGRect(self.tableView.frame));
    NSLog(@"textView:%@",NSStringFromCGRect(self.textView.frame));

    if (self.textView.frame.origin.y > 700) {
        
        // Start animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        // Apply new size of table view

        frame.size.height = 740;
        self.tableView.frame = frame;
        [UIView commitAnimations];
    }*/
}


- (void)keyboardWillHide:(NSNotification *)note
{
	// Get the keyboard size
	/*CGRect keyboardBounds;
    
	[[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    
	CGRect frame = self.tableView.frame;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
    
    UIInterfaceOrientation orientation = [Util getOrientation];
    
    //increase size of view
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        frame.size.height = ViewHeightWithoutStatusBarAndNavigationBarLand;
    }
    else
    {
        frame.size.height = ViewHeightWithoutStatusBarAndNavigationBar;
    }
    
	// Apply new size of table view
	self.tableView.frame = frame;
    
	[UIView commitAnimations];*/
    
    
	CGRect frame = self.tableView.frame;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
    frame.size.height = 1064;
	// Apply new size of table view
	self.tableView.frame = frame;
    
	[UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSMutableArray *)insertedIndexPaths
{
    if (!_insertedIndexPaths)
    {
        _insertedIndexPaths = [[NSMutableArray alloc] init];
    }
    
    return _insertedIndexPaths;
}

- (NSMutableArray *)deletedIndexPaths
{
    if (!_deletedIndexPaths)
    {
        _deletedIndexPaths = [[NSMutableArray alloc] init];
    }
    
    return _deletedIndexPaths;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableNumberCellIdentifier];
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = user.rollNumber;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteNoteAtIndexPath:indexPath];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
// return NO to disallow editing.
{
    CGRect frame = self.tableView.frame;
    NSLog(@"tableView.frame:%@",NSStringFromCGRect(self.tableView.frame));
    NSLog(@"textView:%@",NSStringFromCGRect(self.textView.frame));
    
    if (self.textView.frame.origin.y > 700) {
        
        // Start animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        // Apply new size of table view
        
        frame.size.height = 740;
        self.tableView.frame = frame;
        [UIView commitAnimations];
    }

    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   /* UITableViewCell *cell = (UITableViewCell*)textField.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];*/
    
    /*CGRect textFieldRect = [self.tableView convertRect:self.activeTextField.bounds fromView:self.activeTextField];
    textFieldRect.size.height = textFieldRect.size.height + 35;
    [self.tableView scrollRectToVisible:textFieldRect animated:NO];*/
    [self addUser:textField.text];
    textField.text = @"";
    NSLog(@"tableView.frame:%@",NSStringFromCGRect(self.tableView.frame));
    NSLog(@"textView:%@",NSStringFromCGRect(self.textView.frame));
    
    if (self.textView.frame.origin.y > 700) {
        
        
        CGRect frame = self.tableView.frame;
        // Start animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        // Apply new size of table view
        
        frame.size.height = 740;
        self.tableView.frame = frame;
        [UIView commitAnimations];
        [self.tableView reloadData];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self addUser:textField.text];
    textField.text = @"";
    CGRect frame = self.tableView.frame;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
    frame.size.height = 1024;
	// Apply new size of table view
	self.tableView.frame = frame;
    
	[UIView commitAnimations];
}


#pragma mark -

- (void)addUser:(NSString *)rollNumber
{
    if ([rollNumber length] == 0)
    {
        return;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    User *user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    user.rollNumber = rollNumber;
    
    NSError *error;
    [context save:&error];
    
    [self.tableView reloadData];
}

- (void)deleteNoteAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    NSError *error;
    [context save:&error];
    
    [self.tableView reloadData];
}


#pragma mark - Core Data

/*- (NSManagedObjectContext *)managedObjectContext
{
    return [RKManagedObjectStore defaultStore].persistentStoreManagedObjectContext;

}*/

//Get database filename
- (NSString *)databaseFilename{
    return @"StoryboardDemo.sqlite";
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StoryboardDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[self databaseFilename]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %s, %@, %@", __FUNCTION__, error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}


- (NSFetchRequest *)fetchRequest
{
    if (!_fetchRequest)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"rollNumber" ascending:YES selector:@selector(localizedStandardCompare:)];

        [fetchRequest setSortDescriptors:@[sort]];
        _fetchRequest = fetchRequest;
    }
    return _fetchRequest;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        fetchedResultsController.delegate = self;
        _fetchedResultsController = fetchedResultsController;
        
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error])
        {
            NSLog(@"Error - %@", error);
        }
    }
    
    return _fetchedResultsController;
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeInsert)
    {
        [self.insertedIndexPaths addObject:newIndexPath];
    }
    else if (type == NSFetchedResultsChangeDelete)
    {
        [self.deletedIndexPaths addObject:indexPath];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:self.deletedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView insertRowsAtIndexPaths:self.insertedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView endUpdates];
    
    self.deletedIndexPaths = nil;
    self.insertedIndexPaths = nil;
}

@end
