////
////  OpenGLView.swift
////  ARVideoDemo
////
////  Created by Nitesh I on 19/08/17.
////  Copyright © 2017 Nitesh. All rights reserved.
////
//
//import UIKit
//
//class OpenGLView: GLKView {
//
//    private var initialized: Bool = false
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.frame.size.height = max(frame.size.width, frame.size.height)
//        self.frame.size.width = self.frame.size.height
//        initialized = false
//        context = EAGLContext(api: EAGLRenderingAPI.openGLES2)
//        drawableColorFormat = .RGBA8888
//        drawableDepthFormat = GLKViewDrawableDepthFormat.format24
//        bindDrawable()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//        if initialized{
//            initGL()
//            initialized = true
//        }
//        render()
//    }
//    
//    func start(){
//        if initialized{
//            start()
//        }
//    }
//    
//    func stop(){
//        stop()
//        finalize() // No longer needed in Swift.
//    }
//    
//    func resize(_ frame: CGRect, orientation: UIInterfaceOrientation) {
//        let scale = UIScreen.main.nativeScale
//        resizeGL(Int32(frame.size.width * scale), Int32(frame.size.height * scale))
//    }
//    
//    func setOrientation(_ orientation: UIInterfaceOrientation) {
//        switch orientation {
//        case .portrait:
//            easyar_Engine.setRotation(270)
//        case .portraitUpsideDown:
//            easyar_Engine.setRotation(90)
//        case .landscapeLeft:
//            easyar_Engine.setRotation(180)
//        case .landscapeRight:
//            easyar_Engine.setRotation(0)
//        default:
//            break
//        }
//        
//    }
//    
//    
//}
