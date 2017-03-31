//
//  SearchingRepositoriesViewController.m
//  GithubReader ObjC
//
//  Created by Dorokhin on 31.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//

#import "SearchingRepositoriesViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Defines.h"
#import "AppDelegate.h"
#import "Repository.h"
#import "RepositoriesCell.h"
#import "ServerManager.h"
#import "SVProgressHUD.h"

NSString *const kRepository = @"Repository";

@interface SearchingRepositoriesViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTitleRepoLabel;

@property (strong, nonatomic) NSMutableArray *repositoriesArray;

@end

@implementation SearchingRepositoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Rgb2UIColor(184, 238, 238);
    self.tableView.backgroundColor = Rgb2UIColor(184, 238, 238);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.inputTitleRepoLabel resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismissKeyboard {
    [self.inputTitleRepoLabel resignFirstResponder];
}

- (void)repositoriesRequestByTitle:(NSString *)repoTitle {
    [SVProgressHUD showWithStatus:@"Loading..."];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/legacy/repos/search/%@", repoTitle]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                    if(error) {
                                                        NSLog(@"Error: %@", error);
                                                        [SVProgressHUD dismiss];
                                                    }else {
                                                        if(responseObject && ((NSHTTPURLResponse*)response).statusCode == 200) {
                                                            [self getRepositoriesFromDictionary:responseObject];
                                                            
                                                            [self.tableView reloadData];
                                                        }
                                                        
                                                        [SVProgressHUD dismiss];
                                                    }
                                                }];
    
    [dataTask resume];
}

- (void)getRepositoriesFromDictionary:(NSDictionary *)dict {
    if([dict isKindOfClass:[NSDictionary class]]) {
        NSObject *receivedRepository = [dict objectForKey:@"repositories"];
        NSMutableArray *parsedRepository = [NSMutableArray array];
        
        if([receivedRepository isKindOfClass:[NSArray class]]) {
            for(NSDictionary *item in (NSArray *)receivedRepository) {
                if([item isKindOfClass:[NSDictionary class]]) {
                    [parsedRepository addObject:[Repository modelObjectWithDictionary:item]];
                }
            }
        }else if ([receivedRepository isKindOfClass:[NSDictionary class]]) {
            [parsedRepository addObject:[Repository modelObjectWithDictionary:(NSDictionary *)receivedRepository]];
        }
        
        self.repositoriesArray = [NSMutableArray arrayWithArray:parsedRepository];
    }
}

#pragma mark -
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([AFNetworkReachabilityManager sharedManager].reachable) {
        [self repositoriesRequestByTitle:self.inputTitleRepoLabel.text];
    }else {
        [APPDELEGATE showMessage:@"Please Check Your Internet Connection And Try Again" withTitle:@"No Internet"];
    }
    
    return [textField resignFirstResponder];
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.repositoriesArray count];
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
    
    Repository *repo = [self.repositoriesArray objectAtIndex:indexPath.section];
    cell.repoTitelLabel.text = [repo valueForKey:@"name"];
    
    if([[repo valueForKey:@"description"] isEqual: [NSNull null]]) {
        cell.repoDescriptionLabel.text = @"description is absent";
    }else {
        NSArray *listItems = [[repo valueForKey:@"description"] componentsSeparatedByString:@"description = \""];
        cell.repoDescriptionLabel.text = [[(NSString *)[listItems lastObject] componentsSeparatedByString:@"\"" ] firstObject];
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

#pragma mark- UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    APPDELEGATE.selectedRepo = [self.repositoriesArray objectAtIndex:indexPath.section];
}

@end
