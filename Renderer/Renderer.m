@import simd;
@import MetalKit;

#import "Renderer.h"
#import "../Scene/Types/Uniforms.h"
#import "../Scene/Types/Sphere.h"
#import "../Scene/Types/Material.hpp"
#import "../Application/Config.h"

#import <simd/simd.h>

@implementation Renderer {
    id<MTLDevice> _device;

    id<MTLRenderPipelineState> _pipelineState;
    id<MTLCommandQueue> _commandQueue;
    id<MTLBuffer> _uniformBuffer;
    id<MTLBuffer> _sphereBuffer;
    
    vector_uint2 _viewportSize;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if(self) {
        NSError *error;

        _device = mtkView.device;

        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];

        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];

        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Simple Pipeline";
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;

        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                 error:&error];
                
        NSAssert(_pipelineState, @"Failed to create pipeline state: %@", error);

        _commandQueue = [_device newCommandQueue];
        
        _uniformBuffer = [_device newBufferWithLength:sizeof(Uniforms)
                                              options:MTLResourceStorageModeShared];

        // Create buffer for spheres
        Sphere spheres[MAX_SPHERES] = {
            { .center = {-1, 1.3, -1}, .radius = 1.2, .material = (Material){.color = {1, 0, 0}} },
            { .center = {1.5, 0.5, 1.0}, .radius = 1.8, .material = (Material){(vector_float3){1, 1, 1}} },
            { .center = {0, 12, 2}, .radius = 10, .material = (Material){(vector_float3){0, 1, 0}} },
            { .center = {-10, -10, 12}, .radius = 10, .material = (Material){.color = {0, 1, 0}, .emissionColor = {1,1,1}, .emissionStrength = 5} }
        };

        _sphereBuffer = [_device newBufferWithBytes:spheres
                                             length:sizeof(spheres)
                                            options:MTLResourceStorageModeShared];
    }

    return self;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;

    Uniforms uniforms;
    uniforms.viewportSize = (vector_float2){(float)size.width, (float)size.height};
    uniforms.scale = SCALE;
    uniforms.maxSpheres = MAX_SPHERES;

    memcpy(_uniformBuffer.contents, &uniforms, sizeof(Uniforms));
}

- (void)drawInMTKView:(nonnull MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"pathtracer";

    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;

    if(renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];

        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, 0.0, 1.0 }];
        [renderEncoder setRenderPipelineState:_pipelineState];

        // Bind uniform buffer to index 0
        [renderEncoder setFragmentBuffer:_uniformBuffer offset:0 atIndex:0];
        
        // Bind sphere buffer to index 1
        [renderEncoder setFragmentBuffer:_sphereBuffer offset:0 atIndex:1];

        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:3];

        [renderEncoder endEncoding];

        [commandBuffer presentDrawable:view.currentDrawable];
    }

    [commandBuffer commit];
}

@end
