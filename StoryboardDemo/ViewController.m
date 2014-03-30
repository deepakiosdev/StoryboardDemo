//
//  ViewController.m
//  StoryboardDemo
//
//  Created by Deepak on 08/03/14.
//  Copyright (c) 2014 Deepak. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIPopoverController *tableViewPopoverController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)addTableNumber:(id)sender {
}
- (IBAction)showPopOver:(id)sender {
   /* UIView *anchor = sender;
    UIViewController *viewControllerForPopover =
    [self.storyboard instantiateViewControllerWithIdentifier:@"yourIdentifier"];
    
    popover = [[UIPopoverController alloc]
               initWithContentViewController:viewControllerForPopover];
    [popover presentPopoverFromRect:anchor.frame
                             inView:anchor.superview
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];*/
    
   /* QuickNotesViewController *quickNotesContent = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickNotesContent"];
    quickNotesContent.selectionDelegate = self;
    quickNotesContent.selectedQuickNotes = [self.quickNotesTextView selectedQuickNotes];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:quickNotesContent];
    navController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    self.quickNotesPopoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
    self.quickNotesPopoverController.delegate = self;
    [self.quickNotesPopoverController presentPopoverFromRect:self.notesLabel.bounds inView:self.notesLabel permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];*/
    
    UIView *anchor = sender;
    TableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    
    self.tableViewPopoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
    [self.tableViewPopoverController presentPopoverFromRect:anchor.bounds inView:anchor.superview permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
