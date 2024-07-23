function Anatole_moove_system(theta1,theta2,theta3, calibration, calibration2, calibration3)
mir = elliptec_driver([1,2,3],'COM8');
p=set_position(mir,1,theta1 + calibration);
p=set_position(mir,2,theta2 + calibration2);
p=set_position(mir,3,theta3 + calibration3);
end