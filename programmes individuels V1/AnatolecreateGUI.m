function AnatolecreateGUI(app)
    % Initialisation des objets miroirs dans appState
    appState = AppState();

    % Initialiser avant app = SpectroInit();
    spectro = app.InstrInfo.Spectrometer;

    % Create the main figure
    fig = uifigure('Position', [100, 100, 1000, 800]);
    fig.Name = 'Application de Filtrage';

    % Create the grid layout manager
    gl = uigridlayout(fig, [4, 2]);
    gl.RowHeight = {'1x', '1x', '2x', '1x'};
    gl.ColumnWidth = {'1x', '1x'};

    % Create an axes for spectrum display
    axSpectrum = uiaxes(gl);
    axSpectrum.Layout.Row = 2;
    axSpectrum.Layout.Column = [1, 2];
    title(axSpectrum, 'Spectre de la calibration');

    % Create an axes for the second spectrum display
    axSpectrum2 = uiaxes(gl);
    axSpectrum2.Layout.Row = 3;
    axSpectrum2.Layout.Column = 1;
    title(axSpectrum2, 'Spectre de la fonction de transfert');

    % Create a panel for calibration buttons
    panelCalibration = uipanel(gl, 'Title', 'Calibration');
    panelCalibration.Layout.Row = 1;
    panelCalibration.Layout.Column = 1;

    % Create grid layout inside panel for calibration buttons
    calibrationLayout = uigridlayout(panelCalibration, [2, 2]);
    calibrationLayout.RowHeight = {'1x', '1x'};
    calibrationLayout.ColumnWidth = {'1x', '1x'};

    % Add calibration buttons
    buttonCalibF1L1 = uibutton(calibrationLayout, 'Text', 'Calibration Filtre 1 Ligne 1');
    buttonCalibF1L1.Layout.Row = 1;
    buttonCalibF1L1.Layout.Column = 1;
    buttonCalibF1L1.ButtonPushedFcn = @(btn, event) runCalibration('COM8', appState, spectro, 1, axSpectrum);

    buttonCalibF2L1 = uibutton(calibrationLayout, 'Text', 'Calibration Filtre 2 Ligne 1');
    buttonCalibF2L1.Layout.Row = 2;
    buttonCalibF2L1.Layout.Column = 1;
    buttonCalibF2L1.ButtonPushedFcn = @(btn, event) runCalibration('COM8', appState, spectro, 2, axSpectrum);

    buttonCalibF1L2 = uibutton(calibrationLayout, 'Text', 'Calibration Filtre 1 Ligne 2');
    buttonCalibF1L2.Layout.Row = 1;
    buttonCalibF1L2.Layout.Column = 2;
    buttonCalibF1L2.ButtonPushedFcn = @(btn, event) runCalibration('COM9', appState, spectro, 1, axSpectrum);

    buttonCalibF2L2 = uibutton(calibrationLayout, 'Text', 'Calibration Filtre 2 Ligne 2');
    buttonCalibF2L2.Layout.Row = 2;
    buttonCalibF2L2.Layout.Column = 2;
    buttonCalibF2L2.ButtonPushedFcn = @(btn, event) runCalibration('COM9', appState, spectro, 2, axSpectrum);

    % Create a panel for calibration parameters
    panelCalib = uipanel(gl, 'Title', 'Paramétrage de la calibration');
    panelCalib.Layout.Row = 1;
    panelCalib.Layout.Column = 2;

    % Create grid layout inside panel for calibration parameters
    panelCalibLayout = uigridlayout(panelCalib, [4, 2]);
    panelCalibLayout.RowHeight = {'1x', '1x', '1x', '1x'};
    panelCalibLayout.ColumnWidth = {'1x', '2x'};

    % Champ d'entrée pour 'début'
    labelDebut = uilabel(panelCalibLayout, 'Text', 'Début:');
    labelDebut.Layout.Row = 1;
    labelDebut.Layout.Column = 1;
    debutField = uieditfield(panelCalibLayout, 'text', 'Value', num2str(appState.debut));
    debutField.Layout.Row = 1;
    debutField.Layout.Column = 2;

    % Champ d'entrée pour 'fin'
    labelFin = uilabel(panelCalibLayout, 'Text', 'Fin:');
    labelFin.Layout.Row = 2;
    labelFin.Layout.Column = 1;
    finField = uieditfield(panelCalibLayout, 'text', 'Value', num2str(appState.fin));
    finField.Layout.Row = 2;
    finField.Layout.Column = 2;

    % Champ d'entrée pour 'step'
    labelStep = uilabel(panelCalibLayout, 'Text', 'Step:');
    labelStep.Layout.Row = 3;
    labelStep.Layout.Column = 1;
    stepField = uieditfield(panelCalibLayout, 'text', 'Value', num2str(appState.step));
    stepField.Layout.Row = 3;
    stepField.Layout.Column = 2;

    % Champ d'entrée pour 'seuil'
    labelSeuil = uilabel(panelCalibLayout, 'Text', 'Seuil:');
    labelSeuil.Layout.Row = 4;
    labelSeuil.Layout.Column = 1;
    seuilField = uieditfield(panelCalibLayout, 'text', 'Value', num2str(appState.seuil));
    seuilField.Layout.Row = 4;
    seuilField.Layout.Column = 2;

    % Create a panel for filter parameters
    panelFilters = uipanel(gl, 'Title', 'Paramétrage des filtres');
    panelFilters.Layout.Row = [3, 4];
    panelFilters.Layout.Column = 2;

    % Create grid layout inside panel for filters
    filterLayout = uigridlayout(panelFilters, [10, 2]);
    filterLayout.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit'};
    filterLayout.ColumnWidth = {'fit', '1x'};

    % Paramètres du filtre 1
    labelPeak1 = uilabel(filterLayout, 'Text', 'A Peak (nm) :');
    labelPeak1.Layout.Row = 1;
    labelPeak1.Layout.Column = 1;
    peak1 = uieditfield(filterLayout, 'numeric');
    peak1.Layout.Row = 1;
    peak1.Layout.Column = 2;

    labelWidth1 = uilabel(filterLayout, 'Text', 'A width (nm) :');
    labelWidth1.Layout.Row = 2;
    labelWidth1.Layout.Column = 1;
    Width1 = uieditfield(filterLayout, 'numeric');
    Width1.Layout.Row = 2;
    Width1.Layout.Column = 2;

    % Paramètres du filtre 2
    labelPeak2 = uilabel(filterLayout, 'Text', 'B Peak (nm) :');
    labelPeak2.Layout.Row = 3;
    labelPeak2.Layout.Column = 1;
    peak2 = uieditfield(filterLayout, 'numeric');
    peak2.Layout.Row = 3;
    peak2.Layout.Column = 2;

    labelWidth2 = uilabel(filterLayout, 'Text', 'B width (nm) :');
    labelWidth2.Layout.Row = 4;
    labelWidth2.Layout.Column = 1;
    Width2 = uieditfield(filterLayout, 'numeric');
    Width2.Layout.Row = 4;
    Width2.Layout.Column = 2;

    % Créer un bouton d'acquisition
    acquisitionButton = uibutton(filterLayout, 'Text', 'Start Acquisition');
    acquisitionButton.Layout.Row = 5;
    acquisitionButton.Layout.Column = [1, 2];
    acquisitionButton.ButtonPushedFcn = @(btn, event) startAcquisition(axSpectrum2, appState, appState.mirroir1, appState.mirroir2, appState.mirroir3, appState.mirroir4, spectro);

    % Ajouter les nouveaux champs de saisie
    labelSP1 = uilabel(filterLayout, 'Text', 'position sup BP1 (nm):');
    labelSP1.Layout.Row = 6;
    labelSP1.Layout.Column = 1;
    newSP1 = uieditfield(filterLayout, 'text');
    newSP1.Layout.Row = 6;
    newSP1.Layout.Column = 2;

    labelLP2 = uilabel(filterLayout, 'Text', 'position inf BP2 (nm) :');
    labelLP2.Layout.Row = 7;
    labelLP2.Layout.Column = 1;
    newLP2 = uieditfield(filterLayout, 'text');
    newLP2.Layout.Row = 7;
    newLP2.Layout.Column = 2;

    % Ajouter les nouveaux boutons
    BP1 = uibutton(filterLayout, 'Text', 'BP1 : 0°');
    BP1.Layout.Row = 8;
    BP1.Layout.Column = 1;
    BP1.ButtonPushedFcn = @(btn, event) newButton1Callback(spectro, appState, newSP1);

    BP2 = uibutton(filterLayout, 'Text', 'BP2 0°');
    BP2.Layout.Row = 8;
    BP2.Layout.Column = 2;
    BP2.ButtonPushedFcn = @(btn, event) newButton2Callback(spectro, appState, newLP2);

    CP = uibutton(filterLayout, 'Text', 'CP 0°');
    CP.Layout.Row = 9;
    CP.Layout.Column = [1, 2];
    CP.ButtonPushedFcn = @(btn, event) newButton3Callback(spectro, newSP1, newLP2);

    % Ajouter des callbacks pour mettre à jour le spectre
    addlistener(Width1, 'ValueChanged', @(src, event) updateSpectrum(axSpectrum2, peak1.Value, Width1.Value, spectro, appState));
    addlistener(Width2, 'ValueChanged', @(src, event) updateSpectrum2(axSpectrum2, peak2.Value, Width2.Value, spectro, appState));
    addlistener(newSP1, 'ValueChanged', @(src, event) updateSP1(axSpectrum2, newSP1.Value, spectro, appState));
    addlistener(newLP2, 'ValueChanged', @(src, event) updateLP2(axSpectrum2, newLP2.Value, spectro, appState));

    % Add listeners for new fields
    addlistener(debutField, 'ValueChanged', @(src, event) updateBalayageParams(src, appState,1));
    addlistener(finField, 'ValueChanged', @(src, event) updateBalayageParams(src, appState,3));
    addlistener(stepField, 'ValueChanged', @(src, event) updateBalayageParams(src, appState,2));
    addlistener(seuilField, 'ValueChanged', @(src, event) updateSeuil(src, appState));
