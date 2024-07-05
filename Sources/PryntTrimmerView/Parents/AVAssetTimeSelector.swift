//
//  AVAssetTimeSelector.swift
//  Pods
//
//  Created by Henry on 06/04/2017.
//
//

import UIKit
import AVFoundation

/// A generic class to display an asset into a scroll view with thumbnail images, and make the equivalence between a time in
// the asset and a position in the scroll view
public class AVAssetTimeSelector: UIView, UIScrollViewDelegate {

    let assetPreview = AssetVideoScrollView()

    /// The maximum duration allowed for the trimming. Change it before setting the asset, as the asset preview
    public var maxDuration: Double = 15 {
        didSet {
            assetPreview.maxDuration = maxDuration
        }
    }
    
    ///
    public var thumnailHeight: Double = 50 {
        didSet {
            assetPreview.thumnailHeight = thumnailHeight
        }
    }
   
    ///
    public var thumbnailWidth: Double = 50 {
        didSet {
            assetPreview.thumbnailWidth = thumbnailWidth
        }
    }
   
    public var asset: AVAsset? {
        didSet {
            assetDidChange(newAsset: asset)
        }
    }

    /// The asset to be displayed in the underlying scroll view. Setting a new asset will automatically refresh the thumbnails.
//    public var asset: AVAsset? {
//        didSet {
//            assetDidChange(newAsset: asset)
//        }
//    }
   

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    func setupSubviews() {
        setupAssetPreview()
        constrainAssetPreview()
    }

//    public func regenerateThumbnails(duration: Float) {
//        if let asset = asset {
//            assetPreview.regenerateThumbnails(for: asset, duration: duration)
//        }
//    }
    
    // MARK: - Asset Preview

    func setupAssetPreview() {
        self.translatesAutoresizingMaskIntoConstraints = false
        assetPreview.translatesAutoresizingMaskIntoConstraints = false
        assetPreview.delegate = self
        addSubview(assetPreview)
    }

    func constrainAssetPreview() {
        assetPreview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        assetPreview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        assetPreview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        assetPreview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

//    func assetDidChange(newAsset: AVAsset?) {
//        if let asset = newAsset {
//            assetPreview.regenerateThumbnails(for: asset)
//        }
//    }
    
    func assetDidChange(newAsset: AVAsset?) {
        if let asset = newAsset {
            assetPreview.regenerateThumbnails(for: asset, startTime: 0.0)
        }
    }

    // MARK: - Time & Position Equivalence

    var durationSize: CGFloat {
        return assetPreview.contentSize.width
    }

    func getTime(from position: CGFloat,duration: CMTime) -> CMTime? {
//        guard let asset = asset else {
//            return nil
//        }
        let normalizedRatio = max(min(1, position / durationSize), 0)
        let positionTimeValue = Double(normalizedRatio) * Double(duration.value)
        return CMTime(value: Int64(positionTimeValue), timescale: duration.timescale)
    }

//    func getPosition(from time: CMTime,duration: CMTime) -> CGFloat? {
//        guard let asset = asset else {
//            return nil
//        }
//        let timeRatio = CGFloat(time.value) * CGFloat(asset.duration.timescale) /
//            (CGFloat(time.timescale) * CGFloat(asset.duration.value))
//        return timeRatio * durationSize
//    }
    
    func getPosition(from time: CMTime,duration: CMTime) -> CGFloat? {
        guard let asset = asset else {
            return nil
        }
        let timeRatio = CGFloat(time.value) * CGFloat(asset.duration.timescale) /
            (CGFloat(time.timescale) * CGFloat(asset.duration.value))
        return timeRatio * durationSize
    }
}
