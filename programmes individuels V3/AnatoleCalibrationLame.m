

% Initialisation des paramètres
calibration2temp = 180;
calibrationtemp =90;% Définir la valeur de calibration2 temporaire
[~, ~, ~] = Anatole_spectro_mirrror(calibration2temp - 90, spectro, 2); % Pivot du deuxième miroir
[~, ~, ~] = Anatole_spectro_mirrror(calibration, spectro, 1);
% Définir la plage d'angles et initialiser les matrices de données
range = 0:15:360; % Plage d'angles à parcourir
DATA = zeros(length(range), 2000); % Matrice de données d'acquisition
summation = zeros(1,length(range));


for j = 1:length(range)
    i = range(j); % Angle courant
    [x, y, ~] = Anatole_spectro_mirrror(i, spectro, 3); 
    DATA(j, :) = y; % Stocker les données dans DATA
    
    % Tracer les données de spectroscopie pour l'angle courant
    plot(x, DATA(j, :)); hold on;
    summation(j)= sum(y);
end
hold off

plot(range,summation)

% Acquisition des données de spectroscopie pour la calibration
[x, y, ~] = Anatole_spectro_mirrror(calibration, spectro, 1);
calibrationbis = (mod(phaseLP, 180) + mod(phaseSP, 180)) / 2;
