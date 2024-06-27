
[x, y,p] = Anatole_spectro_mirrror(142, spectro,3);
[x, y,p] = Anatole_spectro_mirrror(calibration2+90, spectro,2);
[x, background,p] = Anatole_spectro_mirrror(calibration-90, spectro,1);
pause(3)
%Anatole_moove_lame(0,0,calibration,calibration2,neffLP,neffSP,neff2LP,neff2SP)
[x, light,p] = Anatole_spectro_mirrror(calibration+90, spectro,1);

peaks=randi([510,round(x2LP-1)],1,30);
sigmas = randi([1,10],1,30);
ERR = zeros(30,2);
for i =1:20
    fprintf('peak =')
    disp(peaks(i))
    fprintf('\nsigma = ')
    disp(sigmas(i))
    fprintf('\n')
    [theta1,theta2] = Anatole_Calcule_des_Angles(peaks(i),sigmas(i),x2LP,x0SP,neffSP,neff2LP,phaseSP,phase2LP);
    fprintf('angle mirroire 2 = ')
    %Anatole_moove_lame(theta1,theta2,calibration,calibration2,neffLP,neffSP,neff2LP,neff2SP)
    [x, y,p] = Anatole_spectro_mirrror(theta2, spectro,2);
    fprintf('angle mirroire 1 = ')
    Anatole_moove_lame(theta1,theta2,calibration,calibration2,neffLP,neffSP,neff2LP,neff2SP)
    [x, y,p] = Anatole_spectro_mirrror(theta1, spectro,1);
    fprintf('\n')  
    sig = ((y-background)./(light-background));
    DERIV = normalize(((y-background)./(light-background)),'range')>0.3;
    Xfirst = find( DERIV == 1, 1, 'first' );
    Xlast = find( DERIV == 1, 1, 'last' );
    plot(x,(y-background)./(light-background),'Color',[0,0,1,1])
    hold on
    %plot(x,(light-background),'Color',[1,0,0,1])  
    plot([peaks(i)+sigmas(i),peaks(i)+sigmas(i)],[0,1],'Color',[0,1,0,1])
    plot([peaks(i)-sigmas(i),peaks(i)-sigmas(i)],[0,1],'Color',[0,1,0,1])

    if isempty(Xlast)==0 || isempty(Xfirst)==0
        if (x(Xlast)-x(Xfirst))  <25
            freq =[x(Xfirst),x(Xlast)];
    
            fprintf("ADDED\n")
            hold on
            scatter([x(Xfirst),x(Xlast)],[sig(Xfirst),sig(Xlast)])
            ERR(i,1) = (peaks(i) - sigmas(i))-x(Xfirst);
            ERR(i,2) = (peaks(i) + sigmas(i))-x(Xlast);
            fprintf('err1 = ')
            disp(ERR(i,1))
            fprintf('\nerr2 = ')
            disp(ERR(i,2))
            fprintf('\n')
            pause(0.3)
            hold off
        end
    end
    hold off
    pause(0.3)
end
