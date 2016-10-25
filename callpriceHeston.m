% This function evaluates a call price using the Heston method

function callprice=callpriceHeston(dynamics,contract,integration)

r=dynamics.r;


K = contract.K;  %change this
T = contract.T;
t = dynamics.t;

J = integration.J;  %change this
dz = integration.dz;   %change this
pi = 3.1415926535897932384;

jvec = cumsum(ones(J,1));
zjvec = (jvec-1/2).*dz;
price = zeros(length(K),1);
for ii = 1:length(K)
    int1 = sum( real(cfHeston(zjvec-1i,dynamics,T)./(1i.*zjvec).*exp(-1i*zjvec*log(K(ii)))) ).*dz;
    %display(int1);
    int2 = sum(real(cfHeston(zjvec,dynamics,T)./(1i.*zjvec).*exp(-1i*zjvec*log(K(ii))))).*dz;
    %display(int2);
    price(ii) = exp(-r.*(T-t)).*( (cfHeston(-1i,dynamics,T)./2 + 1/pi*int1) - K(ii).*(1/2 + 1/pi*int2) );
end
callprice = price;