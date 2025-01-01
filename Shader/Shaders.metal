#include <metal_stdlib>

using namespace metal;

#include "ShaderTypes.h"

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

fragment float4 fragmentShader(RasterizerData in [[stage_in]]) {
    // Return the interpolated color.
    return float4(1, 0, 1, 1);
}

