//
//  RepositoriesViewController.m
//  GithubReader ObjC
//
//  Created by Dorokhin on 30.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//

#import "RepositoriesViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Defines.h"
#import "AppDelegate.h"
#import "UserRepository.h"
#import "RepositoriesCell.h"
#import "SVProgressHUD.h"


@interface RepositoriesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UserRepository *userRepo;

@end

@implementation RepositoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self repositoriesRequest];
    
    self.view.backgroundColor = Rgb2UIColor(184, 238, 238);
    self.tableView.backgroundColor = Rgb2UIColor(184, 238, 238);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)repositoriesRequest {
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/users/%@/repos", APPDELEGATE.authUsername]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    if(error) {
                                                        NSLog(@"Error: %@", error);
                                                        
                                                        [SVProgressHUD dismiss];
                                                    }else {
                                                        if(responseObject && ((NSHTTPURLResponse*)response).statusCode == 200) {
                                                            
                                                            NSDictionary *dict = [NSDictionary dictionaryWithObject:responseObject forKey:@"Repository"];
                                                            self.userRepo = [UserRepository modelObjectWithDictionary:dict];
                                                            
                                                            [self.tableView reloadData];
                                                        }
                                                    }
                                                    
                                                    [SVProgressHUD dismiss];
                                                }];
    
    [dataTask resume];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.userRepo.repository.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEIGHT_FOR_HEADER_SECTION;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT_FOR_ROW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RepositoriesCellIdentifier";
    
    RepositoriesCell *cell = (RepositoriesCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"RepositoriesCell" bundle:nil] forCellReuseIdentifier:@"RepositoriesCellIdentifier"];
        cell = (RepositoriesCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    cell.layer.borderWidth = 1.f;
    cell.layer.cornerRadius = 5.f;
    cell.layer.borderColor = Rgb2UIColor(44, 165, 74).CGColor;

    cell.repoTitelLabel.text = [(NSArray*)[self.userRepo.repository valueForKey:@"name"] objectAtIndex:indexPath.section];
  
    if([[(NSArray*)[self.userRepo.repository valueForKey:@"description"] objectAtIndex:indexPath.section] isEqual: [NSNull null]]) {
        cell.repoDescriptionLabel.text = @"description is absent";
    }else {
        NSArray *listItems = [[(NSArray*)[self.userRepo.repository valueForKey:@"description"] objectAtIndex:indexPath.section] componentsSeparatedByString:@"description = \""];
        cell.repoDescriptionLabel.text = [[(NSString *)[listItems lastObject] componentsSeparatedByString:@"\"" ] firstObject];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    APPDELEGATE.selectedRepo = [self.userRepo.repository objectAtIndex:indexPath.section];
}

@end
