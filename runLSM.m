
dynamics.r=0.03;
dynamics.sigma=0.20;
dynamics.S0=1;

contract.K=1.1;
contract.T=4;

MC.N=4;
MC.M=150000;
MC.randnSeed=0;

putprice = LSM(contract,dynamics,MC)
