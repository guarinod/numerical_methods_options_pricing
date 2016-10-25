function price = trinom(contract,dynamics,tree)
%Do not modify the header.

S_0   = dynamics.S_0;
sigma = dynamics.sigma;          
r     = dynamics.r;

K        = contract.K;
T        = contract.T;
H        = contract.H;
interval = contract.observationinterval;

N        = tree.N; %number of steps after time-0

%Price an option in a trinomial tree.  
%N=number of time intervals, so there are N+1 different times in the tree, 
%including 0 and T.

deltat= T/N ;    %Fill this in with a scalar.
j = log(H/S_0)/(0.4*sqrt(3*deltat))-0.5;
j_m = (   abs(log(H/N)./(floor(j)+0.5)-sigma*sqrt(3*deltat))   >...
    abs(log(H/S_0)./(ceil(j)+0.5)-sigma*sqrt(3*deltat))  )  + floor(j);
deltax=  log(H/S_0)./(j_m+0.5);          %Fill this in with a scalar.
display(deltax);
display(sigma*sqrt(deltat*3));
S=S_0*exp((N:-1:-N)*deltax)';  %I chose to make the SMALLER indexes in this 
                               %COLUMN VECTOR to correspond to HIGHER S.
                               %remember that you multiply because the log 
                               %prices are getting added at each time

if abs(interval/deltat-round(interval/deltat)) > 1e-12
  error('This value of N fails to place the observation dates in the tree')
end

option=max(K-S,0);  %a VECTOR of terminal option prices (assuming a put).
                    %As we loop backwards in time, update this vector, 
                    %using its previously computed value.
%It is your choice, whether to make the vector shrink or stay the same size
%as you loop backward.
%If you make it stay the same size, then:
%only at time T are all 2*N+1 elements in the vector useful.  
%At other times, we can just ignore the contents of top cells 
%and bottom cells that don't correspond to nodes in the tree.

%display(option);


nu = r - 0.5*(sigma*sigma);          
Pu = 0.5*((sigma*sigma*deltat+nu*nu*deltat*deltat)/(deltax*deltax)...
    + (nu*deltat)/deltax   ) ;          
Pm = 1- (sigma*sigma*deltat+nu*nu*deltat*deltat)/(deltax*deltax)    ;          
Pd = 0.5*((sigma*sigma*deltat+nu*nu*deltat*deltat)/(deltax*deltax)...
    - (nu*deltat)/deltax   )     ;          
%display(Pu);
%display(Pm);
%display(Pd);
for t=(N-1:-1:0)*deltat
    n = round(t/deltat);
    option= exp(-r*deltat)*(Pu*option(1:end-2,1)+Pm*option(2:end-1,1)+...
        Pd*option(3:end,1));
    
    %a VECTOR of time-t option prices
    
    if abs(t/interval-round(t/interval)) < 1e-6
          option = option .* (S(N+1-n:N+1+n,1) < H ); %tests to see if knockout
    end
    
end
price=  option ;  %Fill this in with a scalar, the time-0 option price



