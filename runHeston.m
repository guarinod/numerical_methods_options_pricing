
dynamics.r = 0.02;
dynamics.theta = 0.06;
dynamics.kappa = 1.5;
dynamics.eta = 0.7;
dynamics.rho = -0.6;

dynamics.S = 100;
dynamics.V = 0.04;
dynamics.t = 0;

contract.T = 0.25;
moneyness = 0.20:-0.05:-0.20;
contract.K = dynamics.S*exp(dynamics.r*contract.T-moneyness);  %change this
display(contract.K);


integration.J=150;  %change this
integration.dz=1;   %change this

%z = 0:130;
%figure
%plot(z,real(cfHeston(z,dynamics,contract.T)./(1i*z).*exp(-1i.*z.*log(contract.K))));
%xlabel('z values');
%ylim([-0.0002,0.0002]);
callprice = callpriceHeston(dynamics, contract, integration)

%%

CBS = @(sigma_,K_)dynamics.S*normcdf(1./(sigma_.*sqrt(contract.T)).*( log(dynamics.S./K_)...
    +contract.T.*(dynamics.r+1/2*sigma_.*sigma_) ))-K_.*exp(-dynamics.r*contract.T).*normcdf(1./(sigma_.*sqrt(contract.T)).*( log(dynamics.S./K_)...
    +contract.T.*(dynamics.r+1/2*sigma_.*sigma_) )-sqrt(contract.T)*sigma_);
implied_vols = ones(length(contract.K),1);
for kk=1:length(contract.K)
    sig0 = 0.2;
    fun = @(sig_) abs( callprice(kk) - CBS(sig_,contract.K(kk)) );
    implied_vols(kk,1) = fminunc(fun,sig0);
end

figure
plot(contract.K',implied_vols);
xlabel('Strike');
ylabel('implied vol.');
title('Implied Volatility vs. Strike Under Heston Model');
ylim([0,0.28]);

%%
%1c

dynamics.eta = 1.2;
callprice2 = callpriceHeston(dynamics, contract, integration)

implied_vols2 = ones(length(contract.K),1);
for kk=1:length(contract.K)
    sig0 = 0.2;
    fun = @(sig_) abs( callprice2(kk) - CBS(sig_,contract.K(kk)) );
    implied_vols2(kk,1) = fminunc(fun,sig0);
end

figure
plot(contract.K',implied_vols,contract.K',implied_vols2);
xlabel('Strike');
ylabel('implied vol.');
title('Implied Volatility vs. Strike Under Heston Model');
legend('eta=0.7','eta=1.2');
ylim([0,0.3]);

% Modify/extend this file, runHeston.m, in order to answer the HW question
% (But the unmodified runHeston.m should still execute).
%
% Create the function callpriceHeston.m.
% Your callpriceHeston.m may make use of the provided file cfHeston.m
