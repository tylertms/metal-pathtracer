//
//  Trace.h
//  pathtracer
//
//  Created by Tyler on 12/31/24.
//  Copyright © 2024 Apple. All rights reserved.
//

#ifndef Trace_h
#define Trace_h

float3 Trace(Ray ray, device const Sphere *spheres, thread uint *input);

#endif /* Trace_h */
