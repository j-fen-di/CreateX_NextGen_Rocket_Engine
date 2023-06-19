function [ineq,eq]=WSmaxfun(x)

b=x(1,:);
c=x(2,:);

W=8000; %lbs

eq=[];
ineq=W./(b.*c)-40;
