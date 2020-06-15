//
//  CubeViewController.swift
//  OpenGLES-Samples
//
//  Created by BLU on 2020/06/14.
//  Copyright © 2020 BLU. All rights reserved.
//

import GLKit

class CubeViewController: GLKViewController {
    
    struct Vertex {
        let x: GLfloat
        let y: GLfloat
        let z: GLfloat
        
        let r: GLfloat
        let g: GLfloat
        let b: GLfloat
        let a: GLfloat
    }
    
    private let vertices: [Vertex] = [
        Vertex(x: 1, y: -1, z: 1,   r: 1, g: 0, b: 0, a: 1),
        Vertex(x: 1,  y: 1, z: 1,   r: 1, g: 0, b: 0, a: 1),
        Vertex(x: -1, y: 1, z: 1,   r: 0, g: 1, b: 0, a: 1),
        Vertex(x: -1, y: -1, z: 1,   r: 0, g: 1, b: 0, a: 1),
        
        Vertex(x: -1, y: -1, z: -1,   r: 1, g: 0, b: 0, a: 1),
        Vertex(x: -1, y: 1, z: -1,   r: 1, g: 0, b: 0, a: 1),
        Vertex( x: 1, y: 1, z: -1,   r: 0, g: 1, b: 0, a: 1),
        Vertex( x: 1, y: -1, z: -1,   r: 0, g: 1, b: 0, a: 1)
    ]
    private let indices: [GLubyte] = [
        0, 1, 2,
        2, 3, 0,
        
        4, 5, 6,
        6, 7, 4,
        
        3, 2, 5,
        5, 4, 3,
        
        7, 6, 1,
        1, 0, 7,
        
        1, 6, 5,
        5, 2, 1,
        
        3, 4, 7,
        7, 0, 3
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
        
        let aspect = fabsf(Float(view.bounds.size.width) / Float(view.bounds.size.height))
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 4.0, 10.0)
        baseEffect.transform.projectionMatrix = projectionMatrix
        var modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -6.0)
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(45), GLKMathDegreesToRadians(45), 0, 1)
        baseEffect.transform.modelviewMatrix = modelViewMatrix
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        baseEffect.prepareToDraw()
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.position.rawValue),
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), UnsafeRawPointer(bitPattern: 0))
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.color.rawValue))
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.color.rawValue),
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), UnsafeRawPointer(bitPattern: 3 * MemoryLayout<GLfloat>.size))
        
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
