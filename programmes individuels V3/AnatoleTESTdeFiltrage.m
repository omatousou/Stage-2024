angle_0 =-2.4;

%[x, y,p] = Anatole_spectro_mirrror(angle_0-90, spectro,3);
[x, y,p] = Anatole_spectro_mirrror(angle_0, spectro,3);
[x, y,p] = Anatole_spectro_mirrror(calibration2-90, spectro,2);
[x, background,p] = Anatole_spectro_mirrror(calibration-90, spectro,1);
pause(3)

%Anatole_moove_lame(0,0,calibration,calibration2,neffLP,neffSP,neff2LP,neff2SP)
[x, light,p] = Anatole_spectro_mirrror(calibration-90, spectro,1);

peaks=randi([520,550],1,20);%randi([510,round(x2LP-1)],1,30);
sigmas = ones(1,20);%randi([1,10],1,30);
ERR = zeros(30,2);
j = 1;
for i =1:20
    fprintf('peak =')
    disp(peaks(i))
    fprintf('\nsigma = ')
    disp(sigmas(i))
    fprintf('\n')
    [theta1,theta2] = Anatole_Calcule_des_Angles(peaks(i),sigmas(i),x2LP,x0SP,neffSP,neff2LP,phaseSP,phase2LP);
    fprintf('angle mirroire 2 = ')
    %Anatole_moove_lame(theta1,theta2,calibration,calibration2,neffLP,neffSP,neff2LP,neff2SP)
    [x, y,p] = Anatole_spectro_mirrror(theta2+calibration2, spectro,2);
    fprintf('angle mirroire 1 = ')
    Anatole_moove_lame(theta1,theta2,neffLP,neffSP,neff2LP,neff2SP,angle_0)
    [x, y,p] = Anatole_spectro_mirrror(theta1+calibration-0.25, spectro,1);
    fprintf('\n')  
    sig = ((y-background)./(light-background));
    DERIV = normalize(((y-background)./(light-background)),'range')>0.3;
    Xfirst = find( DERIV == 1, 1, 'first' );
    Xlast = find( DERIV == 1, 1, 'last' );
    subplot(3,1,mod(j,3)+1)
    h1=plot(x,(y-background)./(light-background),'Color',[0,0,1,1],'DisplayName','fonction de transfert')
    hold on
    %plot(x,(light-background),'Color',[1,0,0,1])  
    h2=plot([peaks(i)+sigmas(i),peaks(i)+sigmas(i)],[0,1],'Color',[0,1,0,1],'DisplayName','bornes souhaités');
    h3=plot([peaks(i)-sigmas(i),peaks(i)-sigmas(i)],[0,1],'Color',[0,1,0,1]);
    h4=plot([peaks(i),peaks(i)],[0,1],'Color',[1,0,0,1],'DisplayName','pic souhaité');
    xlabel('wavelength \lambda nm')
    ylabel('transmittance')

    locmax(j) = x(find(y==max(y)));
    j=j+1;
    if isempty(Xlast)==0 || isempty(Xfirst)==0
        if (x(Xlast)-x(Xfirst))  <25
            freq =[x(Xfirst),x(Xlast)];
    
            fprintf("ADDED\n")
            hold on
            h5=scatter([x(Xfirst),x(Xlast)],[sig(Xfirst),sig(Xlast)]);
            ERR(i,1) = (peaks(i) - sigmas(i))-x(Xfirst);
            ERR(i,2) = (peaks(i) + sigmas(i))-x(Xlast);
            fprintf('err1 = ')
            disp(ERR(i,1))
            fprintf('\nerr2 = ')
            disp(ERR(i,2))
            fprintf('\n')
            pause(0.3)
            grid()
            hold off
        end
    end
    legend([h1,h2,h4])
    hold off
    pause(0.3)
end
figure
subplot(4,1,1)
scatter(1:20,locmax,Marker="+")
hold on
scatter(1:20,peaks,Marker="+")
legend('Peak mesurements','Peak asked','Location','northwest')
grid()
xlabel('attempt')
ylabel('wavelength \lambda nm')
title('mesure des pics')
subplot(4,1,2)
histogram(peaks-locmax);
legend('erreur pics')
xlabel('Distance par rapport à la valeur attendue en nm')
ylabel('occurence')
subplot(4,1,3)
histogram(ERR(1:20,1));
legend('erreur borne inf')
xlabel('Distance par rapport à la valeur attendue en nm')
ylabel('occurence')
subplot(4,1,4)
histogram(ERR(1:20,2));
legend('erreur borne sup')
xlabel('Distance par rapport à la valeur attendue en nm')
ylabel('occurence')