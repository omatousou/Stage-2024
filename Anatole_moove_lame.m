function Anatole_moove_lame(theta1,theta2,calibration,calibration2,neffLP,neffSP,neff2LP,neff2SP)
    e = 0.002;
    e3 = 0.005;
    t1 = deg2rad(theta1-calibration);
    neff = (neffLP+neffSP)/2;
    neff2 = (neff2LP+neff2SP)/2;
    nair = 1.000293;
    t2 = deg2rad(theta2-calibration2);
    i1 = asin(nair/neff*sin(t1));
    i2 = asin(nair/neff2*sin(t2));
    DE1 = e*sin(t1-i1)/cos(i1);
    DE2 = e*sin(t2-i2)/cos(i2);
    nlame3=1.458;
    theta3 = rad2deg(-(DE2+DE1)/(e3*(1-nair/nlame3)))
    mir = elliptec_driver([1,2,3],'COM8');
    p=set_position(mir,3,theta3+120.4);


end