//
//  ViewController.swift
//  pagination-collectionview
//
//  Created by Hendy Christianto on 26/04/18.
//  Copyright © 2018 Hendy Christianto. All rights reserved.
//

import UIKit

private struct Constants {
    static let SectionSpacing: CGFloat = 15
    static let NumberOfCellsInARow: CGFloat = 2
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak private var collectionView: UICollectionView!
    
    private var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    
    // MARK: - UI Setup
    private func configureUI() {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(Constants.SectionSpacing,
                                                                 Constants.SectionSpacing,
                                                                 Constants.SectionSpacing,
                                                                 Constants.SectionSpacing)
        collectionViewFlowLayout.itemSize = CustomCollectionViewCell.getSize()
        collectionViewFlowLayout.minimumLineSpacing = Constants.SectionSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = Constants.SectionSpacing
        collectionViewFlowLayout.scrollDirection = .horizontal
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.register(UINib(nibName: CustomCollectionViewCell.reuseIdentifier(),
                                      bundle: nil),
                                forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier())
    }
    
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier(), for: indexPath)
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let pageWidth = (CustomCollectionViewCell.getSize().width
            + Constants.SectionSpacing) * Constants.NumberOfCellsInARow
        
        currentPage = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)) + 1
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Immitate pagination for carousel
        let pageWidth = (CustomCollectionViewCell.getSize().width
            + Constants.SectionSpacing) * Constants.NumberOfCellsInARow
        let maxPage = Int((scrollView.contentSize.width / pageWidth)) - 1
        var newPage = currentPage
        
        if velocity.x == 0.0 {
            newPage = Int(floor((targetContentOffset.pointee.x - pageWidth / 2) / pageWidth)) + 1
        } else {
            newPage = velocity.x > 0.0 ? currentPage + 1 : currentPage - 1
            
            // Limit bottom of page is 0
            if newPage < 0 {
                newPage = 0
            }
            
            // Limit top of page
            if newPage > Int((scrollView.contentSize.width / pageWidth)) {
                newPage = Int(ceil((pageWidth + Constants.SectionSpacing) / pageWidth)) - 1
            }
        }
        
        if newPage == maxPage {
            targetContentOffset.pointee.x = scrollView.contentSize.width - UIScreen.main.bounds.size.width
        } else {
            targetContentOffset.pointee.x = CGFloat(newPage) * pageWidth
        }
    }
}

