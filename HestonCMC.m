function [call_prices, std_errs] = HestonCMC(contracts,dynamics,MC)
randn('state',MC.randnseed);
%call_prices and std_errs should be vectors,
%each of the same size as contracts.moneyness
S0        = dynamics.S0;
r         = dynamics.r;
V0        = dynamics.V0;
eta       = dynamics.eta;
theta     = dynamics.theta;
kappa     = dynamics.kappa;

moneyness = contracts.moneyness;
T         = contracts.T;

M         = MC.M;  % Number of paths.
N         = MC.N;   % Number of time steps per path
randnseed = MC.randnseed;
deltat = T/N;

%d1 = @(sigma_,K_)1/(sigma_.*sqrt(T)).*( log(S0./K_)...
%    +T.*(r+1/2*sigma_.*sigma_) );
%CBS = @(sigma_,K_,D1)S0*normcdf(D1)-K_.*exp(-r*T).*normcdf(D1-sqrt(T)*sigma_);

strikes = S0*exp(r*T-moneyness);

CBS = @(sigma_,K_)S0*normcdf(1./(sigma_.*sqrt(T)).*( log(S0./K_)...
    +T.*(r+1/2*sigma_.*sigma_) ))-K_.*exp(-r*T).*normcdf(1./(sigma_.*sqrt(T)).*( log(S0./K_)...
    +T.*(r+1/2*sigma_.*sigma_) )-sqrt(T)*sigma_);


fprintf('the strikes are\n');
display(strikes');

C_est = zeros(1,length(strikes));
Y_ave = zeros(M,length(strikes));
for jj = 1:M
%need to average the Call price estimates of M paths
    Vpath = zeros(N,1); %initialize path of V
    aVpath = zeros(N,1); %initialize antithetic path of V
    Vpath(1,1) = V0;
    aVpath(1,1) = V0;
    for ii=1:N-1
        random = randn(1);
        Vpath(ii+1,1) = Vpath(ii,1)+ kappa*( theta-Vpath(ii,1) )*deltat + eta*sqrt(Vpath(ii,1))*random*sqrt(deltat);
        aVpath(ii+1,1) = aVpath(ii,1)+ kappa*( theta-aVpath(ii,1) )*deltat + eta*sqrt(aVpath(ii,1))*(-random)*sqrt(deltat);
        Vpath(ii+1,1) = max(Vpath(ii+1,1),0);
        aVpath(ii+1,1) = max(aVpath(ii+1,1),0);
    end
    %now I need to integrate the paths
    sig_bar = sqrt( 1/T*( deltat*(sum(Vpath)-1/2*Vpath(1,1)-1/2*Vpath(N,1)) ));
    asig_bar = sqrt(1/T*( deltat*(sum(aVpath)-1/2*aVpath(1,1)-1/2*aVpath(N,1)) ));
    %d_1 = d1(sig_bar, strikes);
    %ad_1 = d1(asig_bar, strikes);
    callprice = CBS(sig_bar,strikes);
    acallprice = CBS(asig_bar,strikes);
    Y_ave(jj,:) = ( callprice + acallprice )/2;
    
end

call_prices = sum(Y_ave/M);
std_errs = sqrt(1/(M-1)*sum((Y_ave - ones(M,1)*call_prices).^2))/sqrt(M);
implied_vols = ones(length(strikes),1);
for kk=1:length(strikes)
    sig0 = .2;
    fun = @(sig_) abs( call_prices(kk) - CBS(sig_,strikes(kk)) );
    implied_vols(kk,1) = fminunc(fun,sig0);
end
display(implied_vols);


fprintf('here are the call_prices: \n');
end