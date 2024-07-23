name=LastMap;
LM=name.LaMap;
[~,calib]=ATSpectrographGetCalibration(0,2000);
LP=name.LesPos;
%%
Z=sum(LM,3);
%Z=max(LM,[],3);
% Z(Z>00) = NaN;

xpix = [9 22 7 4 13 25];
ypix = [28 40 31 10 10 18];

xpix=xpix(3:5);
ypix=ypix(3:5);
% 
% xpix = [xpix 27 27 14 4];
% ypix = [ypix 27 9 40 10];

% 
xpix=3;
ypix=20;

figure
nexttile
imagesc(1:30,1:30,Z)
pbaspect([1 1 1])
colorbar
nexttile
hold on
for i=1:length(xpix)
Z_s = squeeze(LM(xpix(i),ypix(i),:));
plot(Z_s)
end

x_coor=LP(xpix,ypix,1)
y_coor=LP(xpix,ypix,2)