end

function newButton1Callback(spectro, appState, newSP1)
    [~, ~, ~] = Anatole_spectro_mirrror(-90 + appState.mirroir1.calibration, spectro, 1);
    disp(['Filter 1 : 90° ']);
    newSP1.Value = ''; % Supprime la valeur du champ de saisie newSP1
end

function newButton2Callback(spectro, appState, newLP2)
    [~, ~, ~] = Anatole_spectro_mirrror(-90 + appState.mirroir2.calibration, spectro, 2);
    disp(['Filter 2 : 90°']);
    newLP2.Value = ''; % Supprime la valeur du champ de saisie newLP2
end

function newButton3Callback(spectro, newSP1, newLP2)
    calibration3 = -2;
    [~, ~, ~] = Anatole_spectro_mirrror(-90 + calibration3, spectro, 3);
    disp(['CP : 90°']);
    newSP1.Value = ''; % Supprime la valeur du champ de saisie newSP1
    newLP2.Value = ''; % Supprime la valeur du champ de saisie newLP2
end

function updateSP1(ax, SP1, spectro, appState)
    SP1 = str2double(SP1);
    cla(ax);

    if isempty(SP1), SP1 = 0; end

    x0SP = appState.mirroir1.x0SP;
    neffSP = appState.mirroir1.neffSP;
    theta1 = Anatole_Courbe_Inverse(x0SP, neffSP, SP1);
    [x, y, ~] = Anatole_spectro_mirrror(appState.mirroir1.calibration + theta1, spectro, 1);
    plot(ax, x, y)
    title(ax, 'Spectre');
    xlabel(ax, 'Frequency');
    ylabel(ax, 'Amplitude');
    hold(ax, 'off');
