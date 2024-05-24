classdef BP
    properties
        wvlgt = linspace(300, 800, 1001);
        agl = 0;
        transfunc;
        leftbond;
        rightbond;
        center;
        shift = 0; % Initialisation de shift à 0
        border = 50;
    end

    methods
        function bp = BP(ctr)
            if nargin > 0 % Vérifiez si ctr est fourni
                if (ctr>=300) || (ctr<=800)
                bp.transfunc = bp.wvlgt;
                bp.center = ctr;
                bp.rightbond = bp.center + bp.border;
                bp.leftbond = bp.center - bp.border;
                bp.transfunc =  bp.transfunc./bp.transfunc;
                bp.transfunc(1:1001< bp.leftbond)=0;
                bp.transfunc(1:1001> bp.rightbond)=0;
                else
                    error("not in visible light")
                end

            end
        end

        function bp = convert(bp, angle)
            % Ajustement du calcul du décalage
            bp.shift = 15 * asind((angle - 90) / 90) / 180 + 0.5 * 15;
        end

        function bp = swh_agl(bp, theta)
            bp.agl = theta;
            bp = bp.convert(theta); % Assurez-vous que le décalage est recalculé
            bp.center = bp.center + bp.shift;
            bp.rightbond = bp.rightbond + bp.shift;
            bp.leftbond = bp.leftbond + bp.shift;
            bp.transfunc(1:1001< bp.rightbond)=0;
            bp.transfunc(bp.rightbond:1001<= bp.leftbond)=1;
            bp.transfunc(bp.rightbond:1001< bp.leftbond)=0;
        end
        function plot(bp)
            plot(bp.wvlgt,bp.transfunc)
        end

    end
end
