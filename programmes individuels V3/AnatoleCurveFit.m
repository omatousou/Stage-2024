    function [x0LP, neffLP, phaseLP, x0SP, neffSP, phaseSP] = AnatoleCurveFit(angle, dataLP, maxdataLP, maxdataindiceLP, dataSP, maxdataSP, maxdataindiceSP)
    % Fonction pour ajuster une courbe théorique à des données expérimentales
    
    % Transposer les données pour correspondre à la forme requise
    y = transpose(dataLP); % y doit être une colonne
    y2 = transpose(dataSP); % y2 doit être une colonne
    % Variables indépendantes
    x = angle; % Angle ou variable indépendante
    
    % Définition de la fonction théorique à ajuster
    fitFunc = @(params, x) params(1) .* sqrt(1 - (sin(deg2rad(x - params(3))) / params(2)).^2);
    
    % Paramètres initiaux pour l'ajustement
    initialParamsLP = [maxdataLP, 1.8, maxdataindiceLP]; % Valeurs initiales à ajuster
    
    % Ajustement de la courbe aux données expérimentales
    paramsLP = lsqcurvefit(fitFunc, initialParamsLP, x, y);
    
    % Récupération des résultats d'ajustement
    x0LP = paramsLP(1); % Paramètre x0
    neffLP = paramsLP(2); % Indice effectif neff
    phaseLP = paramsLP(3); % Phase

    initialParamsSP = [maxdataSP, 1.8, maxdataindiceSP];
    paramsSP = lsqcurvefit(fitFunc, initialParamsSP, x, y2);
    x0SP = paramsSP(1); % Paramètre x0
    neffSP = paramsSP(2); % Indice effectif neff
    phaseSP = paramsSP(3); % Phase

    % Affichage des résultats
    fprintf('x0LP = %.4f\n', x0LP);
    fprintf('neffLP = %.4f\n', neffLP);
    fprintf('phaseLP = %.4f\n', phaseLP);
    fprintf('x0SP = %.4f\n', x0SP);
    fprintf('neffSP = %.4f\n', neffSP);
    fprintf('phaseSP = %.4f\n', phaseSP);
    % Tracé des données et de la courbe ajustée
    figure;
    hold on;
    scatter(x, y, 'bo'); % Affichage des données originales en bleu
    fittedY = fitFunc(paramsLP, 0:0.1:360); % Calcul de la courbe ajustée
    plot(0:0.1:360, fittedY, 'r-'); % Tracé de la courbe ajustée en rouge

    scatter(x, y2, 'bo'); % Affichage des données originales en bleu
    fittedY = fitFunc(paramsSP, 0:0.1:360); % Calcul de la courbe ajustée
    plot(0:0.1:360, fittedY, 'r-'); % Tracé de la courbe ajustée en rouge

    legend('Données', 'Fit des données'); % Légende du graphique
    xlabel('Angle (\theta)'); % Étiquette de l'axe des abscisses
    ylabel("Longueur d'onde \lambda en nanomètre "); % Étiquette de l'axe des ordonnées
    
    % Titre du graphique en LaTeX
    title('$\lambda (\theta) = \lambda (0) \sqrt{1-\frac{\sin^2{(\theta - \phi )}}{n^2_{eff}}} $', 'Interpreter', 'latex');

    hold off; % Fin du tracé
end
