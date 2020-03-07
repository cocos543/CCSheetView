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
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
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

@end
