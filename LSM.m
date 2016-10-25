function putprice = LSM(contract,dynamics,MC)
%Do not change the header

r=dynamics.r;
sigma=dynamics.sigma;
S0=dynamics.S0;

K=contract.K;
T=contract.T;

N=MC.N;
M=MC.M;
dt=T/N;

randn('state',MC.randnSeed);
Z=randn(M,N);

paths = S0*exp((r-sigma^2/2)*dt*repmat(1:N,M,1)+sigma*sqrt(dt)*cumsum(Z,2));

payoffDiscounted = max(zeros(M,1),K-paths(:,N));
%This is the payoff (cashflow) along each path,
%discounted to time n (for n=N,N-1,...)
%It corresponds to the far right-hand column in each page of the
%Excel worksheet
%I'm initializing it for time n=N.

%You could make payoffDiscounted
%to be a matrix because it depends on n.
%But I will just reuse a column vector, by
%overwriting the time n+1 entries at time n.

for nn=N-1:-1:1
    continuationPayoffDiscounted = exp(-r*dt)*payoffDiscounted; 
    %This is the CONTINUATION payoff (cashflow) along each path,
    %discounted to time n (for n=N,N-1,...)
    %It corresponds to the blue column in each page of the Excel worksheet
    %Note that payoffDiscounted comes from the previous iteration 
    % -- which was at time nn+1.  So now we discount back to time nn.
    
    X= paths(:,nn);              % FILL THIS IN
    basisfunctions = [ones(length(X),1) , X , X.^2 ]; % FILL THIS IN.  This will be a M-by-3 matrix containing 
            % the basis functions (Same ones as L7.8-7.9, and Excel)
            
    
    coefficients = regress(continuationPayoffDiscounted(X<K,:),basisfunctions(X<K,:)) ;
    %coefficients = basisfunctions(X<K,:)\continuationPayoffDiscounted(X<K) ; % FILL THIS IN.  This will be a 3-by-1 vector of estimated "betas".
    estimatedContinuationValue = basisfunctions*coefficients ; % FILL THIS IN with an M-by-1 vector.
                                 % This is similar to the Red column in Excel
    exerciseValue = K-X;
    whichPathsToExercise = (exerciseValue >= max(estimatedContinuationValue,0) );
    %This is an M-by-1 logical array.  If unfamiliar, type 'help logical'.
    
    payoffDiscounted(whichPathsToExercise) = exerciseValue(whichPathsToExercise) ;     % FILL THIS IN
    payoffDiscounted(not(whichPathsToExercise)) = continuationPayoffDiscounted(not(whichPathsToExercise)) ; % FILL THIS IN
end

% The time-0 calculation needs no regression
continuationPayoffDiscounted = exp(-r*dt)*payoffDiscounted;
estimatedContinuationValue = mean(continuationPayoffDiscounted);
putprice = max(K-S0,estimatedContinuationValue);
