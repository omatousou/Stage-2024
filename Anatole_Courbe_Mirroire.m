function RES =  Anatole_Courbe_Mirroire(Lambda0,Neff,Phase,x)
    RES = Lambda0 .* sqrt(1 - (sin(deg2rad(x-Phase))./Neff).^2);
end