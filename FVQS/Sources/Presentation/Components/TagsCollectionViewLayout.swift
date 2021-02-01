import Foundation
import UIKit

class TagsCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    // MARK: Public
    
    var tagWidthProvider: ((Int) -> CGFloat)?
    var lineSpacing = CGFloat(10)
    var interitemSpacing = CGFloat(10)
    var tagHeight = CGFloat(32)
    
    // MARK: Private
    private let defaultTagWidth = CGFloat(120)
    private var attributes: [UICollectionViewLayoutAttributes] = []
        
    //MARK: - UICollectionViewLayout
    
    override public func prepare() {
        attributes.removeAll()
        setupLayout()
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.row < attributes.count else { return nil }
        return attributes[indexPath.row]
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.filter { rect.intersects($0.frame) }
    }

    override public var collectionViewContentSize: CGSize {
        let width = collectionViewWidth
        let height = attributes.last?.frame.maxY ?? 0
        return CGSize(width: width, height: height)
    }
    
    //MARK: - Helpers
    
    private var tagsCount: Int {
        guard collectionView?.numberOfSections == 1 else { return 0 }
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    private var collectionViewWidth: CGFloat {
        guard let collectionView = collectionView  else { return 0 }
        return collectionView.frame.inset(by: collectionView.contentInset).width
    }
    
    private func setupLayout() {
        var lastTagOriginY = CGFloat(0)
        var lastTagMaxX = CGFloat(0)
        
        (0 ..< tagsCount).forEach { index in
            let tagWidth = min(tagWidthProvider?(index) ?? defaultTagWidth, collectionViewWidth)
            let indexPath = IndexPath(item: index, section: 0)
            
            var tagFrame = CGRect(origin: .zero, size: CGSize(width: tagWidth, height: tagHeight))
            if needMoveToNextRow(lastTagMaxX: lastTagMaxX, tagWidth: tagWidth) {
                lastTagOriginY += tagHeight + lineSpacing
                lastTagMaxX = 0
            }
            
            tagFrame.origin = CGPoint(x: lastTagMaxX, y: lastTagOriginY)
            
            lastTagMaxX = tagFrame.maxX + interitemSpacing
            
            let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttribute.frame = tagFrame
            
            attributes.append(layoutAttribute)
        }
    }
    
    private func needMoveToNextRow(lastTagMaxX: CGFloat, tagWidth: CGFloat) -> Bool {
        return lastTagMaxX + interitemSpacing + tagWidth > collectionViewWidth
    }
}
