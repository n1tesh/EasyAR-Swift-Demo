//
//  ViewController.swift
//  ARVideoDemo
//
//  Created by Nitesh I on 19/08/17.
//  Copyright © 2017 Nitesh. All rights reserved.
//

import UIKit
import GLKit

class ViewController: UIViewController {

    private var glView: OpenGLView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let glkView = self.glView else {
            return
        }
        self.view = glkView
        
        self.glView?.setOrientation(self.interfaceOrientation)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.glView?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.glView?.stop()
    }

    override func loadView() {
        self.glView = OpenGLView(frame: CGRect.zero)
        self.view = glView
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        glView?.resize(view.bounds, orientation: interfaceOrientation)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        glView?.setOrientation(toInterfaceOrientation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

