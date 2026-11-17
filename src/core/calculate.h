#pragma once

#include <complex>

struct EigenVectors {
    std::complex<float> up;
    std::complex<float> down;
};

struct Psi0 {
    std::complex<float> up;
    std::complex<float> down;
};

struct PsiTime {
    std::complex<float> up;
    std::complex<float> down;
};

struct Coordinats {
    float x;
    float y;
    float z;
};

Psi0 calculatePsi0(char namePosition, char position);
Coordinats blochVector(const PsiTime& psi);
float absMagnitInduction(float Bx, float By, float Bz);
std::complex<float> b(float Bx, float By);
std::complex<float> complexExponent(std::complex<float> Energy, float time);
Coordinats waweFunction(float Bx, float By, float Bz, float time, char namePosition, char position);
