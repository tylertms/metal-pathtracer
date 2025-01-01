//
//  Sphere.h
//  pathtracer
//
//  Created by Tyler on 12/31/24.
//  Copyright © 2024 Apple. All rights reserved.
//

#ifndef Sphere_h
#define Sphere_h

#include "Material.hpp"

typedef struct {
    vector_float3 center;
    float radius;
    Material material;
} Sphere;


#endif /* Sphere_h */
