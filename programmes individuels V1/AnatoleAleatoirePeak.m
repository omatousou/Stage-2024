

figure
peak =randi([510,553])
width = 10;
calibration2 = (mod(phase2LP,+180)+mod(phase2SP,+180))/2;
anglei1 = rad2deg(asin(neffSP*sqrt(1- ((peak+width/3) / x0SP)^2)));
anglei2 = rad2deg(asin(neff2LP*sqrt(1- ((peak-width/3) / x2LP)^2)));
[x, y] = Anatole_spectro_mirrror(calibration2+abs(anglei2), spectro,2);
[x, y] = Anatole_spectro_mirrror(calibration+abs(anglei1), spectro,1);
med=medfilt1(y, 3);
sig = (med-min(med))/max(med-min(med));
[outliers, TF] = rmoutliers(sig, 'grubbs');
% Interpolation linéaire pour remplacer les outliers
x_2 = 1:length(sig);
sig_cleaned = sig;
sig_cleaned(TF) = interp1(x_2(~TF), sig(~TF), x_2(TF), 'linear');
a = fft(sig);
a(75:1925)=0;
b = ifft(a);
ynew= abs(b);
ynew(1800:end)=0;
abse = ynew>0.5;
ABSfirst = find( abse == 1, 1, 'first' );
ABSlast = find( abse == 1, 1, 'last' );
distance = x(ABSlast)-x(ABSfirst),
locationPeak = (x(ABSlast)+x(ABSfirst))/2
plot(x,ynew)