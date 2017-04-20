//
//  ViewController.m
//  testingDataProtectionclasses
//
//  Created by Murphy on 20/03/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@interface ViewController ()


@end

@implementation ViewController

@synthesize contactdb;
@synthesize savedTextField;
@synthesize coreDataStrings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    savedTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"savedNSUserDefaults"];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TestStorage"];
    
    self.coreDataStrings = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"%s", &"Count of coreDataStrings" [ [coreDataStrings count]]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createFile:(id)sender {

    NSLog(@"Creating File With DataProtection -> ");
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    NSString *str = @"This is Demo\n";
    NSData *content = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *tmpFile = [tmpDirectory stringByAppendingPathComponent:@"newfile.txt"];
    
    if (![filemgr createFileAtPath:tmpFile contents: content attributes: [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey]])
    {
        NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                    message:NSLocalizedString(@"File created successfully.", )
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"File created");
}

- (IBAction)createKeychainData:(id)sender {
    NSLog(@"Creating Keychain entry With DataProtection -> ");
    //Let's create an empty mutable dictionary:
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    NSString *username = @"administrator";
    NSString *password = @"secret_password";
    NSString *website = @"http://www.example.com";
    
    //Populate it with the data and the attributes we want to use.
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked; // This item can only be accessed when the user unlocks the device.
    keychainItem[(__bridge id)kSecAttrServer] = website;
    keychainItem[(__bridge id)kSecAttrAccount] = username;
    
    //Check if this keychain item already exists.
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"The Item Already Exists", nil)
                                                        message:NSLocalizedString(@"Updated instead.", )
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        
    }else
    {
        keychainItem[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding]; //Our password
        
        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        NSLog(@"Error Code: %d", (int)sts);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                        message:NSLocalizedString(@"Keychain item created successfully.", )
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (IBAction)updateKeychainData:(id)sender {
    //Let's create an empty mutable dictionary:
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    NSString *username = @"administrator";
    NSString *password = @"secret_password_updated";
    NSString *website = @"http://www.example.com";
    
    //Populate it with the data and the attributes we want to use.
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked; // This item can only be accessed when the user unlocks the device.
    keychainItem[(__bridge id)kSecAttrServer] = website;
    keychainItem[(__bridge id)kSecAttrAccount] = username;
    
    //Check if this keychain item already exists.
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        //The item was found.
        
        //We can update the keychain item.
        
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        attributesToUpdate[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding];
        
        OSStatus sts = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
        NSLog(@"Error Code: %d", (int)sts);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                        message:NSLocalizedString(@"Keychain item updated successfully.", )
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Item Doesn't Exist.", nil)
                                                        message:NSLocalizedString(@"The item you want to update doesn't exist.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)deleteKeychainData:(id)sender {
    //Let's create an empty mutable dictionary:
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    NSString *username = @"administrator";
    NSString *website = @"http://www.example.com";
    
    //Populate it with the data and the attributes we want to use.
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword; // We specify what kind of keychain item this is.
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked; // This item can only be accessed when the user unlocks the device.
    keychainItem[(__bridge id)kSecAttrServer] = website;
    keychainItem[(__bridge id)kSecAttrAccount] = username;
    
    //Check if this keychain item already exists.
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr)
    {
        OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)keychainItem);
        NSLog(@"Error Code: %d", (int)sts);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                        message:NSLocalizedString(@"Keychain item deleted successfully.", )
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"The Item Doesn't Exist.", nil)
                                                        message:NSLocalizedString(@"The item doesn't exist. It may have already been deleted.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)saveDefaultString:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:savedTextField.text forKey:@"savedNSUserDefaults"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [defaults setInteger:1 forKey:@"NSUserDefaultsInt1"];
    
}
- (IBAction)getDefaultString:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userDefaults = [defaults objectForKey:@"savedNSUserDefaults"];
    NSInteger userNumber = [defaults integerForKey:@"NSUserDefaultsInt1"];
    NSLog(@"%@", [NSString stringWithFormat:@"NSUserDefault is: %@", userDefaults]);
    NSLog(@"%@", [NSString stringWithFormat:@"NSUserDefaultNumber is: %ld", (long)userNumber]);

}

- (IBAction)saveCoreDataString:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    if (self.contactdb) {
        // Update existing device
        [self.contactdb setValue:self.savedCoreDataTextField.text forKey:@"testString"];

        
    } else {
        // Create a new device
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"TestStorage" inManagedObjectContext:context];
        [newDevice setValue:self.savedCoreDataTextField.text forKey:@"testString"];

    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

                                
}
- (IBAction)getCoreDataString:(id)sender {
    
    
}

// MARK: For coredata

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}




@end
