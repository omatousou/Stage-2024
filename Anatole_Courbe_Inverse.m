function RES = Anatole_Courbe_Inverse(Lambda0,Neff,Phase,x)
    RES = rad2deg(asin( Neff .* sqrt( 1 - ([x]/Lambda0).^2 ) ))+ Phase;
end