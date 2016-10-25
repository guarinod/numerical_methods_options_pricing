%trinomHW2

function [answer_part_a,answer_part_b] = trinomHW2(contract,dynamics,tree)
%Do not modify the header.

S_0         = dynamics.S_0;
sigma_ave   = localvol(S_0,0);          
r           = dynamics.r;
q           = dynamics.q;   
putexpiry   = contract.putexpiry;
putstrike   = contract.putstrike;
callexpiry  = contract.callexpiry;
callstrike  = contract.callstrike;
N           = tree.N; %number of steps after time-0

%Price an option in a trinomial tree.  
%N=number of time intervals, so there are N+1 different times in the tree, 
%including 0 and T.

deltat= putexpiry/N ;    %this is the length of each time step
deltax=  max(sigma_ave*sqrt(3*deltat), 0.6*sqrt(deltat));    %this is the increment in log stock price for each time step
%display(deltax);
%display(0.6*sqrt(deltat));
%display(deltax);
%display(sigma*sqrt(deltat*3));
S=S_0*exp((N:-1:-N)*deltax)';  %I chose to make the SMALLER indexes in this 
                               %COLUMN VECTOR to correspond to HIGHER S.
                               %remember that you multiply because the log 
                               %prices are getting added at each time

if abs(callexpiry/deltat-round(callexpiry/deltat)) > 1e-12   %checks to see
                              %if the call expiry will fall on one of the
                              %time steps
  error('This value of N fails to place the observation dates in the tree')
end



%create functions to get RN probabilities given a value of sigma
nu = @(sigma)((r-q) - 0.5*(sigma.*sigma)) ;          
Pu = @(sigma,nu)(0.5*((sigma.*sigma*deltat+nu.*nu*deltat*deltat)/(deltax*deltax)...
    + (nu*deltat)/deltax   )) ;          
Pm = @(sigma,nu)(1- (sigma.*sigma*deltat+nu.*nu*deltat*deltat)/(deltax*deltax)) ;          
Pd = @(sigma,nu)(0.5*((sigma.*sigma*deltat+nu.*nu*deltat*deltat)/(deltax*deltax)...
    - (nu*deltat)/deltax   )) ;          

put_option=max(putstrike-S,0);  %initialize the put_option values for expiry



switch_ = 0;

for n=(N-1:-1:0) %time step index. will iterate backwards from expiry
    t = n*deltat; %time value at this index
    
    sigma_ = localvol(S(N+1-n:N+1+n,1),t);%this will be a vector of sigmas for each node of 
                         %the tree at this time step/iteration

    %sigma_ = .3*ones(2*n+1,1);   % I use this line to test the code for pricing
                                  %American Puts
    nu_ = nu(sigma_);             %the following commands create vectors for
    Pu_ = Pu(sigma_,nu_);         %the RN probabilities at each node at this
    Pm_ = Pm(sigma_,nu_);         %time step
    Pd_ = Pd(sigma_,nu_);
    %display([Pu_,Pm_,Pd_]);
    
    %Now calculate the put price at this point on the tree
    put_option= exp(-r*deltat)*(Pu_.*put_option(1:end-2,1)+Pm_.*put_option(2:end-1,1)+...
        Pd_.*put_option(3:end,1));
    %now take into account the owner's ability to exercise the option
    put_option = max(max(putstrike-S(N+1-n:N+1+n,1),0),put_option); %tests to see if knockout
    
    %calculations for the compound option price
    if switch_ == 1
        %this computes the option price, assuming the compound option has
        %been initialized (happens at t = callexpiry)
        compound_option= exp(-r*deltat)*(Pu_.*compound_option(1:end-2,1)+Pm_.*compound_option(2:end-1,1)+...
              Pd_.*compound_option(3:end,1));
    end
    
    if abs(t-callexpiry) < 1e-12        %when t=callexpiry, start computing compound option
        switch_ = 1;             %this is necessary for above conditional statement
        compound_option = max(put_option-callstrike,0); %this initializes the compound option
    end
    %display(put_option);
end
answer_part_a = put_option ;  %Fill this in with a scalar, the time-0 option price
answer_part_b = compound_option;


