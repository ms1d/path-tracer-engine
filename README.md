# PATH-TRACER-ENGINE

## About

A C++20 path tracer server as a personal project.
See also `ms1d/path-tracer` and `ms1d/path-tracer-api`.

## Plan

### Phase 1

- Start with the CPU

- Take in BVH input, concurrently render over a thread pool

- Stream pixels to UDP clients + send checkpoints over tcp

### Phase 2

- Add CUDA support to replace the CPU thread pool

## Architecture

- Master process - manages 2 child processes (`http-server`, `path-tracer`)

- HTTP - accepts standard REST API requests (health check, submit render)

- Path Tracer - concurrently renders pixels; streams results back to UDP clients

- Also contains a CPU only executeable for generating BVHs

## Current Build Instructions

- Configuration: `cmake --preset <preset name>`. See CMakePresets.json for presets

- Build: `cmake --build --preset <preset name>`

- Test: `cd build/<preset name> && ctest` from project root

## Stack

- CMake + Ninja for build tools

- asio for udp

- nlohmann/json for json

- cpp-httplib for tcp

- g++ & nvcc for compilers

## Contributions

Advice + guidance appreciated, but this is mainly a solo learning project for myself.
Feel free to contact me for any queries or concerns.
