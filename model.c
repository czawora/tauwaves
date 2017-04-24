
/* file model.c */
#include <R.h>
#include <math.h>

static double parms[4];
#define omega parms[0]
#define eps parms[1]
#define beta parms[2]
#define stim parms[3]

/* initializer */
void initmod(void (* odeparms)(int *, double *))
{
	int N=4;
	odeparms(&N, parms);
}

/* Derivatives and 1 output variable */
void derivs (int *neq, double *t, double *y, double *ydot,
double *yout, int *ip)
{
	//if (ip[0] <1) error("nout should be at least 1");
	ydot[0] = omega + (eps * -1 * sin(y[0] - M_PI/2) * exp(-1 * beta * (1 - cos(y[0] - M_PI/2))) *stim);
	//yout[0] = y[0];
}
/* END file model.c */
