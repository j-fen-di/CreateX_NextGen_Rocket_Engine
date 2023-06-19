% optimizing turbojet performance with two/three constriants?

% Given values
T_a = 210; %K
P_a = 10000; %Pa
M = 2.6;

% initial f, f_ab, and Pr_c values
Pr_c = 25;
f = 0.015;
f_ab = 0.01;

% specific thrust formula
%ST = ((1 + f + f_ab).*(u_e - u)) + (Pe - Pa).*Ae ./ mdot_a;

% define max values
T0max=1300;  % maximum allowable stagnation temperature
bmax = 0.12;   % Maximum allowable span

x0=[Pr_c;f;f_ab]; % starting point
rhs=0; % RHS vector of linear inequality constraint for max b
A=[1 - bmax]; % LHS matrix for linear inequality constraint for max b
lb=[30;4]; % Lower bounds. Set by range on plot
%ub=[bmaxconstr;6]; % Upper bounds. Set by maximum span and upper bound on plot for c.
fun=@(x)-Turbojet_fun(x);
nonlincon=@WSmaxfun;
options=optimoptions(@fmincon,'Display','iter','Algorithm','sqp');
[xopt,fopt,exitflag,output,lambda,gradf,hessianf] = fmincon(fun,x0,A,rhs,[],[],lb,ub,nonlincon,options);
% Plot optimum and gradient of function at optimum
%LonDopt=-fopt;
%xoptnorm=[(xopt(1)-minb)/(maxb-minb);(xopt(2)-minc)/(maxc-minc)];
%scale=0.2;
%gradfnorm=scale*[gradf(1)*(maxb-minb); gradf(2)*(maxc-minc)];
%hold on
%plot(xoptnorm(1),xoptnorm(2),'bo','MarkerFaceColor','b')
%[chandle1,hhandle1]=contour(bnorm,cnorm,LonD,[levels; -fopt],'k');
%clabel(chandle1,hhandle1,[levels; -fopt]);
%hold off