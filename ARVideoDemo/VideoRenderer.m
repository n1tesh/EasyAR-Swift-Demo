//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "VideoRenderer.h"

#include <OpenGLES/ES2/gl.h>

const char* box_video_vert="uniform mat4 trans;\n"
    "uniform mat4 proj;\n"
    "attribute vec4 coord;\n"
    "attribute vec2 texcoord;\n"
    "varying vec2 vtexcoord;\n"
    "\n"
    "void main(void)\n"
    "{\n"
    "    vtexcoord = texcoord;\n"
    "    gl_Position = proj*trans*coord;\n"
    "}\n"
    "\n"
;

const char* box_video_frag="#ifdef GL_ES\n"
    "precision highp float;\n"
    "#endif\n"
    "varying vec2 vtexcoord;\n"
    "uniform sampler2D texture;\n"
    "\n"
    "void main(void)\n"
    "{\n"
    "    gl_FragColor = texture2D(texture, vtexcoord);\n"
    "}\n"
    "\n"
;

@implementation VideoRenderer {
    unsigned int program_box;
    int pos_coord_box;
    int pos_tex_box;
    int pos_trans_box;
    int pos_proj_box;
    unsigned int vbo_coord_box;
    unsigned int vbo_tex_box;
    unsigned int vbo_faces_box;
    unsigned int texture_id;
}

- (void)init_ {
    program_box = glCreateProgram();
    GLuint vertShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertShader, 1, &box_video_vert, 0);
    glCompileShader(vertShader);
    GLuint fragShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragShader, 1, &box_video_frag, 0);
    glCompileShader(fragShader);
    glAttachShader(program_box, vertShader);
    glAttachShader(program_box, fragShader);
    glLinkProgram(program_box);
    glUseProgram(program_box);
    pos_coord_box = glGetAttribLocation(program_box, "coord");
    pos_tex_box = glGetAttribLocation(program_box, "texcoord");
    pos_trans_box = glGetUniformLocation(program_box, "trans");
    pos_proj_box = glGetUniformLocation(program_box, "proj");

    glGenBuffers(1, &vbo_coord_box);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_coord_box);
    const GLfloat cube_vertices[4][3] = {{1.0f / 2, 1.0f / 2, 0.f},{1.0f / 2, -1.0f / 2, 0.f},{-1.0f / 2, -1.0f / 2, 0.f},{-1.0f / 2, 1.0f / 2, 0.f}};
    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_vertices), cube_vertices, GL_DYNAMIC_DRAW);

    glGenBuffers(1, &vbo_tex_box);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_tex_box);
    const GLubyte cube_vertex_texs[4][2] = {{0, 0},{0, 1},{1, 1},{1, 0}};
    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_vertex_texs), cube_vertex_texs, GL_STATIC_DRAW);

    glGenBuffers(1, &vbo_faces_box);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vbo_faces_box);
    const GLushort cube_faces[] = {3, 2, 1, 0};
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(cube_faces), cube_faces, GL_STATIC_DRAW);

    glUniform1i(glGetUniformLocation(program_box, "texture"), 0);
    glGenTextures(1, &texture_id);
    glBindTexture(GL_TEXTURE_2D, texture_id);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

- (void)render:(easyar_Matrix44F *)projectionMatrix cameraview:(easyar_Matrix44F *)cameraview size:(easyar_Vec2F *)size {
    float size0 = [[size.data objectAtIndex:0] floatValue];
    float size1 = [[size.data objectAtIndex:1] floatValue];

    glBindBuffer(GL_ARRAY_BUFFER, vbo_coord_box);
    const GLfloat cube_vertices[4][3] = {{size0 / 2, size1 / 2, 0.f},{size0 / 2, -size1 / 2, 0.f},{-size0 / 2, -size1 / 2, 0.f},{-size0 / 2, size1 / 2, 0.f}};
    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_vertices), cube_vertices, GL_DYNAMIC_DRAW);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_DEPTH_TEST);
    glUseProgram(program_box);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_coord_box);
    glEnableVertexAttribArray(pos_coord_box);
    glVertexAttribPointer(pos_coord_box, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_tex_box);
    glEnableVertexAttribArray(pos_tex_box);
    glVertexAttribPointer(pos_tex_box, 2, GL_UNSIGNED_BYTE, GL_FALSE, 0, 0);

    float * cameraview_data = calloc(16, sizeof(float));
    float * projectionMatrix_data = calloc(16, sizeof(float));
    for (int i = 0; i < 16; i++) {
        cameraview_data[i] = [[cameraview.data objectAtIndex:i] floatValue];
    }
    for (int i = 0; i < 16; i++) {
        projectionMatrix_data[i] = [[projectionMatrix.data objectAtIndex:i] floatValue];
    }
    glUniformMatrix4fv(pos_trans_box, 1, 0, cameraview_data);
    glUniformMatrix4fv(pos_proj_box, 1, 0, projectionMatrix_data);
    free(cameraview_data);
    free(projectionMatrix_data);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vbo_faces_box);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture_id);
    glDrawElements(GL_TRIANGLE_FAN, 4, GL_UNSIGNED_SHORT, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (unsigned int)texid
{
    return texture_id;
}

@end
