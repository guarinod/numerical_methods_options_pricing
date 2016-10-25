dynamics.kappa=3;
dynamics.theta=0.05;
dynamics.sigma=0.03;

FD.rMax=0.35;
FD.rMin=-0.25;
FD.deltar=0.01;
FD.deltat=0.01;
FD.useUpwind= 0 ;   % 0 = don't use upwind.  1 = use upwind

contract.T=5;

[r0, bondprice]=vasicek(contract,dynamics,FD);
displayRows=(r0>0.00-FD.deltar/2 & r0<0.15+FD.deltar/2);
[r0(displayRows), bondprice(displayRows)]
answer = [r0, bondprice];

