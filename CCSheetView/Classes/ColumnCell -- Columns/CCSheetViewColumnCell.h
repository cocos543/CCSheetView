//
//  CCSheetViewColumnCell.h
//  
//
//  Created by Cocos on 2020/3/2.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSheetViewTypes.h"

extern CCReuseIdentifierName * _Nonnull const CCSheetViewColumnCellOneTextReuseIdentifier;
extern CCReuseIdentifierName * _Nonnull const CCSheetViewColumnCellDoubleTextReuseIdentifier;

NS_ASSUME_NONNULL_BEGIN

@interface CCSheetViewColumnCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *firLabel;

@property (nonatomic, strong) UILabel *secLabel;
@end

NS_ASSUME_NONNULL_END
