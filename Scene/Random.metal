//
//  Random.metal
//  pathtracer
//
//  Created by Tyler on 12/31/24.
//  Copyright © 2024 Apple. All rights reserved.
//

#include "Random.h"

#include <metal_stdlib>
using namespace metal;

float shaderRandom(thread uint *input) {
    uint state = *input * 747796405u + 2891336453u;
    uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
    *input = (word >> 22u) ^ word;
    return (float)*input / UINT_MAX;
}

float shaderRandomNormal(thread uint *input) {
    float theta = 2 * M_PI_F * shaderRandom(input);
    float rho = sqrt(-2 * log(shaderRandom(input)));
    return rho * cos(theta);
}

float3 shaderRandomDir(thread uint *input) {
    float x = shaderRandomNormal(input);
    float y = shaderRandomNormal(input);
    float z = shaderRandomNormal(input);
    return normalize(float3(x, y, z));
}

float3 shaderRandomHemisphereDir(float3 normal, thread uint *input) {
    float3 dir = shaderRandomDir(input);
    return dir * sign(dot(normal, dir));
}
