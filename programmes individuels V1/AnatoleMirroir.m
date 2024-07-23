classdef AnatoleMirroir
    properties
        communicationChannel
        calibrationData
    end
    
    methods
        function obj = AnatoleMirroir(communicationChannel)
            obj.communicationChannel = communicationChannel;
        end
        
        function calibrationData = calibration(communicationChannel, range, spectro, mirror_nbr, axSpectrum)
            % Exécution du script de calibration
            
            % Appeler Anatole_spectro_mirrrorClass pour le premier miroir
            [~, ~, ~] = Anatole_spectro_mirrrorClass(-3.5-90, spectro, 3, obj.communicationChannel);

            % Initialisation des paramètres
            calibration2temp = -140; % Définir la valeur de calibration2 temporaire
            [~, ~, ~] = Anatole_spectro_mirrrorClass(calibration2temp + 90, spectro, mod(mirror_nbr,2)+1, obj.communicationChannel); % Pivot du deuxième miroir
            
            DATA = zeros(length(range), 2000); % Matrice de données d'acquisition
            SIG = DATA; % Matrice des signaux filtrés
            Xtemp = zeros(length(range), 2); % Matrice temporaire des positions X
            angletemp = zeros(size(range)); % Vecteur temporaire des angles

            % Boucle sur la plage d'angles
            hold(axSpectrum, 'on');
            xlabel(axSpectrum, '$\lambda$ nm', 'Interpreter', 'latex')
            ylabel(axSpectrum, 'Intensity', 'Interpreter', 'latex')
            for j = 1:length(range)
                i = range(j); % Angle courant
                [x, y, ~] = Anatole_spectro_mirrrorClass(i, spectro, mirror_nbr, obj.communicationChannel); 
                DATA(j, :) = y; % Stocker les données dans DATA

                % Tracer les données de spectroscopie pour l'angle courant
                plot(axSpectrum, x, y);

                % Appliquer un filtre médian pour lisser et normaliser les données
                sig = normalize(medfilt1(DATA(j, :), 3), 'range');
                SIG(j, :) = sig; % Stocker le signal normalisé dans SIG

                % Détecter les points où le signal dépasse un seuil (0.22)
                DERIV = sig > 0.22;
                Xfirst = find(DERIV, 1, 'first');
                Xlast = find(DERIV, 1, 'last');

                % Vérifier que les positions détectées sont valides
                if ~isempty(Xfirst) && ~isempty(Xlast) && (x(Xlast) - x(Xfirst)) > 5 && (x(Xlast) - x(Xfirst)) < 25
                    % Stocker les positions valides dans Xtemp
                    Xtemp(j, :) = [x(Xfirst), x(Xlast)];
                    angletemp(j) = i; % Stocker l'angle correspondant
                    fprintf("ADDED\n");
                    disp([x(Xfirst), x(Xlast), DATA(j, Xfirst), DATA(j, Xlast)]);

                    % Marquer les positions détectées sur le graphique
                    scatter(axSpectrum, [x(Xfirst), x(Xlast)], [DATA(j, Xfirst), DATA(j, Xlast)]);
                end
            end
            hold(axSpectrum, 'off');

            % Filtrer les positions valides stockées dans Xtemp
            valid_idx = Xtemp(:, 1) ~= 0;
            X = Xtemp(valid_idx, :);
            angle = angletemp(valid_idx);

            % Ajuster les courbes pour obtenir les paramètres de calibration
            [x0LP, neffLP, phaseLP, x0SP, neffSP, phaseSP] = AnatoleCurveFit(angle, X(:, 1), max(X(:, 1)), angle(X(:, 1) == max(X(:, 1))), X(:, 2), max(X(:, 2)), angle(X(:, 2) == max(X(:, 2))));
            % Calculer la valeur de calibration
            calibration = (mod(phaseLP, 180) + mod(phaseSP, 180)) / 2;

            % Acquisition des données de spectroscopie pour la calibration
            [x, y, ~] = Anatole_spectro_mirrrorClass(calibration, spectro, mirror_nbr, obj.communicationChannel);

            % Stocker toutes les variables dans la propriété calibrationData
            calibrationData = struct('x', x, 'y', y, 'DATA', DATA, 'SIG', SIG, ...
                'X', X, 'angle', angle, ...
                'x0LP', x0LP, 'neffLP', neffLP, 'phaseLP', phaseLP, ...
                'x0SP', x0SP, 'neffSP', neffSP, 'phaseSP', phaseSP, 'calibration', calibration);
        end
    end
end