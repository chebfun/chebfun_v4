/* MEX file support for bary.m */
/* Barycentric formula for Chebyshev points and weights */

#include <math.h>
#include <stdio.h>
#include <malloc.h>
#include "matrix.h"
#include "mex.h"

#define PI 3.1415926535897932384626433

int bary_mex(int N, double *fR, double *fI, int n, double *xR, double *xI, double *gvalsR, double *gvalsI, double *xk)
{
  int sgn, j, k, m = n-1, kappa, chebpt;
  double xj, yj, xjk, xx, numR, numI, denomR, denomI, Pi2M, PiM, MPi;
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
    chebpt = 1;
    xj = xR[j];
    yj = xI[j];
    
    
    if (yj != 0)			/* imag(x) != 0 */
    {
    	chebpt = 0;
    }
    else
    {
        if (fabs(xj) > 1)		/* real(x) > 1 */
        {
            chebpt = 0;
        }
    }
   
    if (chebpt == 1)
    {
        kappa = floor(0.5 + MPi * acos(xj)); /* This should be round? */
    	if (xj == xk[m-kappa])               /* xj is a Chebyshev point  */
    	{
  		*fR++ = gvalsR[m-kappa];
 		*fI++ = gvalsI[m-kappa];
 	}
 	else
 	{	
 		chebpt = 0;
 	}
    }    

    if (chebpt == 0) 
    {
        gptrR = &gvalsR[0];
        gptrI = &gvalsI[0];        
        xkptr = &xk[0];
	xjk = (xj - *xkptr++);
	
	xx = 0.5 / (xjk*xjk + yj*yj);
   	numR = xx * (xjk * *gptrR + yj * *gptrI);
   	numI = xx * (xjk * *gptrI++ - yj * *gptrR++);
    	denomR = xx * xjk;
    	denomI = - xx * yj;

    	sgn = -1;
    	for (k = 1; k < n-1; k++) 
    	{
       	    xjk =  (xj - *xkptr++);
       	    xx = (double)sgn / (xjk*xjk+yj*yj);
  	    numR += xx * (xjk * *gptrR + yj * *gptrI);
  	    numI += xx * (xjk * *gptrI++ - yj * *gptrR++);  	    
  	    denomR += xx * xjk;
  	    denomI -= xx * yj;
  	    sgn = -sgn;
    	}
    	
    	xjk =  (xj - *xkptr);
    	xx = (double)sgn * 0.5 / (xjk*xjk + yj*yj);
   	numR += xx * (xjk * *gptrR + yj * *gptrI);
   	numI += xx * (xjk * *gptrI++ - yj * *gptrR++);
    	denomR += xx * xjk;
    	denomI -= xx * yj;
    	
    	xx = 1./(denomR*denomR + denomI*denomI);
    	*fR++ = xx * (numR*denomR + numI*denomI);
    	*fI++ = xx * (numI*denomR - numR*denomI);
    }
  }
  
  return(0);
}

/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  double PiM, Pi2M;
  double *fR, *fI, *xR, *xI, *gvalsR, *gvalsI, *xk, *xkptr;
  int N, n, m, k;
  int xreal = 0, greal = 0;
  int status;
  
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
  
  /* Get length of output. */
  N = mxGetM(prhs[0]);
  /* Get length of chebfun. */
  n = mxGetM(prhs[1]);

  
  if (nrhs == 2)		/* Construct Chebyshev points */
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
  else				/* Chebyshev points are given */
  {
  	xk = mxGetPr(prhs[2]);
  }
  
  /* Get the input (real parts) */
  xR = mxGetPr(prhs[0]);
  gvalsR = mxGetPr(prhs[1]);

  if (mxIsComplex(prhs[0]))	/* Complex evaluation points */
  {
  	xI = mxGetPi(prhs[0]);
  }
  else
  {	
  	xI = (double*)calloc(1,N*sizeof(double));
  	xreal = 1;
  }
            
  if (mxIsComplex(prhs[1]))	/* Complex function */
  {	
	gvalsI = mxGetPi(prhs[1]);
  }  	
  else
  {
  	gvalsI = (double*)calloc(1,n*sizeof(double));
  	greal = 1;
  }
 
  if (xreal + greal < 2)	/* Complex output */
  {
  	/* Set the output pointer to the output matrix. */
  	plhs[0] = mxCreateDoubleMatrix(N,1, mxCOMPLEX);
  
  	/* Create a C pointer to a copy of the output matrix. */
  	fR = mxGetPr(plhs[0]);
  	fI = mxGetPi(plhs[0]);
  }
  else
  {
    	/* Set the output pointer to the output matrix. */
  	plhs[0] = mxCreateDoubleMatrix(N,1, mxREAL);
  
  	/* Create a C pointer to a copy of the output matrix. */
  	fR = mxGetPr(plhs[0]);
  	fI = (double*)malloc(N*sizeof(double));
  }
  
  /* Call the C subroutine. */
  bary_mex(N, fR, fI, n, xR, xI, gvalsR, gvalsI, xk);
  
  if (nrhs == 2)
  {
      free(xk);
  }
  if (xreal == 1)
  {
      free(xI);
  }
  if (greal == 1)
  {
      free(gvalsI);
  }
  if (xreal + greal == 2)
  {
      free(fI);
  }
  
}
