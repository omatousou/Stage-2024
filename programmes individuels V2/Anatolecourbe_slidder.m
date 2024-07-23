function Anatolecourbe_slidder(DATAFT,DATAFT2,x)
    % Initialisation des données
    wv = x;

    % Création de la figure
    figure;
    
    % Création des sous-graphes
    ax1 = subplot(2, 1, 1); % Premier sous-graphe pour new_y1 et new_y2
    ax2 = subplot(2, 1, 2); % Deuxième sous-graphe pour new_y1 .* new_y2

    % Tracer les courbes initiales
    plot(ax1, wv, DATAFT(3, :), 'Color', 'blue', 'DisplayName', 'Courbe 1 déplacée 0°');
    hold(ax1, 'on');
    plot(ax1, wv, DATAFT2(3, :), 'Color', 'red', 'DisplayName', 'Courbe 2 déplacée 0°');
    hold(ax1, 'off');
    legend(ax1, 'show', 'Location', 'southwest');
    xlim(ax1, [480, 580]);
    title(ax1, 'fonction de transfert des filtres 1 et 2');
    ylim(ax1,[0,1])
    xlabel(ax1,' wavelength \lambda nm')
    ylabel(ax1,'transmitance')
    plot(ax2, wv, DATAFT(3, :) .* DATAFT2(3, :), 'Color', 'green'); % Produit initial
    title(ax2, 'Fonction de transfert');
    xlim(ax2, [480, 580]);
    ylim(ax2,[0,1])
    xlabel(ax2,' wavelength \lambda nm')
    ylabel(ax2,'transmitance')
    

     % Ajustement des positions des sous-graphes
    ax1.Position = [0.1, 0.60, 0.8, 0.35]; % [left, bottom, width, height]
    ax2.Position = [0.1, 0.10, 0.8, 0.35];

    % Création du premier slider
    slider1 = uicontrol('Style', 'slider', 'Min', -2, 'Max',60, 'Value', 0, ...
        'SliderStep', [1/48, 1/48], 'Position', [100, 70, 300, 20], ...
        'Callback', @slider_callback);

    % Création du deuxième slider
    slider2 = uicontrol('Style', 'slider', 'Min', -2, 'Max', 60, 'Value', 0, ...
        'SliderStep', [1/62, 1/62], 'Position', [100, 40, 300, 20], ...
        'Callback', @slider_callback);

    % Fonction de rappel pour les sliders
    function slider_callback(~, ~)
        slider_value1 = round(get(slider1, 'Value')); % Obtenir la valeur du premier slider et la convertir en entier
        slider_value2 = round(get(slider2, 'Value')); % Obtenir la valeur du deuxième slider et la convertir en entier
        new_y1 = DATAFT(slider_value1 + 3, :); % Modifier les données en fonction de la valeur du premier curseur
        new_y2 = DATAFT2(slider_value2 + 3, :); % Modifier les données en fonction de la valeur du deuxième curseur

        % Mettre à jour les courbes sur ax1
        cla(ax1); % Effacer le contenu de l'axe 1
        hold(ax1, 'on');
        realval1 = round(slider_value1,2);
        realval2 = round(slider_value2,2);
        plot(ax1, wv, new_y1, 'Color', 'blue', 'DisplayName', sprintf('Courbe 1 déplacée %d°',realval1));
        plot(ax1, wv, new_y2, 'Color', 'red', 'DisplayName', sprintf('Courbe 2 déplacée %d°', realval2));

        hold(ax1, 'off');
        legend(ax1, 'show', 'Location', 'southwest');
        xlim(ax1, [480, 580]);
        ylim(ax1,[0,1])
        xlabel(ax1,' wavelength \lambda nm')
        ylabel(ax1,'transmitance')
        title(ax1, 'fonction de transfère des filtres 1 et 2');
        
    

  
        % Mettre à jour la courbe sur ax2
        cla(ax2); % Effacer le contenu de l'axe 2
        height = max(new_y1 .* new_y2);
        [pks,locs,widths,proms]=findpeaks(new_y1 .* new_y2,wv,'MinPeakProminence',height/2,'Annotate','extents');
        findpeaks(new_y1 .* new_y2,wv,'MinPeakProminence',height/2,'Annotate','extents');
        hold(ax2, 'on');
        if length(pks)==1
            text(515,0.4,'pks : '+ string(pks));
            text(515,0.3,'locs : '+string(locs));
            text(515,0.2,'widths : '+string(widths));
            text(515,0.1,'proms : '+string(proms));
        end
        plot(ax2, wv, new_y1 .* new_y2, 'Color', 'green', 'DisplayName', 'Fonction de transfert');
        hold(ax2, 'off');
        xlim(ax2, [480, 580]);
        title(ax2, 'Fonction de transfert');
        ylim(ax2,[0,1]);
        xlabel(ax2,' wavelength \lambda nm')
        ylabel(ax2,'transmitance')
    end
end
