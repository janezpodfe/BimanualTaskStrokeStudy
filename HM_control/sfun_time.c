#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  sfun_time

#define TIME_SCALE_FACTOR(S) ssGetSFcnParam(S,0)

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"

/*
 *  Include the standard ANSI C header for handling time functions:
 *  ---------------------------------------------------------------
 */
#include <time.h>

#include <windows.h>

static void mdlInitializeSizes(SimStruct *S)
{

   ssSetNumSFcnParams(S, 1);  /* Number of expected parameters */

   if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) 
   {
      return;
   }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

   if (!ssSetNumInputPorts(S, 1))
   {
      return;
   }

   ssSetInputPortWidth(S, 0, 1);

   ssSetInputPortDirectFeedThrough(S, 0, 1);

   if (!ssSetNumOutputPorts(S, 1))
   {
      return;
   }

   ssSetOutputPortWidth(S, 0, 3);
   ssSetNumSampleTimes(S, 1);
   ssSetNumRWork(S, 1);
   ssSetNumIWork(S, 0);
   ssSetNumPWork(S, 0);
   ssSetNumModes(S, 0);
   ssSetNumNonsampledZCs(S, 0);
   ssSetOptions(S, 0);
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
   ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
   ssSetOffsetTime(S, 0, 0.0);
   return;
}

#undef MDL_INITIALIZE_CONDITIONS   /* Change to #define to include function */
#if defined(MDL_INITIALIZE_CONDITIONS)

static void mdlInitializeConditions(SimStruct *S)
{
   return;
}
#endif /* MDL_INITIALIZE_CONDITIONS */


#define MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START) 

static void mdlStart(SimStruct *S)
{
   real_T *p2t_RealWork, 
           t_StartTime;

   p2t_RealWork=ssGetRWork(S);

   t_StartTime=(real_T) clock();
   t_StartTime=t_StartTime/CLOCKS_PER_SEC;

   p2t_RealWork[0]=t_StartTime;

   return;
}
#endif /*  MDL_START */


static void mdlOutputs(SimStruct *S, int_T tid)
{
   real_T            *p2t_Yport1=NULL,
                      t_SimTime,
                      t_Diff=0.0,
                      t_StartTime,
                      t_CurrTime;

   const real_T *scaleFactor     = mxGetPr(TIME_SCALE_FACTOR(S));
   InputRealPtrsType  t_Uport1=NULL;

   p2t_Yport1 = ssGetOutputPortRealSignal(S, 0);
   t_Uport1   = ssGetInputPortRealSignalPtrs(S, 0);


   t_SimTime=*t_Uport1[0] * (scaleFactor[0]);
   t_StartTime=ssGetRWorkValue(S,0);

   while (t_Diff<t_SimTime)
   {
      t_CurrTime=(real_T) clock();
      t_CurrTime=(real_T) t_CurrTime/CLOCKS_PER_SEC;
      t_Diff=t_CurrTime-t_StartTime;
   }

   p2t_Yport1[0]=t_CurrTime;
   p2t_Yport1[1]=t_StartTime;
   p2t_Yport1[2]=t_SimTime;
   
   return;
}


#undef MDL_UPDATE  /* Change to #define to include function */
#if defined(MDL_UPDATE)

static void mdlUpdate(SimStruct *S, int_T tid)
{
   return;
}
#endif /* MDL_UPDATE */


#undef MDL_DERIVATIVES  /* Change to #define to include function */
#if defined(MDL_DERIVATIVES)


static void mdlDerivatives(SimStruct *S)
{
   return;
}
#endif /* MDL_DERIVATIVES */


static void mdlTerminate(SimStruct *S)
{
   return;
}

/*
 *  Required S-function trailer:
 *  ----------------------------
 */
#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
