//
//  CBTableViewCell.m
//  CBJsonModel
//
//  Created by 0xcb on 5/8/2017.
//  Copyright © 2017 changbiao. All rights reserved.
//

#import "CBTableViewCell.h"

@implementation CBTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
