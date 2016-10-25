%OilCall.m

function [call_price,std_error,call_delta]=OilCall(dynamics,contract,MC)
kappa = dynamics.kappa;
alpha = dynamics.alpha;
sigma = dynamics.sigma;
S0 = dynamics.S0;
r = dynamics.r;

K1 = contract.K1; 
T1 = contract.T1;
T2 = contract.T2;

N = MC.N;   % Number of timesteps on each path
M = MC.M;  % Number of paths.  Change this if necessary.
epsilon = MC.epsilon;  % For the dC/dS calculation
randnSeed = MC.randnSeed;

antithetic = MC.antithetic;  % 0=no antithetic, 1=do antithetic
%control = MC.control;

deltat = T1/N;
a = @(k,al,x)(k*(al-x));
b = sigma;

C_0 = ones(M,1);  %this will store the call prices for each repetition of the Euler method
S_inc = 0.01;  %this is the S increment that will be used to calculate delta
C_0up = ones(M,1); %this will store the call prices with a slightly higher initial spot
randn('state',MC.randnSeed); %this can be changed to randomize

for jj = 1:M
    r1 = randn(1,N);
    X = log(S0);
    if antithetic
        Y = log(S0);
    else
        Y = log(S0+S_inc);
    end
    for ii = 1:N
        X = X + a(kappa,alpha,X)*deltat + b*sqrt(deltat)*r1(1,ii);
        if antithetic
            Y = Y + a(kappa,alpha,Y)*deltat - b*sqrt(deltat)*r1(1,ii);
        else
            Y = Y + a(kappa,alpha,Y)*deltat + b*sqrt(deltat)*r1(1,ii);
        end  
    end
    S_T1 = exp(X);
    Sup_T1 = exp(Y);
    F_T1 = exp(  exp(-kappa*(T2-T1))*log(S_T1) + (1-exp(-kappa*(T2-T1)))*alpha...
        + (sigma*sigma)/(4*kappa)*(1-exp(-2*kappa*(T2-T1)))  );
    Fup_T1 = exp(  exp(-kappa*(T2-T1))*log(Sup_T1) + (1-exp(-kappa*(T2-T1)))*alpha...
        + (sigma*sigma)/(4*kappa)*(1-exp(-2*kappa*(T2-T1)))  );
    C_0(jj,1) = exp(-r*(T1))*max((F_T1-K1),0);
    C_0up(jj,1) = exp(-r*(T1))*max((Fup_T1-K1),0);
    
end

%figure
%histogram(C_0);
 
call_price = sum(C_0)/M;
call_priceup = sum(C_0up)/M;
sqre = (C_0 - call_price*ones(M,1)).^2;
est_variance = 1/(M-1)*sum( sqre );

if antithetic
   call_price = (sum(C_0)+sum(C_0up))/2/M;   %just overwrite the call_price if you use antithetic
   sqre =  ((C_0+C_0up)/2 - call_price*ones(M,1)).^2;
   %est_variance = 1/M * ( std((C_0+C_0up)/2) )^2; %this was used to get
   %the variance a different way that was also shown in the notes
   est_variance = 1/(M-1)*sum( sqre );
end

%display (call_price);
%display(call_priceup);


std_error = sqrt(est_variance/M);

%part f:
if antithetic == 0 
    call_delta = (call_priceup-call_price)/S_inc;
    df0 = (exp(-r*T2)*exp(-kappa*T2)*S0^(exp(-kappa*T2)-1)*exp(alpha*(1-exp(-kappa*T2)))*exp((sigma*sigma/4/kappa)*(1-exp(-2*kappa*T2))));
    fprintf('Part e answer:\n');
    display(df0);
    hedge = call_delta/df0;
    fprintf('Part f answer:\n');
    
    display(hedge);
    
end

%part g:
F0 = exp((exp(-kappa*T2)*log(S0) + alpha*(1-exp(-kappa*T2)) +(sigma*sigma/4/kappa)*(1-exp(-2*kappa*T2))));
theta_contract = 1000*exp(-r*T2)*( exp(r*T1)*call_price + 4*(F0-K1) );

fprintf('Part g:\n');
display(theta_contract);
%display(F0);
%display(K1);
end








