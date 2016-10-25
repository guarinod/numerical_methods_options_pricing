%dynamics.alpha=-0.5; %use this for dynamics of Problem 2.b
dynamics.alpha=0;   %use this for B-S dynamics in Problem 2.d
dynamics.volcoeff=0.3; %use this for B-S dynamics in Problem 2.d
%dynamics.volcoeff = 3;  %use this for Problem 2.b  
dynamics.r=0.05;
dynamics.S0=100;

FD.SMax=200;
FD.SMin=50;
FD.deltaS=0.1;
FD.deltat=0.0005;

contract.T=0.25;
contract.K=100;

% C-N will give us option prices for ALL S0 from SMin to SMax
% But let's display only a few near 100:

displayStart = dynamics.S0-FD.deltaS*1.5; 
displayEnd   = dynamics.S0+FD.deltaS*1.5; 

[S0_ALL putprice]=CEV(contract,dynamics,FD);
indices=(S0_ALL > displayStart & S0_ALL < displayEnd);
[S0_ALL(indices) putprice(indices)]
greek_info = putprice(indices);
delta = (greek_info(1)-greek_info(3))/(2*FD.deltaS)
gamma = (greek_info(1)-2*greek_info(2)+greek_info(3))/(FD.deltaS*FD.deltaS)

