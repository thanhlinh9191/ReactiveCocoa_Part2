//
//  RWTableViewCell.h
//  TwitterInstant
//
//  Created by THANHLINH on 9/06/15.
//  Copyright (c) 2015 THANHLINH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *twitterAvatarView;
@property (weak, nonatomic) IBOutlet UILabel *twitterStatusText;
@property (weak, nonatomic) IBOutlet UILabel *twitterUsernameText;
@end
