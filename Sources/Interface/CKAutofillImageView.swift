//
//  CKAutofillImageView.swift
//  CKit
//
//  Created by CHU on 2017/2/14.
//
//

import Foundation

#if os(OSX)
    import AppKit
#endif

#if os(OSX)
    open class CKAutofillImageView: NSView {
        @IBInspectable var imageNamed: String = "" {
            didSet {
                imageView.image = NSImage(named: imageNamed)
            }
        }
        
        @IBInspectable var scrimColor: NSColor = .black {
            didSet {
                scrim.layer?.backgroundColor = scrimColor.cgColor
            }
        }
        
        @IBInspectable var scrimOpacity: Float = 0 {
            didSet {
                scrim.layer?.opacity = scrimOpacity
            }
        }
        @IBInspectable var scrimOpacityMin: Float = 0
        @IBInspectable var scrimOpacityMax: Float = 100
        
        public let imageView = NSImageView()
        private let scrim = NSView()
        private var originalSize: NSSize!
        private var aspectRatio: CGFloat!
        
        open override func awakeFromNib() {
            addSubview(imageView)
            imageView.frame = bounds
            imageView.setContentCompressionResistancePriority(NSLayoutPriorityDefaultLow, for: .horizontal)
            imageView.setContentCompressionResistancePriority(NSLayoutPriorityDefaultLow, for: .vertical)
            
            addSubview(scrim)
            scrim.wantsLayer = true
        }
        
        override open func layout() {
            super.layout()
            
            let size = bounds.size
            let sizeRatio = size.width / size.height
            if aspectRatio > sizeRatio {
                imageView.frame.size.height = size.height
                imageView.frame.size.width = size.height * aspectRatio
            } else {
                imageView.frame.size.width = size.width
                imageView.frame.size.height = size.width / aspectRatio
            }
            imageView.setFrameOrigin(NSPoint(x: -(imageView.frame.size.width - size.width) / 2, y: 0))
            
            scrim.frame.size = size
        }
        
        final func setImage(_ image: NSImage = NSImage()) {
            imageView.image = image
            
            originalSize = image.representations.first?.size
            aspectRatio = (originalSize?.width)! / (originalSize?.height)!
            layout()
        }
        
        final func scrim(lighter: Float) {
            var o = scrimOpacity - lighter
            if o < scrimOpacityMin {
                o = scrimOpacityMin
            }
            scrimOpacity = o
        }
        
        final func scrim(darker: Float) {
            var o = scrimOpacity + darker
            if o > scrimOpacityMax {
                o = scrimOpacityMax
            }
            scrimOpacity = o
        }
    }
#endif
