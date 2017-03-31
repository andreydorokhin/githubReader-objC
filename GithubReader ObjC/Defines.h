//
//  Defines.h
//  GithubReader ObjC
//
//  Created by Dorokhin on 29.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//


#define CLIENT_ID                  @"37c7dd4f2a9b7ee2724d"
#define CLIENT_SECRET              @"30ee9a5ae957a00bcf003152c7d216b90f844f6d"

//after server changed
#define oClientBaseURLString       @"https://api.github.com"


#define APPDELEGATE                ((AppDelegate*)[UIApplication sharedApplication].delegate)

#define STORYBOARD                 [UIStoryboard storyboardWithName:@"Main" bundle: nil]

#define kOFFSET_FOR_KEYBOARD       80.0

#define Rgb2UIColor(r, g, b)       [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define HEIGHT_FOR_HEADER_SECTION  5.0

#define HEIGHT_FOR_ROW             100.0
