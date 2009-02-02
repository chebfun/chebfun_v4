/* MEX file support for bary.m */

/* Barycentric formula for Chebyshev points and weights */



#include "math.h"

#include <stdio.h>

#include <malloc.h>

#include "matrix.h"

#include "mex.h"



#define PI 3.141592653589793



int bary_mex(int N, double *fR, int n, double *x, double *gvalsR, double *xk)

{

  int sgn, j, k, m = n-1, kappa;

  double xj, xx, numR, denom, MPi;

  double *xkptr, *gptrR;

 

  if (n == 1) /* The function is a constant */

  {

      xx = gvalsR[0];

      for (j = 0; j < N; j++)

      {

		*fR++ = xx;

      }

      return(0);

  }

    

  /* Some constants */  

  m = n-1;  

  MPi = (double)m / PI;

  

  /* The main loop */

  for (j = 0; j < N; j++) 

  {

    xj = x[j];

    kappa = floor(MPi * acos(xj) + 0.5); /* this is really 'round' - hopefully*/

    if (xj == xk[m-kappa])         /* xj is a Chebyshev point */

    {

  		*fR++ = gvalsR[m-kappa];;

    }

    else			   /* Barycentric formula */

    {

        /*printf("%d \t %16.16g\n",j, x[j]-xk[m-kappa]);*/

        gptrR = &gvalsR[0]; 

        xkptr = &xk[0];

		xx = .5 / (xj - *xkptr++);

   		numR = xx * *gptrR++;

    	denom = xx;

    	sgn = -1;

    	for (k = 1; k < n-1; k++) 

    	{

    	    xx = (double)sgn / (xj - *xkptr++);

  			numR += xx * *gptrR++;	    

  			denom += xx;

  			sgn = -sgn;

    	}

    	xx = (double)sgn * 0.5 /(xj - *xkptr);

        numR += xx * *gptrR;

    	denom += xx;

    	denom = 1./denom;

    	*fR++ = denom*numR;

    }

  }

  return(0);

}





int bary_mexC(int N, double *fR, double *fI, int n, double *x, double *gvalsR, double *gvalsI, double *xk)

{

  int sgn, j, k, m = n-1, kappa;

  double xj, xx, numR, numI, denom, Pi2M, PiM, MPi;

  double *xkptr, *gptrR, *gptrI;

 

  if (n == 1) /* The function is a constant */

  {

      for (j = 0; j < N; j++)

      {

	 *fR++ = gvalsR[0];

	 *fI++ = gvalsI[0];

      }

      return(0);

  }

    

  /* Some constants */  

  m = n-1;  

  PiM = PI / (double)m;

  Pi2M = 0.5 * PiM;

  MPi = (double)m / PI;

 

  /* The main loop */

  for (j = 0; j < N; j++) 

  {

    xj = x[j];

    kappa = floor(MPi * acos(xj) + 0.5); /* this is really 'round' - hopefully*/

    if (xj == xk[m-kappa])         /* xj is a Chebyshev point  */

    {

  	*fR++ = gvalsR[m-kappa];

 	*fI++ = gvalsI[m-kappa];

    }

    else			   /* Barycentric formula */

    {

        /*printf("%d \t %16.16g\n",j, x[j]-xk[m-kappa]);*/

        gptrR = &gvalsR[0];

        gptrI = &gvalsI[0];        

        xkptr = &xk[0];

		xx = .5 / (xj - *xkptr++);

   		numR = xx * *gptrR++;

   		numI = xx * *gptrI++;

    	denom = xx;

    	sgn = -1;

    	for (k = 1; k < n-1; k++) 

    	{

    	    xx = (double)sgn / (xj - *xkptr++);

  			numR += xx * *gptrR++;

  			numI += xx * *gptrI++;  	    

  			denom += xx;

  	    sgn = -sgn;

    	}

    	xx = (double)sgn * 0.5 /(xj - *xkptr);

        numR += xx * *gptrR;

        numI += xx * *gptrI;

    	denom += xx;

    	denom = 1./denom;

    	*fR++ = denom*numR;

    	*fI++ = denom*numI;    	

    }

  }

  

  return(0);

}



/* The gateway routine */

void mexFunction(int nlhs, mxArray *plhs[],

                 int nrhs, const mxArray *prhs[])

{

  double PiM, Pi2M;

  double *fR, *fI, *x, *gvalsR, *gvalsI, *xk, *xkptr;

  int N, n, m, k;

  int status;

  int isreal = 1;

  

  /*  Check for proper number of arguments. */

  /* NOTE: You do not need an else statement when using 

     mexErrMsgTxt within an if statement. It will never 

     get to the else statement if mexErrMsgTxt is executed. 

     (mexErrMsgTxt breaks you out of the MEX-file.) 

  */ 

  if (nrhs == 1) 

    mexErrMsgTxt("Two or Three inputs required.");

  if (nlhs != 1) 

    mexErrMsgTxt("One output required.");

  

  /* Get the input */

  x = mxGetPr(prhs[0]);

  gvalsR = mxGetPr(prhs[1]);

  gvalsI = mxGetPi(prhs[1]);

  if (nrhs == 3) 

  {

      xk = mxGetPr(prhs[2]);

  }

 

  /* Get length of chebfun. */

  n = mxGetM(prhs[1]);



  /* Get length of output. */

  N = mxGetM(prhs[0]);



  /* Construct Chebyshev points */

  if (nrhs == 2)

  {

      /* Some constants */ 

      m = n-1;

      PiM = PI / (double)m;

      Pi2M = 0.5 * PiM;

      /* Allocate memory for Chebyshev points*/ 

      xk = (double*)malloc(n*sizeof(double));

      xkptr = &xk[0];

      /* Define Chebyshev Points */

      for (k = -m; k <= m; k+=2) 

      {

     	*xkptr++ = sin((double)k*Pi2M);

      }

      

  }



  if (!mxIsComplex(prhs[1]))

  {

      /* Set the output pointer to the output matrix. */

      plhs[0] = mxCreateDoubleMatrix(N,1, mxREAL);

  

      /* Create a C pointer to a copy of the output matrix. */

      fR = mxGetPr(plhs[0]);

  

      /* Call the C subroutine. */

      bary_mex(N, fR, n, x, gvalsR, xk);  

  }

  else

  {

      /* Set the output pointer to the output matrix. */

      plhs[0] = mxCreateDoubleMatrix(N,1, mxCOMPLEX);

  

      /* Create a C pointer to a copy of the output matrix. */

      fR = mxGetPr(plhs[0]);

      fI = mxGetPi(plhs[0]);

  

      /* Call the C subroutine. */

      bary_mexC(N, fR, fI, n, x, gvalsR, gvalsI, xk);

  }

  

  if (nrhs == 2)

  {

      free(xk);

  }

  

}

