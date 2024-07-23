[~, ~,~] = Anatole_spectro_mirrror(-3.5-90, spectro,3);
[~, noir,~] = Anatole_spectro_mirrror(-3.5-90, spectro,3);
pause(3)
[x, background,~] = Anatole_spectro_mirrror(calibration-90, spectro,1);
subplot(2,1,1)
hold on
plot(x, (background-min(background))/(max(background)-min(background)))

for i = [0,20,40]
subplot(2,1,1)

hold on
[~, ~,~] = Anatole_spectro_mirrror(-3.5-90, spectro,3);
[x, yfiltre,~] = Anatole_spectro_mirrror(calibration+i, spectro,1);
plot(x, (yfiltre-min(background))/(max(background)-min(background)))

subplot(2,1,2)
hold on
plot(x,(yfiltre-noir)./(background-noir))



end
subplot(2,1,1)
legend('LED','Filtre :\theta = 0°','Filtre :\theta = 20°','Filtre :\theta = 40°', 'Location', 'northwest');
grid('minor')
title("Spectre normalisé: LED et LED x filtre pour différentes rotations \theta")
xlabel('$\lambda$ nm', 'Interpreter', 'latex')
ylabel('Intensity', 'Interpreter', 'latex')

subplot(2,1,2)
xlabel('$\lambda$ nm', 'Interpreter', 'latex')
ylabel('transmitance', 'Interpreter', 'latex')
title('Fonction de transfert du filtre :  FT Filtre = (LED x Filtre) ÷ LED')
legend('\theta = 0°','\theta = 20°','\theta = 40°', 'Location', 'northwest')
grid('minor')

% [~, ~,~] = Anatole_spectro_mirrror(-3.5-90, spectro,3);
% [~, noir,~] = Anatole_spectro_mirrror(-3.5-90, spectro,3);
% pause(3)
% [x, background,~] = Anatole_spectro_mirrror(calibration-90, spectro,1);
% subplot(3,1,1)
% hold on
% plot(x, (background-min(background))/(max(background)-min(background)))
% [~, lame,~] = Anatole_spectro_mirrror(-3.5, spectro,3);
% plot(x, (lame-min(background))/(max(background)-min(background)))
% for i = [0,20,40]
% subplot(3,1,1)
% xlabel('$\lambda$ nm', 'Interpreter', 'latex')
% ylabel('Intensity', 'Interpreter', 'latex')
% xlim([450,600])
% hold on
% 
% hold on
% [~, ~,~] = Anatole_spectro_mirrror(-3.5-90, spectro,3);
% [x, yfiltre,~] = Anatole_spectro_mirrror(calibration+i, spectro,1);
% plot(x, (yfiltre-min(background))/(max(background)-min(background)))
% [~, ~,~] = Anatole_spectro_mirrror(-3.5, spectro,3);
% [x, yfiltrelame,~] = Anatole_spectro_mirrror(calibration+i, spectro,1);
% plot(x, (yfiltrelame-min(background))/(max(background)-min(background)))
% legend('LED', 'LED x Lame','spectre 1 : 0°','spectre 2 : 0°' ...
%     ,'spectre 1 : 20°','spectre 2 : 20°' ...
%     ,'spectre 1 : 40 °','spectre 2 : 40°', 'Location', 'northwest');
% grid()
% title('Spectre 1 : LED x Filtre | Spectre 2 : LED x Filtre x Lame')
% hold on
% subplot(2,1,2)
% xlabel('$\lambda$ nm', 'Interpreter', 'latex')
% ylabel('transmitance', 'Interpreter', 'latex')
% plot(x,(yfiltre-noir)./(background-noir))
% hold on
% plot(x,(yfiltrelame-noir)./(lame-noir))
% title('FT Filtre = (LED x Filtre) ÷ LED et  FT Filtre =(LED x Filtre x Lame) ÷ (LED x Filtre)')
% legend('0°','20°','40°', 'Location', 'northwest')
% grid()
% xlim([450,600])
% 
% end