#include "calculate.h"

#include <cmath>

Psi0 calculatePsi0(char namePosition, char position) {
    Psi0 psi0;
    const float inv_sqrt2 = 1.0f / std::sqrt(2.0f);
    if (namePosition == 'Z') {
        if (position == 'U') {
            psi0.up = {1.0f, 0.0f};
            psi0.down = {0.0f, 0.0f};
        } else {
            psi0.up = {0.0f, 0.0f};
            psi0.down = {1.0f, 0.0f};
        }
    } else if (namePosition == 'Y') {
        psi0.up = {inv_sqrt2, 0.0f};

        if (position == 'U') {
            psi0.down = std::complex<float>(0.0f, inv_sqrt2);
        } else {
            psi0.down = std::complex<float>(0.0f, -inv_sqrt2);
        }
    } else if (namePosition == 'X') {
        psi0.up = {inv_sqrt2, 0.0f};

        if (position == 'U') {
            psi0.down = {inv_sqrt2, 0.0f};
        } else {
            psi0.down = {-inv_sqrt2, 0.0f};
        }
    }
    return psi0;
}

Coordinats blochVector(const PsiTime& psi) {
    const std::complex<float> z = std::conj(psi.up) * psi.down;
    Coordinats c;
    c.x = 2 * z.real();
    c.y = 2 * z.imag();
    c.z = std::norm(psi.up) - std::norm(psi.down);
    return c;
}

float absMagnitInduction(float Bx, float By, float Bz) {
    return std::sqrt(Bx * Bx + By * By + Bz * Bz);
}

std::complex<float> b(float Bx, float By) {
    return std::complex<float>(Bx, By);
}

std::complex<float> complexExponent(std::complex<float> Energy, float time) {
    const std::complex<float> i(0.0f, 1.0f);
    const float dirakConst = 1.0546f;
    return std::exp((Energy * time * -i) / dirakConst);
}

Coordinats waweFunction(float Bx, float By, float Bz, float time, char namePosition,
                        char position) {
    const float AbsMagnitInduction = absMagnitInduction(Bx, By, Bz);
    const std::complex<float> B = b(Bx, By);
    Psi0 psi0 = calculatePsi0(namePosition, position);
    PsiTime psiTime;
    EigenVectors E1, E2;

    float length1 = std::sqrt(std::pow(AbsMagnitInduction + Bz, 2) + std::norm(B));
    float length2 = std::sqrt(std::pow(-AbsMagnitInduction + Bz, 2) + std::norm(B));

    E1.up = (AbsMagnitInduction + Bz) / length1;
    E1.down = B / length1;
    E2.up = (-AbsMagnitInduction + Bz) / length2;
    E2.down = B / length2;

    std::complex<float> alpha1 = std::conj(E1.up) * psi0.up + std::conj(E1.down) * psi0.down;
    std::complex<float> alpha2 = std::conj(E2.up) * psi0.up + std::conj(E2.down) * psi0.down;

    psiTime.up = alpha1 * complexExponent(AbsMagnitInduction, time) * E1.up +
                 alpha2 * complexExponent(-AbsMagnitInduction, time) * E2.up;
    psiTime.down = alpha1 * complexExponent(AbsMagnitInduction, time) * E1.down +
                   alpha2 * complexExponent(-AbsMagnitInduction, time) * E2.down;

    return blochVector(psiTime);
}
