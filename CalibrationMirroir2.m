% Initialisation des paramètres
[x, y, p] = Anatole_spectro_mirrror(calibration - 90, spectro, 1); % Acquisition initiale pour ajustement

% Définir la plage d'angles et initialiser les matrices de données
range2 = 0+20:10:350; % Plage d'angles à parcourir pour le deuxième miroir
DATA2 = zeros(length(range2), 2000); % Matrice de données d'acquisition
SIG2 = DATA2; % Matrice des signaux filtrés
Xtemp2 = zeros(length(range2), 2); % Matrice temporaire des positions X
angletemp2 = zeros(size(range2)); % Vecteur temporaire des angles
[~, ~, ~] = Anatole_spectro_mirrror(-55+90, spectro, 3);

% Boucle sur la plage d'angles
j = 1; % Initialiser l'index pour DATA2 et autres matrices
u = 1; % Initialiser l'index pour Xtemp2 et angletemp2
for i = range2
    % Acquisition des données pour l'angle courant
    [x, y, p] = Anatole_spectro_mirrror(i, spectro, 2); 
    DATA2(j, :) = y; % Stocker les données dans DATA2

    % Tracer les données de spectroscopie pour l'angle courant

    % Appliquer un filtre médian pour lisser et normaliser les données
    sig = normalize(medfilt1(DATA2(j, :), 3), 'range'); 
    SIG2(j, :) = sig; % Stocker le signal normalisé dans SIG2

    % Détecter les points où le signal dépasse un seuil (0.2)
    DERIV2 = sig > 0.2;
    Xfirst2 = find(DERIV2, 1, 'first');
    Xlast2 = find(DERIV2, 1, 'last');

    % Vérifier que les positions détectées sont valides
    if ~isempty(Xfirst2) && ~isempty(Xlast2) && (x(Xlast2) - x(Xfirst2)) > 20 && (x(Xlast2) - x(Xfirst2)) < 25
        % Stocker les positions valides dans Xtemp2
        Xtemp2(u, :) = [x(Xfirst2), x(Xlast2)];
        angletemp2(u) = i; % Stocker l'angle correspondant
        u = u + 1;
        fprintf("ADDED\n");
        disp([x(Xfirst2), x(Xlast2), DATA2(j, Xfirst2), DATA2(j, Xlast2)]);
        plot(x, DATA2(j, :));
        hold on;
        % Marquer les positions détectées sur le graphique
        scatter([x(Xfirst2), x(Xlast2)], [DATA2(j, Xfirst2), DATA2(j, Xlast2)]);
    end
    j = j + 1; % Incrémenter l'index pour la prochaine itération
end
hold off;

% Filtrer les positions valides stockées dans Xtemp2
valid_idx2 = Xtemp2(:, 1) ~= 0;
X2 = Xtemp2(valid_idx2, :);
angle2 = angletemp2(valid_idx2);

% Ajuster les courbes pour obtenir les paramètres de calibration
[x2LP, neff2LP, phase2LP] = AnatoleCurveFit(angle2, X2(:, 1), max(X2(:, 1)), angle2(X2(:, 1) == max(X2(:, 1))));
[x2SP, neff2SP, phase2SP] = AnatoleCurveFit(angle2, X2(:, 2), max(X2(:, 2)), angle2(X2(:, 2) == max(X2(:, 2))));

% Calculer la valeur de calibration
calibration2 = (mod(phase2LP, 180) + mod(phase2SP, 180)) / 2;

% Acquisition des données de spectroscopie pour la calibration
[x, y, p] = Anatole_spectro_mirrror(calibration2, spectro, 2);

