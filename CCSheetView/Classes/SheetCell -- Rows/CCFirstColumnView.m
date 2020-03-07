//
//  CCFirstColumnView.m
//
//
//  Created by Cocos on 2020/3/2.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCFirstColumnView.h"
#import "Masonry.h"

@implementation CCFirstColumnView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self).offset(16);
        }];

        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(69);
            make.trailing.equalTo(self).offset(-2);
            make.top.equalTo(self).offset(20);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel               = UILabel.new;
        _titleLabel.font          = [UIFont systemFontOfSize:13];
        _titleLabel.textColor     = UIColor.lightGrayColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = UIImageView.new;
    }
    return _iconImgView;
}

@end
