[~, ~, ~] = Anatole_spectro_mirrror(calibration2temp + 90, spectro, 2);
[~, background,~] = Anatole_spectro_mirrror(calibration-90, spectro,1);


% Variables
peaks = -5:0.1:5;
spectre = zeros(1, length(peaks)); % Initialisation des vecteurs
sume = zeros(1, length(peaks)); 

% Configuration des figures
figure;

% Boucle pour calculer les spectres et les sommes
j = 1;
spectre = zeros(2000,length(peaks));
for i = peaks
    [x, y, ~] = Anatole_spectro_mirrror(i, spectro, 3);
    spectre(:,j) = y;
    sume(j) = sum(y);

    % Affichage du spectre
    subplot(1, 3, 1);
    plot(x, y);
    hold on;
    xlabel('fréquence (nm)'); % Étiquette de l'axe des abscisses
    ylabel('Données expérimentales'); % Étiquette de l'axe des ordonnées
    
    % Affichage de l'intensité totale
    subplot(1, 3, 2);
    scatter(peaks(j), sume(j));
    hold on;
    xlim([min(peaks), max(peaks)]);
    xlabel('Angle (\theta)'); % Étiquette de l'axe des abscisses
    ylabel('Intensité totale'); % Étiquette de l'axe des ordonnées
    
    j = j + 1;
    pause(0.2);
end

% Normalisation des données
y = normalize(sume, 'range'); % y doit être une colonne

% Variables indépendantes
x = peaks; % Angle ou variable indépendante

% Définition de la fonction théorique à ajuster
fitFunc = @(params, x) params(4) * cosh(params(1) * (x - params(2))) + params(3);

% Paramètres initiaux pour l'ajustement
initialParams = [-0.5, -0.5, -1,1]; % Valeurs initiales à ajuster

% Ajustement de la courbe aux données expérimentales
params = lsqcurvefit(fitFunc, initialParams, x, y);

% Récupération des résultats d'ajustement
a = params(1); % Paramètre a
b = params(3); % Paramètre b
phase = params(2); % Phase (phi)
c = params(4);
% Affichage des résultats
fprintf('a = %.4f\n', a);
fprintf('b = %.4f\n', b);
fprintf('phase = %.4f\n', phase);
fprintf('c = %.4f\n', c);
% Tracé des données et de la courbe ajustée
subplot(1, 3, 3);
hold on;
scatter(x, y, 'bo'); % Affichage des données originales en bleu
fittedY = fitFunc(params, x); % Calcul de la courbe ajustée
plot(x, fittedY, 'r-'); % Tracé de la courbe ajustée en rouge
legend('Données', 'Fit des données'); % Légende du graphique
xlabel('Angle (\theta)'); % Étiquette de l'axe des abscisses
ylabel('Données expérimentales normalisées'); % Étiquette de l'axe des ordonnées
ylim([-0.25,1.25])
% Titre du graphique en LaTeX
title('$\alpha \cosh{(x-\phi)}+\delta $', 'Interpreter', 'latex');

hold off; % Fin du tracé
calibration3 = phase;
[x, y, ~] = Anatole_spectro_mirrror(phase, spectro, 3);