//
//  Collision.metal
//  pathtracer
//
//  Created by Tyler on 12/31/24.
//  Copyright © 2024 Apple. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include "Collision.h"


Collision raySphereCollision(Ray ray, Sphere sphere) {
    Collision col;
    col.didCollide = false;
    
    float3 offset = ray.origin - sphere.center;
    
    float a = dot(ray.dir, ray.dir);
    float b = 2 * dot(offset, ray.dir);
    float c = dot(offset, offset) - sphere.radius * sphere.radius;
    
    float disc = b * b - 4 * a * c;
    
    if (disc >= 0) {
        float distance = (-b - sqrt(disc)) / (2 * a);
        
        if (distance >= 0) {
            col.didCollide = true;
            col.distance = distance;
            col.hitPosition = ray.origin + ray.dir * distance;
            col.normal = normalize(col.hitPosition - sphere.center);
        }
    }
    
    return col;
}
