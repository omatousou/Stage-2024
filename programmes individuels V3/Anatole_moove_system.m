function [p1,p2,p3] = Anatole_moove_system(theta1,theta2,theta3, calibration1, calibration2, calibration3,com)
if ~ischar(com)
        if isstring(com)
            com = char(com);
        else
            error('com input is not the wright output')
        end
    end
mir = elliptec_driver([1,2,3],com);
p1=set_position(mir,1,theta1 + calibration1);
p2=set_position(mir,2,theta2 + calibration2);
p3=set_position(mir,3,theta3 + calibration3);
end