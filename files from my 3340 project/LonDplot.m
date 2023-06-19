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