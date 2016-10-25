dynamics.S0 = 100;
dynamics.r = 0.02;
dynamics.V0 = 0.04;
dynamics.eta = 0.7;
dynamics.theta = 0.06;
dynamics.kappa = 1.5;

contracts.moneyness = 0.20:-0.05:-0.20;
contracts.T = 0.25;

MC.M = 2000;  % Number of paths.
MC.N = 250;   % Number of time steps per path
MC.randnseed = 0;

[call_prices, std_errs] = HestonCMC(contracts,dynamics,MC)

%You will implement HestonCMC.m
%call_prices and std_errs should be vectors,
%each of the same size as contracts.moneyness
%Header should be "function [call_prices, std_errs] = HestonCMC(contracts,dynamics,MC)"
%Seed the random generator using: "randn('state',MC.randnseed);"

