function [x0, neff, phase] = AnatoleCurveFit(angle, data, maxdata, maxdataindice)
    % Fonction pour ajuster une courbe théorique à des données expérimentales
    
    % Transposer les données pour correspondre à la forme requise
    y = transpose(data); % y doit être une colonne
    
    % Variables indépendantes
    x = angle; % Angle ou variable indépendante
    
    % Définition de la fonction théorique à ajuster
    fitFunc = @(params, x) params(1) .* sqrt(1 - (sin(deg2rad(x - params(3))) / params(2)).^2);
    
    % Paramètres initiaux pour l'ajustement
    initialParams = [maxdata, 1.8, maxdataindice]; % Valeurs initiales à ajuster
    
    % Ajustement de la courbe aux données expérimentales
    params = lsqcurvefit(fitFunc, initialParams, x, y);
    
    % Récupération des résultats d'ajustement
    x0 = params(1); % Paramètre x0
    neff = params(2); % Indice effectif neff
    phase = params(3); % Phase
    
    % Affichage des résultats
    fprintf('x0 = %.4f\n', x0);
    fprintf('neff = %.4f\n', neff);
    fprintf('phase = %.4f\n', phase);
    
    % Tracé des données et de la courbe ajustée
    figure;
    hold on;
    scatter(x, y, 'bo'); % Affichage des données originales en bleu
    fittedY = fitFunc(params, 0:0.1:360); % Calcul de la courbe ajustée
    plot(0:0.1:360, fittedY, 'r-'); % Tracé de la courbe ajustée en rouge
    legend('Données', 'Fit des données'); % Légende du graphique
    xlabel('Angle (\theta)'); % Étiquette de l'axe des abscisses
    ylabel('Données expérimentales'); % Étiquette de l'axe des ordonnées
    
    % Titre du graphique en LaTeX
    title('$\lambda (\theta) = \lambda (0) \sqrt{1-\frac{\sin^2{(\theta - \phi )}}{n^2_{eff}}} $', 'Interpreter', 'latex');

    hold off; % Fin du tracé
end
