clear all
close all

% Generate data for contour plot
nptsb=500;
nptsc=500;
minb=30;
maxb=60;
minc=3;
maxc=6;
[b,c]=meshgrid(linspace(minb,maxb,nptsb),linspace(minc,maxc,nptsc));
x=[b(:)';c(:)'];
LonD=reshape(LonDfunction(x),nptsb,nptsc);


% Plot and label contour plot
figure(1)
bnorm=(b-minb)/(maxb-minb);
cnorm=(c-minc)/(maxc-minc);
minlevel=ceil(10*min(min(LonD)))/10;
maxlevel=floor(10*max(max(LonD)))/10;
levels=(minlevel:0.2:maxlevel)';
[chandle1,hhandle1]=contour(bnorm,cnorm,LonD,levels,'k');
clabel(chandle1,hhandle1,levels);
axis([0 1 0 1])
axis square
xlabel('Normalized Span (b)')
ylabel('Normalized Chord (c)')

% Overlay the constraint boundaries
hold on
bvals=(minb:0.01:maxb)';
cminAR=bvals./10;
cminWS=8000./(40*bvals);
bvalsnorm=(bvals-minb)/(maxb-minb);
cminARnorm=(cminAR-minc)/(maxc-minc);
cminWSnorm=(cminWS-minc)/(maxc-minc);

hhandle2=hatchedline(bvalsnorm',cminARnorm','r');
hhandle3=hatchedline(bvalsnorm',cminWSnorm','r');
hhandle4=hatchedline([(55-minb)/(maxb-minb);(55-minb)/(maxb-minb)],[0;1],'r');
hold off

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
formatSpec = ' ';
lambdaUpper=lambda.upper
lambdaLower=lambda.lower
fprintf(formatSpec, lambdaUpper, lambdaLower)
% Plot optimum and gradient of function at optimum
LonDopt=-fopt;
xoptnorm=[(xopt(1)-minb)/(maxb-minb);(xopt(2)-minc)/(maxc-minc)];
scale=0.2;
gradfnorm=scale*[gradf(1)*(maxb-minb); gradf(2)*(maxc-minc)];
hold on
arrow(xoptnorm,(xoptnorm+gradfnorm))
plot(xoptnorm(1),xoptnorm(2),'bo','MarkerFaceColor','b')
%[chandle1,hhandle1]=contour(bnorm,cnorm,LonD,[levels; -fopt],'k');
%clabel(chandle1,hhandle1,[levels; -fopt]);
hold off