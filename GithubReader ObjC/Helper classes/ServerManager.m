//
//  ServerManager.m
//  GithubReader ObjC
//
//  Created by Dorokhin on 30.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//




#import "ServerManager.h"
#import <AFNetworking/AFNetworking.h>
#import "Defines.h"

#import "AppDelegate.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *requestSessionManager;

@end


@implementation ServerManager

+ (instancetype)sharedServerManager {
    static ServerManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] initWithBaseURL:[NSURL URLWithString:oClientBaseURLString]];
    });
    
    return manager;
}

+ (instancetype)sharedServerManagerWithURL:(NSString*)baseURL {
    static ServerManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    });
    
    return manager;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super init];
     
    if(self) {
        self.requestSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        self.requestSessionManager.requestSerializer  = [AFJSONRequestSerializer serializer];
        self.requestSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [self.requestSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [self.requestSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    }
    
    return self;
}

- (void)postRequestWithSubURL:(NSString *)subURL
             andParameters:(NSDictionary *)parametersDictionary
                 onSuccess:(void (^)(NSDictionary *))success
                 onFailure:(void (^)(NSDictionary *))failure
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [self.requestSessionManager POST:subURL
                          parameters:parametersDictionary
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                NSLog(@"success!");
                                 
                                if(success) {
                                    if([responseObject isKindOfClass:[NSDictionary class]]) {
                                        if([[responseObject objectForKey:@"status"] isKindOfClass:[NSString class]]) {
                                            if([[responseObject objectForKey:@"responsecode"] intValue] == 0 ) {
                                                success(responseObject);
                                            }else {
                                                failure([responseObject objectForKey:@"status"]);
                                            }
                                        }else {
                                            success(responseObject);
                                        }
                                    }else {
                                        success(responseObject);
                                    }

                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                }
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

                                    if(failure) {
                                        NSDictionary *dictionary;
                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;

                                        if([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                                            dictionary = [httpResponse allHeaderFields];
                                        }
                                        
                                        failure(dictionary);
                                    }
                            }];
}

- (void)getRequestWithSubURL:(NSString *)subURL
               andParameters:(NSDictionary *)parametersDictionary
                   onSuccess:(void (^)(NSDictionary *))success
                   onFailure:(void (^)(NSDictionary *))failure;
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.requestSessionManager GET:subURL
                          parameters:parametersDictionary
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 NSLog(@"success!");
                                 
                                 if(success) {
                                     if([responseObject isKindOfClass:[NSDictionary class]]) {
                                         if([[responseObject objectForKey:@"status"] isKindOfClass:[NSString class]]) {
                                             if([[responseObject objectForKey:@"responsecode"] intValue] == 0 ) {
                                                 success(responseObject);
                                             }else {
                                                 failure([responseObject objectForKey:@"status"]);
                                             }
                                         }else {
                                             success(responseObject);
                                         }
                                     }else {
                                         success(responseObject);
                                     }
                                     
                                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                 }
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                 
                                 if(failure) {
                                     NSDictionary *dictionary;
                                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
                                     
                                     if([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                                         dictionary = [httpResponse allHeaderFields];
                                     }
                                     
                                     failure(dictionary);
                                 }
                             }];
}

@end
