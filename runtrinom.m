
dynamics.S_0 = 100;
dynamics.sigma = 0.4;
dynamics.r = 0.00;
                    
contract.K = 95;
contract.T = 0.25;
contract.H = 114;
contract.observationinterval = 0.02; %observed at times 0.02,0.04,...,0.24

tree.N = 500;

optionprice = trinom(contract, dynamics, tree)
