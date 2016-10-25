clear all

dynamics.S_0 = 100;
dynamics.r = 0.06;
dynamics.q = 0.00;
dynamics.localvol = @localvol;
dynamics.maxvol = 0.6;

contract.putexpiry = 0.75;
contract.putstrike = 95;
contract.callexpiry = 0.25;
contract.callstrike = 10;

tree.N=420;   %change this if necessary to get $0.01 accuracy, in your judgment

[answer_part_a, answer_part_b] = trinomHW2(contract,dynamics,tree)

% The first line of trinomHW2.m should be:
% function [answer_part_a, answer_part_b] = trinomHW2(contract,dynamics,tree)
%
% This file (runHW2.m) should run properly,
% and should still run properly when you perturb the parameters.
%
% Note that dynamics.localvol is a function 
% that may be invoked in the usual way, for example:
% dynamics.localvol( exchangerate , time )
