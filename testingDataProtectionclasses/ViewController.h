//
//  ViewController.h
//  testingDataProtectionclasses
//
//  Created by Murphy on 20/03/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *savedTextField;

@property (weak, nonatomic) IBOutlet UITextField *savedCoreDataTextField;

@property (strong) NSManagedObject *contactdb;
@property (strong) NSMutableArray *coreDataStrings;


@end



