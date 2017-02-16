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
    public class CKAutofillImageView: NSView {
        @IBInspectable var imageNamed: String = "" {
            didSet {
                imageView.image = NSImage(named: imageNamed)
            }
        }
        
        @IBInspectable var scrimColor: String = "000000" {
            didSet {
                scrim.layer?.backgroundColor = NSColor(hex: scrimColor).cgColor
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
        
        public override func awakeFromNib() {
            addSubview(imageView)
            imageView.frame = bounds
            imageView.setContentCompressionResistancePriority(NSLayoutPriorityDefaultLow, for: .horizontal)
            imageView.setContentCompressionResistancePriority(NSLayoutPriorityDefaultLow, for: .vertical)
            
            addSubview(scrim)
            scrim.wantsLayer = true
        }
        
        override public func layout() {
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
        
        func setImage(_ image: NSImage = NSImage()) {
            imageView.image = image
            
            originalSize = image.representations.first?.size
            aspectRatio = (originalSize?.width)! / (originalSize?.height)!
            layout()
        }
        
        func scrim(lighter: Float) {
            var o = scrimOpacity - lighter
            if o < scrimOpacityMin {
                o = scrimOpacityMin
            }
            scrimOpacity = o
        }
        
        func scrim(darker: Float) {
            var o = scrimOpacity + darker
            if o > scrimOpacityMax {
                o = scrimOpacityMax
            }
            scrimOpacity = o
        }
    }
#endif
