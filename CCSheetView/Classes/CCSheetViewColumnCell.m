//
//  CCSheetViewColumnCell.m
//  
//
//  Created by Cocos on 2020/3/2.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCSheetViewColumnCell.h"
#import "Masonry.h"

CCReuseIdentifierName * const CCSheetViewColumnCellOneTextReuseIdentifier = @"CCSheetViewColumnCellOneTextReuseIdentifier";

CCReuseIdentifierName * const CCSheetViewColumnCellDoubleTextReuseIdentifier = @"CCSheetViewColumnCellDoubleTextReuseIdentifier";

@interface CCSheetViewColumnCell () {
    BOOL _reuse;
}



@end

@implementation CCSheetViewColumnCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/// 这个方法只会在cell复用的时候被调用, CollectionViewCell类并没有提供一个类似TableViewCell的initWithStyle:reuseIdentifier:初始化方法, 所以没法根据不同的identifier来设置不同的UI.
/// 这里我只能在cell被添加到父视图上时, 再根据identifier设置UI
- (void)prepareForReuse {
    [super prepareForReuse];
    _reuse = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!_reuse && newSuperview) {
        if ([self.reuseIdentifier isEqualToString:CCSheetViewColumnCellOneTextReuseIdentifier]) {
            [self.contentView addSubview:self.firLabel];
            [self.firLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.equalTo(self.contentView).offset(12);
                make.trailing.equalTo(self.contentView).offset(0);
            }];
        }else if ([self.reuseIdentifier isEqualToString:CCSheetViewColumnCellDoubleTextReuseIdentifier]) {
            [self.contentView addSubview:self.firLabel];
            [self.firLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(12);
                make.top.equalTo(self.contentView).offset(12);
                make.trailing.equalTo(self.contentView).offset(0);
            }];
            
            [self.contentView addSubview:self.secLabel];
            [self.secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(12);
                make.top.equalTo(self.firLabel.mas_bottom).offset(10);
                make.trailing.equalTo(self.contentView).offset(0);
            }];
        }
    }
}

- (UILabel *)firLabel {
    if (!_firLabel) {
        _firLabel = UILabel.new;
        _firLabel.font = [UIFont systemFontOfSize:13];
        _firLabel.textColor = UIColor.lightGrayColor;
        _firLabel.textAlignment = NSTextAlignmentLeft;
        _firLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _firLabel;
}

- (UILabel *)secLabel {
    if (!_secLabel) {
        _secLabel = UILabel.new;
        _secLabel.font = [UIFont systemFontOfSize:13];
        _secLabel.textColor = UIColor.lightGrayColor;
        _secLabel.textAlignment = NSTextAlignmentLeft;
        _secLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _secLabel;
}

@end
