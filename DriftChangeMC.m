function [call_price, std_err] = DriftChangeMC(contract,dynamics,MC)
S0         = dynamics.S0;
r          = dynamics.r;
sigma      = dynamics.sigma;
K          = contract.K ;
T          = contract.T;
randnseed  = MC.randnseed;
M          = MC.M;  % Number of paths.
lambda     = MC.lambda;  % Zero drift adjustment gives ordinary MC
randn('state',MC.randnseed)


%Do the calculations under normal measure
if MC.ind
    fprintf('\nordinary working\n')
    C_est = 0; 
    Y = zeros(M,1);
    for ii=1:M
        ST = S0*exp((r-1/2*(sigma)^2)*T+sigma*randn(1));
        Y(ii,1) = max(ST-K,0)*exp(-r*T);
        C_est = C_est + Y(ii,1);
    end
    %display(Y(1:100,1));
    C_est = C_est/M;
    call_price = C_est;
    std_err = sqrt( (sum((Y - ones(M,1)*C_est).^2)/(M-1)) / M ) ;
    fprintf('\nordinary MC finished');
else
%Do the calculations under tilted measure
    fprintf('\nIS working\n')
    C_est = 0; 
    Y = zeros(M,1);
    for ii=1:M
        random = randn(1);
        ST = S0*exp( (r+sigma*(lambda-1/2*sigma))*T + sigma*random );
        Y(ii,1) = max(ST-K,0)*exp(-r*T)*exp(-lambda*random-1/2*lambda^2*T);
        C_est = C_est + Y(ii,1);
    end
    %display(Y(1:100,1));
    C_est = C_est/M;
    call_price = C_est;
    std_err = sqrt( (sum((Y - ones(M,1)*C_est).^2)/(M-1)) / M ) ;
    fprintf('\nImportance sampled MC finished');
end