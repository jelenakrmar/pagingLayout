//
//  ProductCollectionViewCell.m
//  Paging Layout
//
//  Created by Jelena on 8/1/18.
//  Copyright © 2018 byteout. All rights reserved.
//

#import "ProductCollectionViewCell.h"

@implementation ProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // 4. Prettify
    self.productImageView.layer.borderColor = [UIColor colorWithRed:69/255.0 green:170/255.0 blue:117/255.0 alpha:1.0].CGColor;
    self.productImageView.layer.borderWidth = 4;
    self.productImageView.layer.cornerRadius = 10;
}

@end
