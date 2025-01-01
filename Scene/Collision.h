//
//  Collision.h
//  pathtracer
//
//  Created by Tyler on 12/31/24.
//  Copyright © 2024 Apple. All rights reserved.
//

#ifndef Collision_h
#define Collision_h

#include "Types/Ray.h"
#include "Types/Sphere.h"

typedef struct {
    bool didCollide;
    float distance;
    float3 hitPosition;
    float3 normal;
    Material material;
} Collision;

Collision closestCollision(Ray ray, device const Sphere *spheres, uint maxSpheres);
Collision raySphereCollision(Ray ray, Sphere sphere);

#endif /* Collision_h */
