//
//  Collision.h
//  pathtracer
//
//  Created by Tyler on 12/31/24.
//  Copyright © 2024 Apple. All rights reserved.
//

#ifndef Collision_h
#define Collision_h

#include "Objects/Ray.h"
#include "Objects/Sphere.h"

typedef struct {
    bool didCollide;
    float distance;
    float3 hitPosition;
    float3 normal;
} Collision;

Collision raySphereCollision(Ray ray, Sphere sphere);

#endif /* Collision_h */
