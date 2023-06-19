function LonD=LonDfunction(x)

b=x(1,:)';
c=x(2,:)';

% minb=30;
% maxb=60;
% minc=3;
% maxc=6;


%Wwing=(4.22*b.*c+1.6423e-6*(3.75*b.^3*8000*3)./(0.12*b.*c*2));
W=8000; %lbs
V=160*1.688; %ft/s
rho=0.001755; %slug/ft^3
q=0.5*rho*V^2; %lbs/ft^2

S=b.*c;
dqbody=7.3; % %ft^2
CD0body=dqbody./S;
CD0wing=0.0065*(5.5./c).^0.2;
CD0=CD0body+CD0wing;

AR=b./c;
e=0.75; %1./(1.05+0.007*pi*AR);%0.87;
K=1./(pi*AR.*e);

CL=W./q./S;
CD=CD0+K.*CL.^2;

LonD=CL./CD;


