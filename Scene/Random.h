//
//  Random.h
//  pathtracer
//
//  Created by Tyler on 12/31/24.
//  Copyright © 2024 Apple. All rights reserved.
//

#ifndef Random_h
#define Random_h

float shaderRandom(thread uint *input);
float shaderRandomNormal(thread uint *input);

float3 shaderRandomDir(thread uint *input);
float3 shaderRandomHemisphereDir(float3 normal, thread uint *input);

#endif /* Random_h */
