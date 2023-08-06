#include "DCMotor.h"
struct Position
{
    long int current;
    long int goal;
    long int error;

    void update(double per, int vel) {
        this->goal = this->goal + per*vel;
    }
};

struct TMURover
{
    DCMotor arm[6];
};
