#include <stdlib.h> 
#include <stdio.h>
#include <assert.h>
#include <math.h>
struct Point {
    int X;
    int Y;
};


int main(){
    struct Point ptA,ptB;
    ptA.X=0;
    ptA.Y=0;
    ptB.X=10;
    ptB.X=10;
    float distance = 0;
    distance=sqrtf((ptB.Y-ptA.Y)^2+(ptA.X-ptB.X)^2);
    
    assert( (int)(distance*distance) == 200);
    
    return EXIT_SUCCESS;
}
