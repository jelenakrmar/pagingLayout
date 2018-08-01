//
//  ViewController.m
//  Paging Layout
//
//  Created by Jelena on 8/1/18.
//  Copyright © 2018 byteout. All rights reserved.
//

#import "ViewController.h"
#import "ProductCollectionViewCell.h"
#import "PagingLayout.h"

@interface ViewController ()

// 1. Setting up collection view and its data source
@property (strong, nonatomic) NSArray* productNames;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

// 2. Pagging layout
@property (nonatomic) CGSize cellSize;
@property (strong, nonatomic) PagingLayout *collectionViewLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. Setting up collection view and its data source
    self.productNames = @[@"catch", @"memory", @"shoot", @"fall", @"snake", @"flap", @"tennis", @"tetris", @"traps"];
    self.collectionView.backgroundColor = UIColor.clearColor; // Remove the background collor
    
    // 2. Paging
    [self.view layoutIfNeeded]; // Just making sure we will get appropriate sizes for collection view bounds
    CGFloat height = floor(self.view.frame.size.height * 0.5);
    self.cellSize = CGSizeMake(height * 0.8, height);
    self.collectionViewLayout = [PagingLayout layoutConfiguredWithCollectionView:self.collectionView itemSize:self.cellSize];
    
    [self initialOffset:0]; // 3. This can be changed to whatever initial item should be...
}

#pragma mark - 1. <UICollectionViewDataSource>

// Total number of displayed items.
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productNames.count;
}

// Cells.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ProductCollectionViewCell alloc] init];
    }
    
    cell.productImageView.image = [UIImage imageNamed:self.productNames[indexPath.row]];
    
    return cell;
}

# pragma mark - 3. Paging helpers

- (int)getCurrentPage {
    CGFloat pageWidth = self.cellSize.width + self.collectionViewLayout.minimumLineSpacing;
    CGFloat contentOffset = self.collectionView.contentOffset.x + self.collectionView.contentInset.left;
    
    return round(contentOffset / pageWidth);
}

// Select a product - change label text.
- (void)changeText:(long)currentPage {
    self.nameLabel.text = [self.productNames[currentPage] capitalizedString];
}

- (void)initialOffset:(int)n {
    self.collectionView.contentOffset = CGPointMake(- self.collectionView.contentInset.left + n * self.cellSize.width, 0);
    [self changeText:n];
}

#pragma mark - 3. <UIScrollViewDelegate>

// "Snap" to a product when scrolling ends.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self changeText:[self getCurrentPage]];
}

#pragma mark - 3. <UICollectionViewDelegate>

// When tapped on the left or right cell, move to it.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int currentPage = [self getCurrentPage];
    if (currentPage != indexPath.row) {
        CGPoint offset = CGPointMake(- self.collectionView.contentInset.left + indexPath.row * self.cellSize.width, 0);
        [self.collectionView setContentOffset:offset animated:YES];
        [self changeText:indexPath.row];
    }
}

@end
