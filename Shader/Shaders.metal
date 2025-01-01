#include <metal_stdlib>

using namespace metal;

#include "ShaderTypes.h"
#include "../Scene/Collision.h"

#define SCALE 200

struct RasterizerData {
    float4 position [[position]];
    float4 color;
};

struct Uniforms {
    float2 viewportSize;
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

fragment float4 fragmentShader(RasterizerData in [[stage_in]], constant Uniforms &uniforms [[buffer(0)]]) {
    float2 scaled = 2 * in.position.xy / SCALE;
    float3 pixelPoint = float3(scaled.x - uniforms.viewportSize.x / (SCALE),
                               scaled.y - uniforms.viewportSize.y / (SCALE),
                               -4);
    
    Ray ray;
    ray.origin = float3(0, 0, -10);
    ray.dir = normalize(pixelPoint - ray.origin);
    
    Sphere sphere;
    sphere.center = float3(0, 0, 0);
    sphere.radius = 1;
    
    Collision c = raySphereCollision(ray, sphere);
    
    return float4(c.didCollide, c.didCollide, c.didCollide, 1);
}

