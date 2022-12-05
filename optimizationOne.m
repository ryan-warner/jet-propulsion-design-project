function optimizationOne

function [ineq,eq]=WSmaxfun(x)

b=x(1,:);
c=x(2,:);

W=8000; %lbs

eq=[];
ineq=W./(b.*c)-40;

end

% Set up fmincon and run optimization 
ARmaxconstr=10;  % Maximum allowable AR
bmaxconstr=55;   % Maximum allowable span
WSmaxconstr=40;  % Maximum allowable wing loading

x0=[50;5]; % Optimizer starting point
rhs=0; % RHS vector of linear inequality constraint for max AR
A=[1 -ARmaxconstr]; % LHS matrix for linear inequality constraint for max AR
lb=[30;4]; % Lower bounds. Set by range on plot
ub=[bmaxconstr;6]; % Upper bounds. Set by maximum span and upper bound on plot for c.
fun=@(x)-LonDfunction(x);
nonlincon=@WSmaxfun;
options=optimoptions(@fmincon,'Display','iter','Algorithm','sqp');
[xopt,fopt,exitflag,output,lambda,gradf,hessianf] = fmincon(fun,x0,A,rhs,[],[],lb,ub,nonlincon,options)


% Can use fmincon to build a matrix of equality and inequality constraints,
% particularly w.r.t max and mins 
% 
% Will need to create a function that outputs an array we can match to the
% constraints we want to solve for.
%
% Might have to fsolve for specific thrust at the given inputs to
% determine whether or not our guess is good?

end