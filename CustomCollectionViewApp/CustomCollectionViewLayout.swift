//
//  CustomCollectionViewLayout.swift
//  CustomCollectionViewApp
//
//  Created by Tigran on 20.09.2018.
//  Copyright © 2018 Tigran. All rights reserved.
//

import UIKit

protocol CustomCollectionViewDelegate: class {
     func theNumberOfItemsInCollectionView() -> Int
    func getTitles() -> [String]
    func getTraitCollection() -> UITraitCollection
}

extension CustomCollectionViewDelegate {
    func heightForContentInItem(inCollectionView collectionView: UICollectionView, at indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

class CustomCollectionViewLayout: UICollectionViewLayout {
    fileprivate var numberOfColumns: Int {
        guard let traitCollection = delegate?.getTraitCollection() else {
            return 1
        }
        if traitCollection.horizontalSizeClass == .compact {
            return 1
        } else {
            if contentWidth <= 782 {
                return 2
            } else {
                return 3
            }
        }
    }
    fileprivate var cellPadding: CGFloat = 6
    
    weak var delegate: CustomCollectionViewDelegate?
    
    
    //An array to cache the calculated attributes
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    //For content size
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {return 0}
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    //Setting the content size
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        //We begin measuring the location of items only if the cache is empty
        guard cache.isEmpty == true, let collectionView = collectionView else {return}
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        
        //Getting the xOffset based on the column and column width
        
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat]()
        
        //For each item in a collection view
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            yOffset.append(2 * cellPadding)
            
            var maxSize = CGSize(width: 100, height: 100)
            let titlesArray = delegate?.getTitles().chunked(into: numberOfColumns)
            let index = item / numberOfColumns
            if let max = titlesArray![index].max(by: {$1.count > $0.count}) {
                maxSize.height = max.heightWithConstrainedWidth(width: columnWidth - 2 * cellPadding, font: UIFont.systemFont(ofSize: 24))
            }
            
            //Measuring the frame
            let height = cellPadding * 2 + maxSize.height
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            //Creating attributres for the layout and caching them
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(collectionView.frame.height, frame.maxY)
            
            yOffset[column] = yOffset[column] + (height - cellPadding)
            
            let numberOfItems = delegate?.theNumberOfItemsInCollectionView()
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
    }
    
    //Is called  to determine which items are visible in the given rect
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        //Loop through the cache and look for items in the rect
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    //The attributes for the item at the indexPath
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.bounds.height
    }
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
}
