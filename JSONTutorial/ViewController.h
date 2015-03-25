//
//  ViewController.h
//  JSONTutorial
//
//  Created by Alvaro Zepina on 17/03/15.
//  Copyright (c) 2015 Alvaro Zetina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)btnRefresh:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tblEstudiantes;

@end

