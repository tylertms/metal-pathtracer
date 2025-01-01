//
//  Material.hpp
//  pathtracer
//
//  Created by Tyler on 12/31/24.
//  Copyright © 2024 Apple. All rights reserved.
//

#ifndef Material_hpp
#define Material_hpp

#include <simd/simd.h>

typedef struct {
    vector_float3 color;
    vector_float3 emissionColor;
    float emissionStrength;
} Material;

#endif /* Material_hpp */
