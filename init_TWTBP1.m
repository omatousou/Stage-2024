function init_TWTBP1(app) % turn on the first he first arm 1 with two filters and a plate ( 3 elliptec devices)
% filter set n°1
address = [0 1 2 3] % 0: linear 1-2-3: rotation stages
ELL_TWTBP1= elliptec_driver(address,"COM5");

app.InstrInfo.ELL_TWTBP1 = ELL_TWTBP1;

for i=1:length(address)
    pos=get_position(ELL_TWTBP1, address(i));

    stepsize = 5;
    set_jogstep(ELL_TWTBP1, address(i),stepsize);

    switch address(i)
        case 1
            app.ReadoutEditField.Value = pos;
            app.StepEditField.Value = stepsize;
        case 2
            app.ReadoutEditField_2.Value = pos;
            app.StepEditField_2.Value = stepsize;
        case 3
            app.ReadoutEditField_3.Value = pos;
            app.StepEditField_3.Value = stepsize;
        otherwise
    end
end