% Charger l'image
tache = myImageData';
img = tache(100:150,970:1020); % Assurez-vous que l'image est dans le répertoire de travail

% Trouver la valeur maximale de l'image
max_value = max(img(:));

% Trouver les coordonnées de la valeur maximale
[row, col] = find(img == max_value);

% Afficher les résultats
figure;
imagesc(img);
axis equal
hold on 
plot([col],[row], 'r*', 'MarkerSize', 10, 'LineWidth', 2);
disp(row)
disp(col)
hold off
title('Image originale');
figure;

imagesc(tache)
axis equal