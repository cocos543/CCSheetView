//
//  CCFirstColumnFixedSheetCell.m
//  
//
//  Created by Cocos on 2020/3/2.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCFirstColumnFixedSheetCell.h"
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
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _reuse = YES;
}

// 注意, reloadData时, 该方法不会被调用. 该方法在Cell被dequeue创建的时候就会被调用. 因为布局子界面需要firstItem等参数, 所以不能在该方法布局界面
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!_reuse && newSuperview) {
        
    }
}


- (CCFirstColumnView *)firstColumnView {
    if (!_firstColumnView) {
        _firstColumnView = CCFirstColumnView.new;
        [self.contentView addSubview:_firstColumnView];
    }
    return _firstColumnView;
}

- (void)setFirstItem:(CCFirstColumnFixedFirstItem *)firstItem {
    _firstItem = firstItem;
    self.firstColumnView.iconImgView.image = self.firstItem.icon;
    self.firstColumnView.titleLabel.attributedText = self.firstItem.title;
}

- (void)setColumnWidths:(NSArray<NSNumber *> *)columnWidths {
    [super setColumnWidths:columnWidths];
    
    if (columnWidths.count <= 0) {
        return;
    }
    
    [self.firstColumnView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.height.equalTo(self.contentView);
        make.width.mas_equalTo(columnWidths[0]);
    }];
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.firstColumnView.mas_trailing);
        make.height.trailing.centerY.equalTo(self.contentView);
    }];
}


#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCFirstColumnFixedContentItem *item = self.contentItems[indexPath.item];
    NSAssert(item != nil, @"CCFirstColumnFixedContentItem can't not be nil");
    
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
    // height-1是为了确保cell的高度不要超过collectionView
    return CGSizeMake(self.columnWidths[indexPath.item + 1].doubleValue, self.frame.size.height - 1);
}

@end
