// run me: clang++ sample.mm -framework AppKit -framework OpenGL -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk -o sample --std=c++11 && ./sample

#include <OpenGL/OpenGL.h>
#include "OpenGL/gl3.h"
#include "OpenGL/gl3ext.h"
#include <stdio.h>
#include <cassert>
#include <unistd.h>
#include <string.h>

int main() {
    CGLPixelFormatObj pixelFormatObj;
    GLint numPixelFormats = 1;
    CGLPixelFormatAttribute attrs[] = {kCGLPFAOpenGLProfile, (CGLPixelFormatAttribute)kCGLOGLPVersion_3_2_Core, kCGLPFADoubleBuffer, (CGLPixelFormatAttribute)0};
    CGLChoosePixelFormat(attrs, &pixelFormatObj, &numPixelFormats);
    CGLContextObj contextObj;
    CGLCreateContext(pixelFormatObj, NULL, &contextObj);
    CGLReleasePixelFormat(pixelFormatObj);
    CGLSetCurrentContext(contextObj);
    GLint level = 1;
    GLuint tex2;
    glGenTextures(1, &tex2);
    glBindTexture(GL_TEXTURE_2D, tex2);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, level);
    glTexImage2D(GL_TEXTURE_2D, level, GL_RGBA8, 2048, 2048, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glBindTexture(GL_TEXTURE_2D, 0);
    GLuint fbo2;
    glGenFramebuffers(1, &fbo2);
    glBindFramebuffer(GL_FRAMEBUFFER, fbo2);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, tex2, level);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE)
    {
      printf("Pass\n");
    }
    else
    {
      printf("Failure\n");
    }
    glDeleteFramebuffers(1, &fbo2);
    glDeleteTextures(1, &tex2);
    CGLReleaseContext(contextObj);
}
