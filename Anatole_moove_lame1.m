function Anatole_moove_lame1(theta1,calibration)
    e = 0.002;
    e3 = 0.005;
    t1 = deg2rad(theta1-calibration);
    neff = 1.88;
    nair = 1.000293;
    i1 = asin(nair/neff*sin(t1));
    DE1 = e*sin(t1-i1)/cos(i1);
    nlame3=1.458;
    theta3 = rad2deg(-(DE1)/(e3*(1-nair/nlame3)));
    mir = elliptec_driver([1,2,3],'COM8');
    p=set_position(mir,3,theta3+120.4);
end