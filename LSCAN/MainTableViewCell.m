//
//  MainTableViewCell.m
//  LSCAN
//
//  Created by Lee on 6/16/16.
//  Copyright © 2016 Lee. All rights reserved.
//

#import "MainTableViewCell.h"
#import "Masonry.h"
#import "DateTools.h"
#import "UIColor+HexColor.h"
@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}


-(void)initCell {
    
    UIView*cellBgView =[ UIView   new];
    [self.contentView addSubview:cellBgView];
    __weak MainTableViewCell *weakself = self;
    [cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    cellBgView.backgroundColor = [UIColor grayColor];
    cellBgView.layer.cornerRadius = 6;
    cellBgView.clipsToBounds = YES;
    
    UILabel *dateLabel = [UILabel new];
    [cellBgView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellBgView.mas_left);
        make.top.equalTo(cellBgView.mas_top);
        make.bottom.equalTo(cellBgView.mas_bottom);
        make.width.equalTo(@40);
    }];
    dateLabel.backgroundColor = [UIColor brownColor];
    dateLabel.numberOfLines = 2;
    dateLabel.lineBreakMode = NSLineBreakByClipping;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    NSDate *date = [NSDate date];
    NSString *day = [NSString stringWithFormat:@"%ld",(long)date.day];
    NSString *hour = [NSString stringWithFormat:@"%ld",(long)date.hour];
    NSString *minute = [NSString stringWithFormat:@"%ld",(long)date.minute];
    _dateLabel = dateLabel;
    
    
    NSString *str = [NSString stringWithFormat:@"%@\n%@:%@",day,hour,minute];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, day.length)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(day.length, attStr.length - day.length)];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, attStr.length)];
    dateLabel.attributedText = attStr;
    
    
    
    UILabel *contentlabel = [UILabel new];
    [cellBgView addSubview:contentlabel];
    [contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateLabel.mas_right);
        make.top.equalTo(cellBgView.mas_top);
        make.right.equalTo(cellBgView.mas_right);
        make.bottom.equalTo(cellBgView.mas_bottom);
    }];
    contentlabel.backgroundColor = [UIColor colorWithHexColorString:@"#FFCC99"];
    _contentLabel = contentlabel;
    
    
    
   
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
