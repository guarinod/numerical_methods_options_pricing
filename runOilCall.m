%You are free to modify this file.  Write the function OilCall.m
%such that both this original runOilCall.m and also your 
%modified version of runOilCall.m are executable.
%
%The header of OilCall.m must be:
%function [call_price, std_err, call_delta] = OilCall(dynamics,contract,MC)
%
%OilCall.m should use "randn" to generate normals.
%OilCall.m should seed the generator by using "randn('state',MC.randnSeed);"
%(only once, at the beginning).
%
%Note that starting with release 7.7, Matlab offers a seed control mechanism via
%"randstream", but to make sure all students/graders are running compatible code,
%please continue to use "randn('state',...);

dynamics.kappa = 0.472;
dynamics.alpha = 4.4;
dynamics.sigma = 0.368;
dynamics.S0 = 106.9;
dynamics.r  = 0.05;

contract.K1 = 103.2; 
contract.T1 = 0.5;
contract.T2 = 0.75;

MC.N = 100;   % Number of timesteps on each path
MC.M = 100000;  % Number of paths.  Change this if necessary.
MC.epsilon = 0.01;  % For the dC/dS calculation
MC.randnSeed = 0;
%if you want to "randomize" the seed,
%then you can say instead "MC.randnSeed = sum(100*clock)" or similar.

MC.antithetic = 0;  % 0=no antithetic, 1=do antithetic
%MC.control = 0;  % 0=no control variate, 1=do control variate
[call_price_ordinary, std_err_ordinary, call_delta] = OilCall(dynamics,contract,MC)

MC.antithetic = 1;
MC.control = 0;
[call_price_AV, std_err_AV] = OilCall(dynamics,contract,MC)

%MC.antithetic = 0;
%MC.control = 1;
%[call_price_CV, std_err_CV] = OilCall(dynamics,contract,MC)

%You are not required to support MC.control = MC.antithetic = 1
%(simultaneous use of control variate and antithetic)
%But the settings in runOilCall.m must be supported, 
%so your implementation of OilCall() is required 
%to handle the other 3 possible settings of MC.antithetic/MC.control 
%namely 0/0, 1/0, 0/1.
%(ordinary MC, antithetic without control, control without antithetic)

%To keep the AV and CV code simple, 
%in the cases MC.antithetic = 1 or MC.control = 1,
%you are not asked to compute the delta of the call.
%In those cases your implementation of OilCall in OilCall.m may
%simply assign call_delta = NaN, if you wish.
%Your implementation of OilCall() is required to actually compute
%the delta in the case MC.antithetic = MC.control = 0




