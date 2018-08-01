//
//  PagingLayout.h
//  Paging Layout
//
//  Created by Jelena on 8/1/18.
//  Copyright © 2018 byteout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagingLayout : UICollectionViewFlowLayout


+ (PagingLayout *)layoutConfiguredWithCollectionView:(UICollectionView *)collectionView
                                            itemSize:(CGSize)itemSize;

@end
