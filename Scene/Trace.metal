//
//  Trace.metal
//  pathtracer
//
//  Created by Tyler on 12/31/24.
//  Copyright © 2024 Apple. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include "Types/Ray.h"
#import "Collision.h"
#import "Random.h"
#import "../Application/Config.h"

float3 Trace(Ray ray, device const Sphere *spheres, thread uint *input) {
    float3 incomingLight = 0;
    float3 rayColor = 1;
    
    for (int i = 0; i <= MAX_BOUNCES; i++) {
        Collision col = closestCollision(ray, spheres, MAX_SPHERES);
        if (col.didCollide) {
            ray.origin = col.hitPosition;
            ray.dir = shaderRandomHemisphereDir(col.normal, input);
            
            Material material = col.material;
            float3 emittedLight = material.emissionColor * material.emissionStrength;
            incomingLight += emittedLight * rayColor;
            rayColor *= material.color;
        } else {
            break;
        }
    }
    
    return incomingLight;
}
