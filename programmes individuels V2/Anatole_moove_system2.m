function Anatole_moove_system2(theta1,theta2,neffLP,neffSP,neff2LP,neff2SP,calibration,calibration2,calibration3)
theta3 =  Anatole_calcul_theta3(theta1,theta2,neffLP,neffSP,neff2LP,neff2SP);
mir = elliptec_driver([1,2,3],'COM8');
p=set_position(mir,1,theta1 + calibration);
p=set_position(mir,2,theta2 + calibration2);
p=set_position(mir,3,theta3 + calibration3);
end