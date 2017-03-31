//
//  RepositoriesCell.h
//  GithubReader ObjC
//
//  Created by Dorokhin on 31.03.17.
//  Copyright © 2017 Andrey Dorokhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface RepositoriesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *repoTitelLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoDescriptionLabel;

@end
