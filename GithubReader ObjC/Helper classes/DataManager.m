//
//  DataManager.m
//  GithubReader ObjC
//
//  Created by Dorokhin on 30.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//

#import "DataManager.h"
#import <UIKit/UIKit.h>

@implementation DataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (DataManager *)sharedManager {
    static DataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    
    return manager;
}

- (void)printAllObjectsWithEntityName:(NSString *)entityName {
    NSFetchRequest* request = [self requestForName:entityName];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    NSLog(@"All objects for entity '%@' = %lu %@", entityName, (unsigned long)[resultArray count], resultArray);
}

- (void)deleteAllObjectsWithEntityName:(NSString *)entityName {
    NSFetchRequest* request = [self requestForName:entityName];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    
    for(NSManagedObject *object in resultArray) {
        [self.managedObjectContext deleteObject:object];
    }
    
    [self.managedObjectContext save:nil];
}

- (NSFetchRequest *)requestForName:(NSString *)entityName {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    return request;
}

- (NSArray *)fetchRequestEntity:(NSString *)entity {
    NSFetchRequest *fetchRequest = [self requestForName:entity];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //    NSManagedObject *runObject = nil;
    
    if(error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    }else {
        if (result.count > 0) {
            //            runObject = (NSManagedObject *)[result objectAtIndex:0];
        }
    }
    
    return result;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"GithubReader_ObjC"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
