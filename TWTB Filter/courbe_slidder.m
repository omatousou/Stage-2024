function courbe_slidder
    % Initialisation des données
    [tfdata, wv, aoi] = init;
    [funcmid,funcLP,funcSP] = theory_eq;
    % Création de la figure
    figure;
    
    % Création des sous-graphes
    ax1 = subplot(2, 1, 1); % Premier sous-graphe pour new_y1 et new_y2
    ax2 = subplot(2, 1, 2); % Deuxième sous-graphe pour new_y1 .* new_y2

    % Tracer les courbes initiales
    plot(ax1, wv, tfdata(1, :), 'Color', 'blue', 'DisplayName', 'Courbe 1 déplacée 0°');
    hold(ax1, 'on');
    plot(ax1, wv, tfdata(1, :), 'Color', 'red', 'DisplayName', 'Courbe 2 déplacée 0°');
    hold(ax1, 'off');
    legend(ax1, 'show', 'Location', 'southwest');
    xlim(ax1, [480, 580]);
    title(ax1, 'filtre 1 et filtre 2');

    plot(ax2, wv, tfdata(1, :) .* tfdata(1, :), 'Color', 'green'); % Produit initial
    title(ax2, 'Fonction de transfert');
    xlim(ax2, [480, 580]);

     % Ajustement des positions des sous-graphes
    ax1.Position = [0.1, 0.55, 0.8, 0.35]; % [left, bottom, width, height]
    ax2.Position = [0.1, 0.15, 0.8, 0.35];

    % Création du premier slider
    slider1 = uicontrol('Style', 'slider', 'Min', 0, 'Max', 60, 'Value', 0, ...
        'SliderStep', [1/60, 1/60], 'Position', [100, 70, 300, 20], ...
        'Callback', @slider_callback);

    % Création du deuxième slider
    slider2 = uicontrol('Style', 'slider', 'Min', 0, 'Max', 60, 'Value', 0, ...
        'SliderStep', [1/60, 1/60], 'Position', [100, 40, 300, 20], ...
        'Callback', @slider_callback);


    % Fonction de rappel pour les sliders
    function slider_callback(~, ~)
        slider_value1 = round(get(slider1, 'Value')); % Obtenir la valeur du premier slider et la convertir en entier
        slider_value2 = round(get(slider2, 'Value')); % Obtenir la valeur du deuxième slider et la convertir en entier

        new_y1 = tfdata(slider_value1 + 1, :); % Modifier les données en fonction de la valeur du premier curseur
        new_y2 = tfdata(slider_value2 + 1, :); % Modifier les données en fonction de la valeur du deuxième curseur

        % Mettre à jour les courbes sur ax1
        cla(ax1); % Effacer le contenu de l'axe 1
        hold(ax1, 'on');
        plot(ax1, wv, new_y1, 'Color', 'blue', 'DisplayName', sprintf('Courbe 1 déplacée %d°', slider_value1));
        plot(ax1, wv, new_y2, 'Color', 'red', 'DisplayName', sprintf('Courbe 2 déplacée %d°', slider_value2));
        plot(ax1,[funcmid(slider_value1),funcmid(slider_value1)],[0,1],'Color','blue','DisplayName','mid');
        plot(ax1,[funcLP(slider_value1),funcLP(slider_value1)],[0,1],'Color','blue','DisplayName','LP');
        plot(ax1,[funcSP(slider_value1),funcSP(slider_value1)],[0,1],'Color','blue','DisplayName','SP');
        plot(ax1,[funcmid(slider_value2),funcmid(slider_value2)],[0,1],'Color','red','DisplayName','mid');
        plot(ax1,[funcLP(slider_value2),funcLP(slider_value2)],[0,1],'Color','red','DisplayName','LP');
        plot(ax1,[funcSP(slider_value2),funcSP(slider_value2)],[0,1],'Color','red','DisplayName','SP');

        hold(ax1, 'off');
        legend(ax1, 'show', 'Location', 'southwest');
        xlim(ax1, [480, 580]);
        ylim(ax1,[0,1.05])
        title(ax1, 'Courbe 1 et Courbe 2');
        


  
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
        ylim(ax2,[0,1.05])
        title(ax2, 'Fonction de transfert');
    end
end
