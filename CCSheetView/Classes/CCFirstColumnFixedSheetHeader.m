//
//  CCFirstColumnFixedSheetHeader.m
//  
//
//  Created by Cocos on 2020/3/4.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCFirstColumnFixedSheetHeader.h"
#import "Masonry.h"

CCReuseIdentifierName * _Nonnull const CCFirstColumnFixedSheetHeaderReuseIdentifier = @"CCFirstColumnFixedSheetHeaderReuseIdentifier";

@interface CCFirstColumnFixedSheetHeader (){
    BOOL _reuse;
}

/// 首列视图, 该视图附带了一个标题
@property (nonatomic, strong) UIView *firstColumnView;
@end

@implementation CCFirstColumnFixedSheetHeader
@dynamic contentItems;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.collectionView registerClass:CCSheetViewHeaderColumnCell.class forCellWithReuseIdentifier:CCSheetViewColumnHeaderReuseIdentifier];
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _reuse = YES;
}

- (void)setColumnWidths:(NSArray<NSNumber *> *)columnWidths {
    [super setColumnWidths:columnWidths];
    
    if (columnWidths.count <= 0) {
        return;
    }
    
    [self.firstColumnView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.height.equalTo(self.contentView);
        // 系统默认会给HeaderView添加一条宽度为0的约束, 为了避免冲突,下面的约束需要设置较低优先级, 系统会自动调整好
        make.width.mas_equalTo(columnWidths[0]).priority(UILayoutPriorityDefaultHigh);
    }];
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.firstColumnView.mas_trailing);
        make.height.trailing.centerY.equalTo(self.contentView);
    }];
}

- (UIView *)firstColumnView {
    if (!_firstColumnView) {
        _firstColumnView = UIView.new;
        [self.contentView addSubview:_firstColumnView];
        [_firstColumnView addSubview:self.firstColumnTitleLabel];
        
        [self.firstColumnTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).priority(UILayoutPriorityDefaultHigh).offset(24);
            make.top.bottom.equalTo(self.contentView);
            make.trailing.equalTo(self.contentView).priority(UILayoutPriorityDefaultHigh).offset(-2);
        }];
        
    }
    return _firstColumnView;
}

- (UILabel *)firstColumnTitleLabel {
    if (!_firstColumnTitleLabel) {
        _firstColumnTitleLabel = UILabel.new;
        _firstColumnTitleLabel.font = [UIFont systemFontOfSize:14];
        _firstColumnTitleLabel.textColor = UIColor.lightGrayColor;
        _firstColumnTitleLabel.textAlignment = NSTextAlignmentLeft;
        _firstColumnTitleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _firstColumnTitleLabel;
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.contentItems[indexPath.item];
    NSAssert(text != nil, @"CCFirstColumnFixedContentItem can't not be nil");
    
    CCSheetViewHeaderColumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CCSheetViewColumnHeaderReuseIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = text;
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
