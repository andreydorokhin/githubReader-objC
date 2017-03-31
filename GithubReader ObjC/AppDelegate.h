//
//  AppDelegate.h
//  GithubReader ObjC
//
//  Created by Dorokhin on 21.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "UAGithubEngine.h"
#import "UserRepositoryDataModels.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  UAGithubEngine: Wrapper classes for accessing GitHub API
 */
@property (retain, nonatomic) UAGithubEngine *engine;

/**
 *  Selected Repo
 */
@property (retain, nonatomic) Repository *selectedRepo;

/**
 *  Code returned by github.com as part of the OAuth
 */
@property (copy, nonatomic) NSString *authCode;

/**
 *  access-token for the authenticated user
 */
@property (copy, nonatomic) NSString *authAccessToken;

/**
 *  Authenticated user's name
 */
@property (copy, nonatomic) NSString *authUsername;

- (void)showMessage:(NSString *)message withTitle:(NSString *)title;

#pragma mark- App's Common Methods
- (NSString *)convertToJSONString:(id)response;

@end

