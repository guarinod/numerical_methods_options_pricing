dynamics.S0 = 100;
dynamics.r = 0.02;
dynamics.sigma = 0.2;

contract.K = 150;
contract.T = 1;

MC.randnseed = 0;
MC.M = 100000;  % Number of paths.
MC.lambda = 0;  % Zero drift adjustment gives ordinary MC
MC.ind = 1;
[call_price_ordinary, std_err_ordinary] = DriftChangeMC(contract,dynamics,MC)

d1 = 1/(dynamics.sigma*sqrt(contract.T))*( log(dynamics.S0/contract.K)...
    +contract.T*(dynamics.r+1/2*dynamics.sigma*dynamics.sigma) );
CBS = dynamics.S0*normcdf(d1)-contract.K*exp(-dynamics.r*contract.T)*normcdf(d1-sqrt(contract.T)*dynamics.sigma);
fprintf('the Black-Scholes value of this call is: %1.6f\n',CBS);

Sbar = (dynamics.S0)^2*exp((dynamics.r+(dynamics.sigma)^2)*contract.T)/CBS*...
    normcdf( d1+dynamics.sigma*sqrt(contract.T) ) - contract.K*dynamics.S0/CBS*normcdf(d1);

MC.lambda =1/(dynamics.sigma*contract.T)*(log(Sbar/dynamics.S0)-dynamics.r*contract.T)  ;  % FILL THIS IN with the lambda 
                % which you compute using your part (c) analysis
MC.ind = 0;
fprintf('lambda was: %1.5f', MC.lambda);

[call_price_importsamp, std_err_importsamp] = DriftChangeMC(contract,dynamics,MC)

%You will implement DriftChangeMC.m
%Its header should be:
%function [call_price, std_err] = DriftChangeMC(contract,dynamics,MC)
%It should seed the random number generator using: 
%randn('state',MC.randnseed);
