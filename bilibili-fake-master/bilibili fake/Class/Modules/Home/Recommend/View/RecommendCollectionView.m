//
//  RecommendCollectionView.m
//  bilibili fake
//
//  Created by 翟泉 on 2016/8/5.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "RecommendCollectionView.h"

#import "RecommendHeaderView.h"
#import "RecommendFooterView.h"
#import "RecommendCollectionViewCell.h"
#import "RecommendAvCollectionViewCell.h"
#import "RecommendLiveCollectionViewCell.h"
#import "RecommendBangumiCollectionViewCell.h"


@interface RecommendCollectionView ()
<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@end

@implementation RecommendCollectionView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = CRed;
        self.backgroundView.backgroundColor = ColorWhite(247);
        [self registerClass:[RecommendCollectionViewCell class] forCellWithReuseIdentifier:@"Recommend"];
        [self registerClass:[RecommendAvCollectionViewCell class] forCellWithReuseIdentifier:@"RecommendAv"];
        [self registerClass:[RecommendLiveCollectionViewCell class] forCellWithReuseIdentifier:@"RecommendLive"];
        [self registerClass:[RecommendBangumiCollectionViewCell class] forCellWithReuseIdentifier:@"RecommendBangumi"];
        [self registerClass:[RecommendHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
        [self registerClass:[RecommendFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
    }
    return self;
}

- (void)setList:(NSArray<RecommendEntity *> *)list {
    _list = list;
    [self reloadData];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _handleDidSelectedItem ? _handleDidSelectedItem(indexPath) : NULL;
}



#pragma mark - UICollectionViewDataSource / Delegate

/**
 *  Number
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_list count];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_list[section].body count];
}

/**
 *  Size
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SSize.width, [RecommendHeaderView heightForRecommend:_list[section] width:SSize.width]);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SSize.width, [RecommendFooterView heightForBanner:_list[section].banner_bottom width:SSize.width]);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (SSize.width-15*3) / 2;
    return CGSizeMake(width, [RecommendCollectionViewCell heightForWidth:width]);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}


/**
 *  Cell
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Footer" forIndexPath:indexPath];
    }
    else {
        return NULL;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_list[indexPath.section].body[indexPath.row]._goto isEqualToString:@"av"]) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendAv" forIndexPath:indexPath];
    }
    else {
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"Recommend" forIndexPath:indexPath];
    }
}

/**
 *  Data
 */
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        ((RecommendHeaderView *)view).recommend = _list[indexPath.section];
        ((RecommendHeaderView *)view).onClickBannerItem = _onClickBannerItem;
    }
    else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        ((RecommendFooterView *)view).banner = _list[indexPath.section].banner_bottom;
        ((RecommendFooterView *)view).onClickBannerItem = _onClickBannerItem;
    }
    [super collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:indexPath];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(RecommendCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.body = _list[indexPath.section].body[indexPath.row];
    [super collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
}


@end
