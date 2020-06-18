//
//  SquareTextureViewController.swift
//  OpenGLES-Samples
//
//  Created by BLU on 2020/06/15.
//  Copyright © 2020 BLU. All rights reserved.
//

import GLKit

class SquareTextureViewController: GLKViewController {
    
    struct Vertex {
        let x: GLfloat
        let y: GLfloat
        let z: GLfloat
        
        let r: GLfloat
        let g: GLfloat
        let b: GLfloat
        let a: GLfloat
        
        let u: GLfloat
        let v: GLfloat
    }
    private let vertices: [Vertex] = [
        Vertex(x: 0.5, y: 0.5, z: 0.0, r: 1.0, g: 0.0, b: 0.0, a: 0.0, u: 1.0, v: 1.0),
        Vertex(x: 0.5, y: -0.5, z: 0.0, r: 0.0, g: 1.0, b: 0.0, a: 0.0, u: 1.0, v: 0.0),
        Vertex(x: -0.5, y: -0.5, z: 0.0, r: 0.0, g: 0.0, b: 1.0, a: 0.0, u: 0.0, v: 0.0),
        Vertex(x: -0.5, y: 0.5, z: 0.0, r: 1.0, g: 1.0, b: 0.0, a: 0.0, u: 0.0, v: 1.0)
    ]
    private let indices: [GLubyte] = [
        0, 1, 2,
        2, 3, 0
    ]
    private var context: CVEAGLContext?
    private var vbo = GLuint()
    private var ebo = GLuint()
    private var texture = GLuint()
    private let baseEffect = GLKBaseEffect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGL()
        
        // setup texture
        guard let imagePath = Bundle.main.path(forResource: "dungeon", ofType: "png"),
            let image = UIImage(contentsOfFile: imagePath),
            let textureImage = image.cgImage else {
                return
        }
        let width = textureImage.width
        let height = textureImage.height

        let textureData = calloc(width * height * 4, MemoryLayout<GLubyte>.size)
        let spriteContext = CGContext(data: textureData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width * 4,
                                      space: textureImage.colorSpace!,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        spriteContext?.draw(textureImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        // generate texture buffer
        glGenTextures(1, &texture)
        glBindTexture(GLenum(GL_TEXTURE_2D), texture)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), textureData)
        
        // generate vbo
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertices.size(), vertices, GLenum(GL_STATIC_DRAW))
        
        // generate ebo
        glGenBuffers(1, &ebo)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count, indices, GLenum(GL_STATIC_DRAW))
        
        baseEffect.texture2d0.name = texture
        baseEffect.texture2d0.enabled = GLboolean(GL_TRUE)
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.position.rawValue),
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size),
            UnsafeRawPointer(bitPattern: 0))
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.color.rawValue))
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.color.rawValue),
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), UnsafeRawPointer(bitPattern: 3 * MemoryLayout<GLfloat>.size))
        
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue))
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.texCoord0.rawValue),
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), UnsafeRawPointer(bitPattern: 7 * MemoryLayout<GLfloat>.size))
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(1.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        baseEffect.prepareToDraw()
        
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
