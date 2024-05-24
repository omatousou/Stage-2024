[rawdata, rawWL, AOI] = init()
xq = linspace(375,625,2501);
yq = linspace(0,60,121);
data2 = interp2(rawdata,'cubic');
s=surf(xq,yq,data2,'FaceAlpha',0.5);
s.EdgeColor ='flat' 
dataemp = zeros(size(data2));
n = 38;
dataemp(n+1:end,:)=data2(1:end-n,:);
hold on
s2=surf(xq,yq,dataemp,'FaceAlpha',0.5);
s2.EdgeColor ='flat' 
