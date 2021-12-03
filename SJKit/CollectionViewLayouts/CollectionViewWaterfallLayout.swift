//
//  CollectionViewWaterfallLayout.swift
//  SJKit
//
//  Created by shijia.chen on 2021/9/10.
//

import Foundation
import UIKit

public protocol CollectionViewWaterfallLayoutDelegate: AnyObject {
    
    func collectionView(_ collectionView: UICollectionView, numberOfColumnCountInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallLayout, heightForItemAt indexPath: IndexPath, withWidth itemWidth: CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallLayout, insetForSectionAt section: Int) -> UIEdgeInsets
}

public extension CollectionViewWaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewWaterfallLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

public class CollectionViewWaterfallLayout: UICollectionViewLayout {
    
    public weak var delegate: CollectionViewWaterfallLayoutDelegate?
    
    private var attributesArray: [UICollectionViewLayoutAttributes] = []
    private var columnHeights: [CGFloat] = []
    
    private var contentHeight: CGFloat = 0
    private var columnCount: Int = 1
    private var sectionInsets: UIEdgeInsets = .zero
}

// MARK: override method
extension CollectionViewWaterfallLayout {
    
    public override func prepare() {
        super.prepare()
        
        attributesArray.removeAll()
        columnHeights.removeAll()
        
        contentHeight = 0
        columnCount = 1
        sectionInsets = .zero

        guard let collectionView = collectionView, collectionView.bounds.width > 0, collectionView.numberOfSections > 0 else {
            return
        }
        
        (0..<collectionView.numberOfSections).forEach { section in
            columnCount = delegate?.collectionView(collectionView, numberOfColumnCountInSection: section) ?? 1
            guard columnCount > 0 else {
                return
            }
            
            sectionInsets = delegate?.collectionView(collectionView, layout: self, insetForSectionAt: section) ?? .zero
            
            // header
            if let header = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)) {
                attributesArray.append(header)
            }
            
            columnHeights.removeAll()
            for _ in 0..<columnCount {
                columnHeights.append(contentHeight)
            }
            // cell
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                if let attributs = layoutAttributesForItem(at: IndexPath(item: item, section: section)) {
                    attributesArray.append(attributs)
                }
            }
            
            // footer
            if let footer = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: section)) {
                attributesArray.append(footer)
            }
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        attributesArray
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        let lineSpacing = delegate?.collectionView(collectionView, layout: self, minimumLineSpacingForSectionAt: indexPath.section) ?? 0
        let columnSpacing = delegate?.collectionView(collectionView, layout: self, minimumInteritemSpacingForSectionAt: indexPath.section) ?? 0
        
        let width = collectionView.bounds.size.width - sectionInsets.left - sectionInsets.right
        var itemWidth = (width - CGFloat(columnCount - 1) * columnSpacing) / CGFloat(columnCount)
        var itemHeight: CGFloat = 0.0
        if itemWidth > 0 {
            itemHeight = delegate?.collectionView(collectionView, layout: self, heightForItemAt: indexPath, withWidth: itemWidth) ?? 0.0
        } else {
            itemWidth = 0
        }
        let shortest = shortestColumn()
        let offsetX = sectionInsets.left + (itemWidth + columnSpacing) * CGFloat(shortest.index)
        let offsetY = shortest.height + (indexPath.row < columnCount ? 0 : lineSpacing)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: offsetX, y: offsetY, width: itemWidth, height: itemHeight)
        
        columnHeights[shortest.index] = attributes.frame.maxY
        contentHeight = longestColumn()
        return attributes
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        let headerSize = delegate?.collectionView(collectionView, layout: self, referenceSizeForHeaderInSection: indexPath.section) ?? .zero
        let footerSize = delegate?.collectionView(collectionView, layout: self, referenceSizeForFooterInSection: indexPath.section) ?? .zero
        
        var attribute: UICollectionViewLayoutAttributes?
        if elementKind == UICollectionView.elementKindSectionHeader, headerSize.width > 0, headerSize.height > 0 {
            attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
            attribute?.frame = CGRect(x: 0, y: contentHeight, width: headerSize.width, height: headerSize.height)
            contentHeight += headerSize.height
            contentHeight += sectionInsets.top
            
        } else if elementKind == UICollectionView.elementKindSectionFooter, footerSize.width > 0, footerSize.height > 0 {
            attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
            contentHeight += sectionInsets.bottom
            attribute?.frame = CGRect(x: 0, y: contentHeight, width: footerSize.width, height: footerSize.height)
            contentHeight += footerSize.height
            
        }
        return attribute
    }
    
    public override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        return CGSize(width: collectionView.frame.size.width, height: contentHeight)
    }
}
 
extension CollectionViewWaterfallLayout {
    
    func shortestColumn() -> (index: Int, height: CGFloat) {
        var columnIndex = 0, shortestHeight = CGFloat(MAXFLOAT)
        for (index, height) in columnHeights.enumerated() where height < shortestHeight {
            shortestHeight = height
            columnIndex = index
        }
        return (index: columnIndex, height: shortestHeight)
    }
    
    func longestColumn() -> CGFloat {
        columnHeights.max() ?? 0.0
    }
}
