function courbe_slidder2
    % Initialisation des données
    [tfdata, wv, aoi] = init();
    [funcmid, funcLP, funcSP] = theory_eq();
    
    % Création de la figure UI
    fig = uifigure('Name', '3d double fonctions', 'Position', [100, 100, 800, 600]);
    angle = length(aoi)-1
    % Création du premier slider
    slider1 = uislider(fig, ...
        'Limits', [0 angle], ...
        'Value', 0, ...
        'MajorTicks', 0:10:angle, ...
        'MinorTicks', [], ...
        'Position', [100, 100, 300, 3], ...
        'ValueChangedFcn', @(sld, event) slider_callback());
    
    % Label pour afficher la valeur du premier slider
    label1 = uilabel(fig, ...
        'Position', [430, 90, 50, 22], ...
        'Text', '0','FontSize',19);

    % Création du deuxième slider
    slider2 = uislider(fig, ...
        'Limits', [0 angle], ...
        'Value', 0, ...
        'MajorTicks', 0:10:angle, ...
        'MinorTicks', [], ...
        'Position', [100, 60, 300, 3], ...
        'ValueChangedFcn', @(sld, event) slider_callback());

    % Label pour afficher la valeur du deuxième slider
    label2 = uilabel(fig, ...
        'Position', [430, 50, 50, 22], ...
        'Text', '0','FontSize',19);
    

    % Initial plot
    ax = uiaxes(fig, 'Position', [50, 150, 600, 400], 'ZLim', [0, 1]);
    s = surf(ax, wv, aoi, tfdata, 'FaceAlpha', 0.2);
    s.EdgeColor = 'none';

    % Fonction de rappel pour les sliders
    function slider_callback()
        slider_value1 = round(slider1.Value); % Obtenir la valeur du premier slider et la convertir en entier
        slider_value2 = round(slider2.Value); % Obtenir la valeur du deuxième slider et la convertir en entier

        % Mettre à jour les labels des sliders
        label1.Text = num2str(slider_value1);
        label2.Text = num2str(slider_value2);

        dataemp1 = zeros(size(tfdata));
        dataemp2 = zeros(size(tfdata));
        n1 = slider_value1;
        n2 = slider_value2;
        if n1 < size(tfdata, 1)
            dataemp1(1:end-n1,:) = tfdata(n1+1:end,:);
        end
        if n2 < size(tfdata, 1)
            dataemp2(1:end-n2,:) = tfdata(n2+1:end,:);
        end
        
        % Update plot data
        s.ZData = dataemp1 + dataemp2; % Combiner les deux ensembles de données si nécessaire
        
    end
end
