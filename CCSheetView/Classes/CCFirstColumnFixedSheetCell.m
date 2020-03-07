//
//  CCFirstColumnFixedSheetCell.m
//  
//
//  Created by Cocos on 2020/3/2.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCFirstColumnFixedSheetCell.h"
#import "CCSheetViewColumnCell.h"
#import "Masonry.h"

CCReuseIdentifierName * _Nonnull const CCFirstColumnFixedSheetCellReuseIdentifier = @"CCFirstColumnFixedSheetCellReuseIdentifier";

@interface CCFirstColumnFixedSheetCell () {
    BOOL _reuse;
}

@end

@implementation CCFirstColumnFixedSheetCell
@dynamic contentItems;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // TODO:
        [self.collectionView registerClass:CCSheetViewColumnCell.class forCellWithReuseIdentifier:CCSheetViewColumnCellOneTextReuseIdentifier];
        [self.collectionView registerClass:CCSheetViewColumnCell.class forCellWithReuseIdentifier:CCSheetViewColumnCellDoubleTextReuseIdentifier];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _reuse = YES;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!_reuse && newSuperview) {
        if (self.columnWidths.count <= 0) {
            return;
        }
        if (!self.firstColumnContentView) {
            return;
        }
        
        if (self.contentItems.count <= 0) {
            return;
        }
        
        [self.contentView addSubview:self.firstColumnContentView];
        [self.firstColumnContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.centerY.height.equalTo(self.contentView);
            make.width.mas_equalTo(self.columnWidths[0]);
        }];
        
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.firstColumnContentView.mas_trailing);
            make.height.trailing.centerY.equalTo(self.contentView);
        }];
        
        self.firstColumnContentView.iconImgView.image = self.contentItems[0].icon;
        self.firstColumnContentView.titleLabel.attributedText = self.contentItems[0].title;
        
    }
}

- (UIView *)firstColumnContentView {
    if (!_firstColumnContentView) {
        UILabel *label = UILabel.new;
        _firstColumnContentView = CCFirstColumnView.new;
        [_firstColumnContentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_firstColumnContentView);
        }];
    }
    return _firstColumnContentView;
}


#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCFirstColumnFixedContentItem *item = self.contentItems[indexPath.item + 1];
    
    CCSheetViewColumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:item.identifier forIndexPath:indexPath];
    cell.firLabel.attributedText = item.texts[0];
    if ([item.identifier isEqualToString:CCSheetViewColumnCellDoubleTextReuseIdentifier]) {
        cell.secLabel.attributedText = item.texts[1];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 第一列不属于collectionView, 所以这里列数减1
    return self.columnWidths.count - 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 高度-1是为了确保cell的高度不要超过collectionView
    return CGSizeMake(self.columnWidths[indexPath.item + 1].doubleValue, self.frame.size.height - 1);
}

@end
