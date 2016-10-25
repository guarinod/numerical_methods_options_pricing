function [S,putprice]=CEV(contract,dynamics,FD)
% returns a vector of all initial spots,
% and the corresponding vector of put prices
% Do not change the header.

volcoeff=dynamics.volcoeff;
alpha=dynamics.alpha;
r=dynamics.r;

T=contract.T;
K=contract.K;

% SMin and SMax denote the smallest and largest S in the _interior_.
% The boundary conditions are imposed one step _beyond_, 
% e.g. at S_lowboundary=SMin-deltaS, not at SMin.
% To relate to lecture notation, S_lowboundary is S_{-J}
% whereas SMin is S_{-J+1}

SMax=FD.SMax;
SMin=FD.SMin;
deltaS=FD.deltaS;
deltat=FD.deltat;
N=round(T/deltat);
if abs(N-T/deltat)>1e-12, error('Bad time step'), end
numS=round((SMax-SMin)/deltaS)+1;
if abs(numS-(SMax-SMin)/deltaS-1)>1e-12, error('Bad space step'), end
S=(SMax:-deltaS:SMin)';    %Column vector.  Small indices = High S
S_lowboundary=SMin-deltaS;

putprice=max(K-S,0);

ratio=deltat/deltaS;
ratio2=deltat/deltaS^2;
f= 0.5*volcoeff*volcoeff*S.^(2+2*alpha) ;   % You fill in with a vector of the same size as S.
g= S*r;   % You fill in with a vector of the same size as S.
h= -r*ones(length(S),1);   % You fill in with a vector of the same size as S (or a scalar is acceptable here)
F=0.5*ratio2*f+0.25*ratio*g;
G=    ratio2*f-0.50*deltat*h;
H=0.5*ratio2*f-0.25*ratio*g;
RHSmatrix=spdiags([H 1-G F],-1:1,numS,numS)';
LHSmatrix=spdiags([-H 1+G -F],-1:1,numS,numS)';

for t=(N-1:-1:0)*deltat,
  rhs=RHSmatrix*putprice;

  %Now I will add the boundary condition vectors.
  %They are nonzero only in the last component:
  rhs(end)=rhs(end)+2*H(end)*(K-S_lowboundary); 
  %do not need to alter the top value by -F_j-1 * S_highboundary because it
  %will be zero anyways
  
  
  putprice= max(LHSmatrix\rhs,max(K-S,0));  %You code this


end
