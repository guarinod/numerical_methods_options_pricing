function [r,bondprice]=vasicek(contract,dynamics,FD)
% returns a vector of all initial short rates,
% and the corresponding vector of zero-coupon
% T-maturity bond prices

T=contract.T;

kappa=dynamics.kappa;
theta=dynamics.theta;
sigma=dynamics.sigma;

rMax=FD.rMax;
rMin=FD.rMin;
deltar=FD.deltar;
deltat=FD.deltat;
N=round(T/deltat);

nu = @(kappa_,theta_,rt)( kappa_ * (theta_ - rt) );          
Qu = @(alpha)(0.5*((sigma*sigma*deltat + deltar*alpha*deltat)/(deltar*deltar)) ) ;          
Qm = @(alpha)(1- (sigma*sigma*deltat)/(deltar*deltar) )     ;          
Qd = @(alpha)(0.5*((sigma*sigma*deltat-deltar*alpha*deltat)/(deltar*deltar))  )   ; 

if abs(N-T/deltat) > 1e-12         %just checking to see if the inputs are good
  error('Bad delta t')
end

r=(rMax:-deltar:rMin)';         %initializing a vector of rates
bondprice=ones(size(r));        %just initializing a vector that will store bond prices

nu_ = nu(kappa,theta,r);

if FD.useUpwind < 0.5
  %if deltar > sigma*sigma/max(abs(nu_))
  %    error('Unstable');
  %end
  %if deltat > deltar/(sigma*sigma)
  %    error('Unstable');
  %end    
  qu= Qu(nu_);
  qd= Qd(nu_); 
  qm= Qm(nu_); 
else
  if deltat > deltar*deltar/(sigma*sigma+max(abs(nu_))*deltar)
      error('Unstable');
  end    
  qu= (Qu(nu_) + 0.5*nu_*deltat/deltar).*(nu_.*ones(size(r))>=0)+...
      (Qu(nu_) - 0.5*nu_*deltat/deltar ).*(nu_.*ones(size(r))<0) ;  
  display(qu);
  qm=  (Qm(nu_) - nu_*deltat/deltar).*(nu_.*ones(size(r))>=0)+...
      (Qm(nu_) + nu_*deltat/deltar ).*(nu_.*ones(size(r))<0) ;  
  qd=  (Qd(nu_) + 0.5*nu_*deltat/deltar).*(nu_.*ones(size(r))>=0)+...
      (Qd(nu_) - 0.5*nu_*deltat/deltar ).*(nu_.*ones(size(r))<0) ;
end
for t=(N-1:-1:0)*deltat,
  bondprice=1./(1+r*deltat).*(qd.*[bondprice(2:end);0]+qm.*bondprice+qu.*[0;bondprice(1:end-1)]);

  % It is not obvious in this case, 
  % what boundary conditions to impose,
  % so let us impose "linearity" boundary conditions:
  bondprice(1)=2*bondprice(2)-bondprice(3);
  bondprice(end)=2*bondprice(end-1)-bondprice(end-2);
end
