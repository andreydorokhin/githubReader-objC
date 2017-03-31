//
//  Permissions.h
//  GithubReader ObjC
//
//  Created by Dorokhin on 30.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Permissions : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL admin;
@property (nonatomic, assign) BOOL push;
@property (nonatomic, assign) BOOL pull;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