end

function updateLP2(ax, LP2, spectro, appState)
    LP2 = str2double(LP2);
    cla(ax);

    if isempty(LP2), LP2 = 0; end

    x2LP = appState.mirroir2.x0LP;
    neff2LP = appState.mirroir2.neffLP;
    theta2 = -Anatole_Courbe_Inverse(x2LP, neff2LP, LP2);

    [x, y, ~] = Anatole_spectro_mirrror(theta2 + appState.mirroir2.calibration, spectro, 2);
    plot(ax, x, y)
    title(ax, 'Spectre');
    xlabel(ax, 'Frequency');
    ylabel(ax, 'Amplitude');
    hold(ax, 'off');
end

function updateBalayageParams(newval, appState,change)
    if ~isnan(newval) && ~isnan(change)
        appState.change_balayageEnAngle(newval,change);
    else
        disp('Valeur invalide pour le balayage en angle.');
    end
end

function updateSeuil(newSeuil, appState)
    if ~isnan(newSeuil)
        appState.change_seuil(newSeuil);
    else
        disp('Valeur invalide pour le seuil.');
    end
end

function runCalibration(channel, appState, spectro, mirror_nbr, axSpectrum)
    cla(axSpectrum);
    data = calibration(channel, appState.balayageEnAngle, spectro, mirror_nbr, appState.seuil, axSpectrum);
    if (mirror_nbr == 1) && (string(channel) == "COM8") % Ajuster au besoin
        appState.change_mirr1(data);
        disp('Calibration Data Stored:');
        disp(appState.mirroir1);
    elseif (mirror_nbr == 2) && (string(channel) == "COM8")
        appState.change_mirr2(data);
        disp('Calibration Data Stored:');
        disp(appState.mirroir2);
    elseif (mirror_nbr == 1) && (string(channel) == "COM9")
        appState.change_mirr3(data);
        disp('Calibration Data Stored:');
        disp(appState.mirroir3);
    elseif (mirror_nbr == 2) && (string(channel) == "COM9")
        appState.change_mirr4(data);
        disp('Calibration Data Stored:');
        disp(appState.mirroir3);
    else
        error('wrong mirror nbr or communication channel')
    end
