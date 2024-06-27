
[~, ~,~] = Anatole_spectro_mirrror(85+, spectro,3);
[~, y,~] = Anatole_spectro_mirrror(calibration2+90, spectro,2);
[~, background,~] = Anatole_spectro_mirrror(calibration-90, spectro,1);
pause(3)

[~, light,~] = Anatole_spectro_mirrror(calibration-90, spectro,1);

peaks=-2:60;

e = 0.002;
e3 = 0.005;
neff = (neffLP+neffSP)/2;
neff2 = (neff2LP+neff2SP)/2;
nair = 1.000293;
nlame3=1.458;

for i =peaks


    i1 = asin(nair/neff*sin(deg2rad(i)));
    DE1 = e*sin(deg2rad(i)-i1)/cos(i1);
    
    theta3 = rad2deg(-(DE1)/(e3*(1-nair/nlame3)));
    [~, ~,~] = Anatole_spectro_mirrror(theta3+43, spectro,3);
    fprintf('peak =')
    fprintf('angle mirroire 1 = ')
    [x, y,~] = Anatole_spectro_mirrror(calibration + i, spectro,1);
    
    sig = ((y-background)./(light-background));
    DERIV = normalize(((y-background)./(light-background)),'range')>0.3;
    Xfirst = find( DERIV == 1, 1, 'first' );
    Xlast = find( DERIV == 1, 1, 'last' );
    plot(x,(y-background)./(light-background),'Color',[0,0,1,1])
    DATAFT2(i+3,:) = (y-background)./(light-background);
    hold on

    if isempty(Xlast)==0 || isempty(Xfirst)==0
        if (x(Xlast)-x(Xfirst))  <25
            freq =[x(Xfirst),x(Xlast)];
    
            fprintf("ADDED\n")
            hold on
            scatter([x(Xfirst),x(Xlast)],[sig(Xfirst),sig(Xlast)])
        end
    end
    hold off
    pause(0.3)
end
