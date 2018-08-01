//
//  PagingLayout.m
//  Paging Layout
//
//  Created by Jelena on 8/1/18.
//  Copyright © 2018 byteout. All rights reserved.
//

#import "PagingLayout.h"

// 2. Implementation of paging layout
@implementation PagingLayout

+ (PagingLayout *)layoutConfiguredWithCollectionView:(UICollectionView *)collectionView
                                            itemSize:(CGSize)itemSize {
    
    PagingLayout *layout = [PagingLayout new];
    collectionView.collectionViewLayout = layout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.itemSize = itemSize;
    layout.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    layout.sectionInset = UIEdgeInsetsZero;
    
    CGFloat inset = (collectionView.bounds.size.width - itemSize.width) / 2;
    collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    collectionView.contentOffset = CGPointMake(-inset, 0);
    collectionView.showsHorizontalScrollIndicator = NO;
    
    return layout;
}

#pragma mark - UICollectionViewLayout (UISubclassingHooks)

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGSize collectionViewSize = self.collectionView.bounds.size;
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2;
    CGRect proposedRect = CGRectMake(proposedContentOffset.x, 0, collectionViewSize.width, collectionViewSize.height);

    UICollectionViewLayoutAttributes *candidateAttributes;
    for (UICollectionViewLayoutAttributes *attributes in [self layoutAttributesForElementsInRect:proposedRect]) {
        if (attributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue; // Skip if they are not related to our cell.
        }

        if (!candidateAttributes) {
            candidateAttributes = attributes;
            continue;
        }

        if (fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes.center.x - proposedContentOffsetCenterX)) {
            candidateAttributes = attributes;
        }
    }

    proposedContentOffset.x = candidateAttributes.center.x - collectionViewSize.width / 2;
    CGFloat offset = proposedContentOffset.x - self.collectionView.contentOffset.x;

    if ((velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0)) {
        CGFloat pageWidth = self.itemSize.width + self.minimumLineSpacing;
        proposedContentOffset.x += velocity.x > 0 ? pageWidth : -pageWidth;
    }

    return proposedContentOffset;
}

@end
