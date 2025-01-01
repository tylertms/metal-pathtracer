#include <metal_stdlib>
using namespace metal;

#include "../Scene/Collision.h"
#include "../Scene/Types/Uniforms.h"
#include "../Scene/Random.h"
#include "../Scene/Trace.h"
#include "../Application/Config.h"

struct RasterizerData {
    float4 position [[position]];
    float4 color;
};

vertex RasterizerData vertexShader(uint vertexID [[vertex_id]]) {
    RasterizerData out;
    
    float2 positions[3] = {
        float2(-1.0, -1.0),
        float2( 3.0, -1.0),
        float2(-1.0,  3.0)
    };
    
    out.position = vector_float4(positions[vertexID], 0.0, 1.0);
    out.color = vector_float4(1.0, 1.0, 1.0, 1.0);
    
    return out;
}

fragment float4 fragmentShader(
   RasterizerData in [[stage_in]],
   constant Uniforms &uniforms [[buffer(0)]],
   device const Sphere *spheres [[buffer(1)]]
) {
    
    float2 scaled = 2 * in.position.xy / uniforms.scale;
    float3 pixelPoint = float3(scaled.x - uniforms.viewportSize.x / (uniforms.scale),
                               scaled.y - uniforms.viewportSize.y / (uniforms.scale),
                               4);
    
    Ray ray;
    ray.origin = float3(0, 0, -10);
    ray.dir = normalize(pixelPoint - ray.origin);
    
    uint randomInput = in.position.y * uniforms.viewportSize.x + in.position.x;
    
    float3 totalLight = 0;
    for(int i = 0; i < RAYS_PER_PIXEL; i++) {
        totalLight += Trace(ray, spheres, &randomInput);
    }
    
    float3 pixelColor = totalLight / RAYS_PER_PIXEL;

    return float4(pixelColor, 1);
}

