//
//  UserRepository.h
//  GithubReader ObjC
//
//  Created by Dorokhin on 30.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRepository : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *repository;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
