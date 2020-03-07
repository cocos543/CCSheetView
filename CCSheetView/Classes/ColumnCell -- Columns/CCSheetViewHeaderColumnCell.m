//
//  CCSheetViewHeaderColumnCell.m
//  
//
//  Created by Cocos on 2020/3/4.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCSheetViewHeaderColumnCell.h"
#import "Masonry.h"

CCReuseIdentifierName * _Nonnull const CCSheetViewHeaderColumnCellReuseIdentifier = @"CCSheetViewHeaderColumnCellReuseIdentifier";

@interface CCSheetViewHeaderColumnCell () {
    BOOL _reuse;
}

@end

@implementation CCSheetViewHeaderColumnCell

- (void)prepareForReuse {
    [super prepareForReuse];
    _reuse = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!_reuse && newSuperview) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).offset(24);
            make.centerY.equalTo(self.contentView);
            make.trailing.equalTo(self.contentView).offset(2);
        }];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColor.lightGrayColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}


@end
