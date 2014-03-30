//
//  TableViewController.m
//  StoryboardDemo
//
//  Created by Deepak on 08/03/14.
//  Copyright (c) 2014 Deepak. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *DoneButton;

@end

@implementation TableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.DoneButton.title = @"Save";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
