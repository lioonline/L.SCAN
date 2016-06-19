//
//  MainTableViewCell.h
//  LSCAN
//
//  Created by Lee on 6/16/16.
//  Copyright © 2016 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideDeleteCell.h"
@interface MainTableViewCell : SlideDeleteCell
@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong)   UILabel *contentLabel;
@end