end

function startAcquisition(axSpectrum2, ap, m1, m2, m3, m4, spectro)
    [x, y] = Anatole_spectro_mesure(spectro);

    plot(axSpectrum2, x, y)
    ylim(axSpectrum2,'auto')
    xlim(axSpectrum2,'auto')
    fprintf('\n__________app__________')
    disp(ap)
    fprintf('\n__________BP1_________')
    disp(m1)
    fprintf('\n__________BP2_________')
    disp(m2)
    fprintf('\n______________________\n')
end

function updateSpectrum(ax, peak1, Width1, spectro, appState)
    cla(ax);

    if isempty(peak1), peak1 = 0; end
    if isempty(Width1), Width1 = 1; end

    x2LP = appState.mirroir2.x0LP;
    x0SP = appState.mirroir1.x0SP;
    neffSP = appState.mirroir1.neffSP;
    neff2LP = appState.mirroir2.neffLP;
    neffLP = appState.mirroir1.neffLP;
    neff2SP = appState.mirroir2.neffSP;

    [theta1, theta2, theta3] = Anatole_Calcule_des_Angles(peak1, Width1 / 2, x2LP, x0SP, neffSP, neff2LP, neffLP, neff2SP);
    calibration3 = -2; % lame compensatrice

    [x, y, ~] = Anatole_spectro_mirrror(-90 + appState.mirroir1.calibration, spectro, 1);
    [x, y, ~] = Anatole_spectro_mirrror(-90 + appState.mirroir2.calibration, spectro, 2);
    [x, yl, ~] = Anatole_spectro_mirrror(-90 + calibration3, spectro, 3);
    [x, y, ~] = Anatole_spectro_mirrror(theta1 + appState.mirroir1.calibration, spectro, 1);
    y1 = (y - min(y)) ./ (yl - min(y));
    plot(ax, x, y1, 'DisplayName', 'BP1','Color',[0,0,1,0.2],'LineStyle',':')
    title(ax, 'Spectre');
    xlabel(ax, '$\lambda$ nm', 'Interpreter', 'latex')
    ylabel(ax, 'Intensity', 'Interpreter', 'latex')
    hold(ax, 'on');
    [x, y, ~] = Anatole_spectro_mirrror(-90 + appState.mirroir1.calibration, spectro, 1);
    [x, y, ~] = Anatole_spectro_mirrror(theta2 + appState.mirroir2.calibration, spectro, 2);
    y2 = (y - min(y)) ./ (yl - min(y));
    plot(ax, x, y2, 'DisplayName', 'BP2','Color',[1,0,0,0.2],'LineStyle',':')
    [x, y, ~] = Anatole_spectro_mirrror(-90 + appState.mirroir2.calibration, spectro, 2);
    [x, y, ~] = Anatole_spectro_mirrror(theta3 + calibration3, spectro, 3);
    y3 = (y - min(y)) ./ (yl - min(y));
    plot(ax, x, y3, 'DisplayName', 'CP','Color',[1,0,1,0.2],'LineStyle',':')
    plot(ax, x, y1 .* y2 .* y3, 'DisplayName', 'product y1*y2*y3','Color',[0,1,1,0.2],'LineStyle',':')
    ylim(ax,[-0.1,1.1])
    Anatole_moove_system(theta1, theta2, theta3, appState.mirroir1.calibration, appState.mirroir2.calibration, calibration3);
    [x, y] = Anatole_spectro_mesure(spectro);
    y = (y - min(y)) ./ (yl - min(y));
    plot(ax, x, y, 'DisplayName', 'FT')
    legend(ax)
    plot(ax, [peak1, peak1], [0, max(y)],'DisplayName', 'peak expected')
    plot(ax, [peak1 + Width1 / 2, peak1 + Width1 / 2], [0, max(y)], 'g', 'DisplayName', 'SP expected')
    plot(ax, [peak1 - Width1 / 2, peak1 - Width1 / 2], [0, max(y)], 'g', 'DisplayName', 'LP expected')
    hold(ax, 'off');

