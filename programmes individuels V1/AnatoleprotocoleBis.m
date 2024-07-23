[~, ~, ~] = Anatole_spectro_mirrror(-3.5-90, spectro, 3)

% Initialisation des paramètres
calibration2temp = -140; % Définir la valeur de calibration2 temporaire
[x, yl, ~] = Anatole_spectro_mirrror(calibration2temp + 90, spectro, 1); % Pivot du deuxième miroir
[x, yl, ~] = Anatole_spectro_mirrror(calibration2temp + 90, spectro, 2); % Pivot du deuxième miroir
% Définir la plage d'angles et initialiser les matrices de données
range = 0:6:360; % Plage d'angles à parcourir
DATA = zeros(length(range), 2000); % Matrice de données d'acquisition
SIG = DATA; % Matrice des signaux filtrés
Xtemp = zeros(length(range), 2); % Matrice temporaire des positions X
angletemp = zeros(size(range)); % Vecteur temporaire des angles

% Boucle sur la plage d'angles
for j = 1:length(range)
    i = range(j); % Angle courant
    [x, y, ~] = Anatole_spectro_mirrror(i, spectro, 1); 
    DATA(j, :) = y; % Stocker les données dans DATA
    
    % Tracer les données de spectroscopie pour l'angle courant
    %plot(x, y); hold on;
    y1 = (y-min(y))./(yl-min(y));
    % Appliquer un filtre médian pour lisser et normaliser les données
    sig = normalize(medfilt1(y1, 3), 'range');
    SIG(j, :) = sig; % Stocker le signal normalisé dans SIG
    plot(x,sig)
    hold on
    % Détecter les points où le signal dépasse un seuil (0.22)
    DERIV = sig > 0.50;
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
        scatter([x(Xfirst), x(Xlast)], [SIG(j, Xfirst), SIG(j, Xlast)]);
    end
end
hold off;
xlabel('$\lambda$ nm', 'Interpreter', 'latex')
ylabel('Intensity', 'Interpreter', 'latex')

% Filtrer les positions valides stockées dans Xtemp
valid_idx = Xtemp(:, 1) ~= 0;
X = Xtemp(valid_idx, :);
angle = angletemp(valid_idx);

% Ajuster les courbes pour obtenir les paramètres de calibration
[x0LP, neffLP, phaseLP, x0SP, neffSP, phaseSP] = AnatoleCurveFit(angle, X(:, 1), max(X(:, 1)), angle(X(:, 1) == max(X(:, 1))), X(:, 2), max(X(:, 2)), angle(X(:, 2) == max(X(:, 2))));
% Calculer la valeur de calibration
calibration = (mod(phaseLP, 180) + mod(phaseSP, 180)) / 2;

% Acquisition des données de spectroscopie pour la calibration
[x, y, ~] = Anatole_spectro_mirrror(calibration, spectro, 1);


