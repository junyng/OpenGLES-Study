//
//  DrawSquareViewController.swift
//  OpenGLES-Samples
//
//  Created by BLU on 2020/06/11.
//  Copyright © 2020 BLU. All rights reserved.
//

import GLKit

class DrawSquareViewController: GLKViewController {
    
    struct Vertex {
        let x: GLfloat
        let y: GLfloat
        let z: GLfloat
    }
    
    private let vertices: [Vertex] = [
        Vertex(x: 0.5, y: -0.5, z: 0.0),
        Vertex(x: 0.5, y: 0.5, z: 0.0),
        Vertex(x: -0.5, y: 0.5, z: 0.0),
        Vertex(x: -0.5, y: -0.5, z: 0.0)
    ]
    private let indices: [GLubyte] = [
        0, 1, 2,
        2, 3, 0
    ]
    private var context: CVEAGLContext?
    private var vbo = GLuint()
    private var ebo = GLuint()
    private let baseEffect = GLKBaseEffect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGL()
        
        // generate vbo
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertices.size(), vertices, GLenum(GL_STATIC_DRAW))
        
        // generate ebo
        glGenBuffers(1, &ebo)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count, indices, GLenum(GL_STATIC_DRAW))
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(1.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        baseEffect.prepareToDraw()
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.position.rawValue),
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size),
            UnsafeRawPointer(bitPattern: 0))
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
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