end

function updateSpectrum2(axSpectrum2, peak2, Width2, spectro, appState)
    % copy paste updateSpectrum

end

function calibrationData = calibration(communicationChannel, range, spectro, mirror_nbr, seuil, axSpectrum)
    % Exécution du script de calibration

    % Appeler Anatole_spectro_mirrrorClass pour le premier miroir
    [~, ~, ~] = Anatole_spectro_mirrrorClass(-2.4 - 90, spectro, 3, communicationChannel);
    % Initialisation des paramètres
    calibration2temp = -140; % Définir la valeur de calibration2 temporaire
    [~, ~, ~] = Anatole_spectro_mirrrorClass(calibration2temp + 90, spectro, mod(mirror_nbr, 2) + 1, communicationChannel); % Pivot du deuxième miroir
    [x, yl, ~] = Anatole_spectro_mirrror(calibration2temp + 90, spectro, mod(mirror_nbr - 1, 2) + 1);
    DATA = zeros(length(range), 2000); % Matrice de données d'acquisition
    SIG = DATA; % Matrice des signaux filtrés
    Xtemp = zeros(length(range), 2); % Matrice temporaire des positions X
    angletemp = zeros(size(range)); % Vecteur temporaire des angles


    % Boucle sur la plage d'angles
    for j = 1:length(range)
        i = range(j); % Angle courant
        [x, y, ~] = Anatole_spectro_mirrror(i, spectro, mod(mirror_nbr - 1, 2) + 1);
        DATA(j, :) = y; % Stocker les données dans DATA

        % Tracer les données de spectroscopie pour l'angle courant
        %plot(x, y); hold on;
        y1 = (y - min(y)) ./ (yl - min(y));
        % Appliquer un filtre médian pour lisser et normaliser les données
        sig = normalize(medfilt1(y1, 3), 'range');
        SIG(j, :) = sig; % Stocker le signal normalisé dans SIG
        % Détecter les points où le signal dépasse un seuil (0.22)
        DERIV = sig > seuil;
        Xfirst = find(DERIV, 1, 'first');
        Xlast = find(DERIV, 1, 'last');

        if ~isempty(Xfirst) && ~isempty(Xlast) && (x(Xlast) - x(Xfirst)) > 17 && (x(Xlast) - x(Xfirst)) < 23 && x(Xlast) < 580 && x(Xfirst) > 480 && length(Xfirst) == 1 && length(Xlast) == 1 && y1(Xfirst) > (seuil - 0.15) && y1(Xfirst) < (seuil + 0.15) && y1(Xlast) > (seuil - 0.15) && y1(Xlast) < (seuil + 0.15)

            % Stocker les positions valides dans Xtemp
            Xtemp(j, :) = [x(Xfirst), x(Xlast)];
            angletemp(j) = i; % Stocker l'angle correspondant
            fprintf("ADDED\n");
            % Marquer les positions détectées sur le graphique
            xlabel(axSpectrum, '$\lambda$ nm', 'Interpreter', 'latex')
            ylabel(axSpectrum, 'Intensity', 'Interpreter', 'latex')
            plot(axSpectrum, x, sig,'DisplayName','BP transmitance')
            hold(axSpectrum, 'on')
            plot(axSpectrum, [min(x), max(x)], [seuil, seuil],'DisplayName','Seuil')
            scatter(axSpectrum, [x(Xfirst), x(Xlast)], [SIG(j, Xfirst), SIG(j, Xlast)],'DisplayName','Loc SP & LP');
            ylim(axSpectrum, [-0.1, 1.1])
            hold(axSpectrum, 'off')
        end
    end
    hold(axSpectrum, 'off');

    % Filtrer les positions valides stockées dans Xtemp
    valid_idx = Xtemp(:, 1) ~= 0;
    X = Xtemp(valid_idx, :);
    angle = angletemp(valid_idx);

    % Ajuster les courbes pour obtenir les paramètres de calibration
    [x0LP, neffLP, phaseLP, x0SP, neffSP, phaseSP] = AnatoleCurveFit(angle, X(:, 1), max(X(:, 1)), angle(X(:, 1) == max(X(:, 1))), X(:, 2), max(X(:, 2)), angle(X(:, 2) == max(X(:, 2))));
    % Calculer la valeur de calibration
    calibration = (mod(phaseLP, 180) + mod(phaseSP, 180)) / 2;
    calibrationLP = mod(phaseLP, 180);
    calibrationSP = mod(phaseSP, 180);
    % Acquisition des données de spectroscopie pour la calibration
    [x, y, ~] = Anatole_spectro_mirrrorClass(calibration, spectro, mirror_nbr, communicationChannel);

    % Stocker toutes les variables dans la propriété calibrationData
    calibrationData = struct('x', x, 'y', y, 'DATA', DATA, 'SIG', SIG, ...
        'X', X, 'angle', angle, ...
        'x0LP', x0LP, 'neffLP', neffLP, 'phaseLP', phaseLP, ...
        'x0SP', x0SP, 'neffSP', neffSP, 'phaseSP', phaseSP, ...
        'calibration', calibration, 'calibrationLP', calibrationLP, ...
        'calibrationSP', calibrationSP);
end
function p = moove_mirror(Communication_Channel,mirror_nbr,angle)
    mir = elliptec_driver([1,2,3], Communication_Channel);
    p=set_position(mir,mirror_nbr,angle);
end

