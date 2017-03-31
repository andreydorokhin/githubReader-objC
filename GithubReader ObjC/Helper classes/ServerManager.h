//
//  ServerManager.h
//  GithubReader ObjC
//
//  Created by Dorokhin on 30.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServerManager : NSObject


+ (instancetype)sharedServerManager;
+ (instancetype)sharedServerManagerWithURL:(NSString*)baseURL;

- (void)postRequestWithSubURL:(NSString *)subURL
             andParameters:(NSDictionary *)parametersDictionary
                 onSuccess:(void (^)(NSDictionary *))success
                    onFailure:(void (^)(NSDictionary *))failure;

- (void)getRequestWithSubURL:(NSString *)subURL
                andParameters:(NSDictionary *)parametersDictionary
                    onSuccess:(void (^)(NSDictionary *))success
                    onFailure:(void (^)(NSDictionary *))failure;

@end
