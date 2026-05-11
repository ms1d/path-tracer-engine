#pragma once



#ifndef __host__
#define __host__
#endif
#ifndef __device__
#define __device__
#endif



#include "vec3.cuh"
#include "precision.cuh"
#include <iostream>

// Generic 3D Ray. Implements:
//
//		- Ray-Triangle intersection (Moller-Trumbore)
//		- Ray-Plane intersection
//		- Point on ray calculation
//		- Reflection logic
//
//		- Equality test (with strict tolerance)
//
struct ray {


	vec<3> o;
	vec<3> dir;



	__host__ __device__ constexpr ray(const vec<3>& origin, const vec<3>& direction) : o(origin), dir(direction) {}



	__host__ __device__ constexpr vec<3> get_point(float t) const {
		return o + dir * t;
	}


	// Moller-Trumbore intersection algorithm - returns the value of t such that the ray and triangle intersect
	__host__ __device__ constexpr float get_tri_intersect(const vec<3>& v1, const vec<3>& v2, const vec<3>& v3) const {
		vec<3> e1 = v2 - v1;
        vec<3> e2 = v3 - v1;

		vec<3> h = dir ^ e2;
        float a = h * e1;

	    if (__builtin_fabsf(a) < math_precision::epsilon) return -1;
		
		float f = 1.0f / a;
		vec<3> s = o - v1;
		float u = f * (s * h);
        
		if (__builtin_fabsf(u) > 1) return -1;
        
		vec<3> q = s ^ e1;
        float v = f * (dir * q);
        
		if (v < 0.0f || u + v > 1.0f) return -1;
        
		return f * (e2 * q);
	}



	// Standard linear algebra formula, defining a plane as a normal and a point on it
	__host__ __device__ constexpr float get_plane_intersect(const vec<3>& p, const vec<3>& n) const {
		float den = dir * n;
		if (__builtin_fabsf(den) < math_precision::epsilon) return -1;
		return (p * n - o * n) / den;
	}



	// Redundant res temporary here to suppress clangd error
	// Compiler should optimise it away
	__host__ __device__ constexpr bool operator==(const ray& other) const {
		return o == other.o && dir == other.dir;
	}



	__host__ __device__ constexpr ray reflect(const vec<3>& p, const vec<3>& n) const {
		ray r = *this;
		r.reflect_inplace(p, n);
		return r;
	}



	__host__ __device__ constexpr ray& reflect_inplace(const vec<3>& p, const vec<3>& n) {
		float t = get_plane_intersect(p, n) * 2;
		vec<3> o_prime = o + dir * t;
		o = o_prime; dir = p - o_prime;
		return *this;
	}



	friend std::ostream& operator<<(std::ostream& os, const ray& r) {
		os << "Origin: " << r.o << '\n' << "Direction: " << r.dir << std::endl;
		return os;
	}



};
