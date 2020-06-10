//
//  ViewController.swift
//  OpenGLES-Samples
//
//  Created by BLU on 2020/06/10.
//  Copyright © 2020 BLU. All rights reserved.
//

import GLKit

class ViewController: GLKViewController {
    
    
    private let vertices: [Float] = [0.0, 0.5, 0.0,
                                     -0.5, -0.0, 0.0,
                                     0.5, -0.0, 0.0]
    private var context: CVEAGLContext?
    private var vbo = GLuint()
    private let effect = GLKBaseEffect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGL()
        
        // generate vbo
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(vertices.size()), vertices, GLenum(GL_STATIC_DRAW))
    }
    
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        // use shader
        effect.prepareToDraw()
        
        // enable attr
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.position.rawValue),
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Float>.size * 3), nil)
        
        // draw
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
    }
    
    private func setupGL() {
        context = EAGLContext(api: .openGLES3)
        
        if let view = self.view as? GLKView,
            let context = context {
            view.context = context
            EAGLContext.setCurrent(context)
        }
    }
    
}

extension Array {
    func size() -> Int {
        return count * MemoryLayout.size(ofValue: self.first)
    }
    
}
