//
//  DataManager.h
//  GithubReader ObjC
//
//  Created by Dorokhin on 30.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

+ (DataManager *)sharedManager;

- (NSArray *)fetchRequestEntity:(NSString *)entity;
- (void)deleteAllObjectsWithEntityName:(NSString *)entityName;
- (void)printAllObjectsWithEntityName:(NSString *)entityName;


@end
