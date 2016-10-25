% This function is capable of taking z to be a vector,
% in case you wish to evaluate the CF at many places 
% using a single function call.

function cf=cfHeston(z,dynamics,T)

r=dynamics.r;
theta=dynamics.theta;
kappa=dynamics.kappa;
eta=dynamics.eta;
rho=dynamics.rho;

X=log(dynamics.S);
V=dynamics.V;
tau=T-dynamics.t;

kappastar = kappa-1i*rho*eta*z;
gamma = sqrt(kappastar.^2+eta^2*(z*1i+z.^2));

A = 1i*r*z*tau+kappa*theta/eta^2*((kappastar-gamma)*tau...
    -2*log(1+(kappastar-gamma).*(1-exp(-gamma*tau))./(2*gamma)));
B = -(z*1i+z.^2).*(1-exp(-gamma*tau))./(2*gamma.*exp(-gamma*tau)+(gamma+kappastar).*(1-exp(-gamma*tau)));

cf = exp(A+1i*z*X+B*V);
