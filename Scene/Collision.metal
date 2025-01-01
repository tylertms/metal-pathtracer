//
//  Collision.metal
//  pathtracer
//
//  Created by Tyler on 12/31/24.
//  Copyright © 2024 Apple. All rights reserved.
//

#include "Collision.h"

#include <metal_stdlib>
using namespace metal;


Collision closestCollision(Ray ray, device const Sphere *spheres, uint maxSpheres) {
    Collision closest = Collision { .didCollide = false };
    closest.distance = INFINITY;
    
    for (uint i = 0; i < maxSpheres; i++) {
        Sphere sphere = spheres[i];
        Collision col = raySphereCollision(ray, sphere);
        
        if (col.didCollide && col.distance < closest.distance) {
            closest = col;
            closest.material = col.material;
        }
    }
    
    return closest;
}


Collision raySphereCollision(Ray ray, Sphere sphere) {
    Collision col;
    col.didCollide = false;
    
    float3 offset = ray.origin - sphere.center;
    
    float a = dot(ray.dir, ray.dir);
    float b = 2 * dot(offset, ray.dir);
    float c = dot(offset, offset) - sphere.radius * sphere.radius;
    
    float disc = b * b - 4 * a * c;
    
    if (disc >= 1e-4) {
        float distance = (-b - sqrt(disc)) / (2 * a);
        
        if (distance >= 1e-4) {
            col.didCollide = true;
            col.distance = distance;
            col.hitPosition = ray.origin + ray.dir * distance;
            col.normal = normalize(col.hitPosition - sphere.center);
            col.material = sphere.material;
        }
    }
    
    return col;
}
