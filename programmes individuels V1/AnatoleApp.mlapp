classdef AnatoleApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        GridLayout                 matlab.ui.container.GridLayout
        SpectrumAxes               matlab.ui.control.UIAxes
        TransferFunctionAxes       matlab.ui.control.UIAxes
        CalibrationPanel           matlab.ui.container.Panel
        CalibrationGrid            matlab.ui.container.GridLayout
        CalibrationButton1         matlab.ui.control.Button
        CalibrationButton2         matlab.ui.control.Button
        CalibrationButton3         matlab.ui.control.Button
        CalibrationButton4         matlab.ui.control.Button
        CalibrationParamPanel      matlab.ui.container.Panel
        CalibrationParamGrid       matlab.ui.container.GridLayout
        LabelDebut                 matlab.ui.control.Label
        DebutField                 matlab.ui.control.EditField
        LabelFin                   matlab.ui.control.Label
        FinField                   matlab.ui.control.EditField
        LabelStep                  matlab.ui.control.Label
        StepField                  matlab.ui.control.EditField
        LabelSeuil                 matlab.ui.control.Label
        SeuilField                 matlab.ui.control.EditField
        FilterParamPanel           matlab.ui.container.Panel
        FilterParamGrid            matlab.ui.container.GridLayout
        LabelPeak1                 matlab.ui.control.Label
        Peak1Field                 matlab.ui.control.NumericEditField
        LabelWidth1                matlab.ui.control.Label
        Width1Field                matlab.ui.control.NumericEditField
        LabelPeak2                 matlab.ui.control.Label
        Peak2Field                 matlab.ui.control.NumericEditField
        LabelWidth2                matlab.ui.control.Label
        Width2Field                matlab.ui.control.NumericEditField
        AcquisitionButton          matlab.ui.control.Button
        LabelSP1                   matlab.ui.control.Label
        SP1Field                   matlab.ui.control.EditField
        LabelLP2                   matlab.ui.control.Label
        LP2Field                   matlab.ui.control.EditField
        BP1Button                  matlab.ui.control.Button
        BP2Button                  matlab.ui.control.Button
        CPButton                   matlab.ui.control.Button
    end
    
    properties (Access = private)
        appState                   % AppState object
        spectro                    % Spectrometer object
    end

    methods (Access = private)
        
        % Update methods
        function updateBalayageParams(app, src, change)
            newval = str2double(src.Value);
            if ~isnan(newval) && ~isnan(change)
                app.appState.change_balayageEnAngle(newval, change);
            else
                disp('Valeur invalide pour le balayage en angle.');
            end
        end

        function updateSeuil(app, src)
            newSeuil = str2double(src.Value); % Convertir la chaîne de caractères en nombre
            if ~isnan(newSeuil)
                app.appState.change_seuil(newSeuil);
            else
                disp('Valeur invalide pour le seuil.');
            end
        end
        
        % Callback methods
        function runCalibration(app, channel, mirror_nbr)
            cla(app.SpectrumAxes);
            data = calibration(channel, app.appState.balayageEnAngle, app.spectro, mirror_nbr, app.appState.seuil, app.SpectrumAxes);
            if (mirror_nbr == 1) && (string(channel) == "COM8") % Ajuster au besoin
                app.appState.change_mirr1(data);
                disp('Calibration Data Stored:');
                disp(app.appState.mirroir1);
            elseif (mirror_nbr == 2) && (string(channel) == "COM8")
                app.appState.change_mirr2(data);
                disp('Calibration Data Stored:');
                disp(app.appState.mirroir2);
            elseif (mirror_nbr == 1) && (string(channel) == "COM9")
                app.appState.change_mirr3(data);
                disp('Calibration Data Stored:');
                disp(app.appState.mirroir3);
            elseif (mirror_nbr == 2) && (string(channel) == "COM9")
                app.appState.change_mirr4(data);
                disp('Calibration Data Stored:');
                disp(app.appState.mirroir3);
            else
                error('wrong mirror nbr or communication channel')
            end
        end

        function startAcquisition(app)
            [x, y] = Anatole_spectro_mesure(app.spectro);
            plot(app.TransferFunctionAxes, x, y);
            ylim(app.TransferFunctionAxes, 'auto');
            xlim(app.TransferFunctionAxes, 'auto');
            fprintf('\n__________app__________');
            disp(app.appState);
            fprintf('\n__________BP1_________');
            disp(app.appState.mirroir1);
            fprintf('\n__________BP2_________');
            disp(app.appState.mirroir2);
            fprintf('\n______________________\n');
        end
        
        function newButton1Callback(app)
            [~, ~, ~] = Anatole_spectro_mirrror(-90 + app.appState.mirroir1.calibration, app.spectro, 1);
            disp('Filter 1 : 90°');
            app.SP1Field.Value = ''; % Supprime la valeur du champ de saisie newSP1
        end
        
        function newButton2Callback(app)
            [~, ~, ~] = Anatole_spectro_mirrror(-90 + app.appState.mirroir2.calibration, app.spectro, 2);
            disp('Filter 2 : 90°');
            app.LP2Field.Value = ''; % Supprime la valeur du champ de saisie newLP2
        end

        function newButton3Callback(app)
            calibration3 = -2;
            [~, ~, ~] = Anatole_spectro_mirrror(-90 + calibration3, app.spectro, 3);
            disp('CP : 90°');
            app.SP1Field.Value = ''; % Supprime la valeur du champ de saisie newSP1
            app.LP2Field.Value = ''; % Supprime la valeur du champ de saisie newLP2
        end

        function updateSP1(app, SP1)
            SP1 = str2double(SP1);
            cla(app.TransferFunctionAxes);
            if isempty(SP1), SP1 = 0; end

            x0SP = app.appState.mirroir1.x0SP;
            neffSP = app.appState.mirroir1.neffSP;
            theta1 = Anatole_Courbe_Inverse(x0SP, neffSP, SP1);
            [x, y, ~] = Anatole_spectro_mirrror(app.appState.mirroir1.calibration + theta1, app.spectro, 1);
            plot(app.TransferFunctionAxes, x, y);
            title(app.TransferFunctionAxes, 'Spectre');
            xlabel(app.TransferFunctionAxes, 'Frequency');
            ylabel(app.TransferFunctionAxes, 'Amplitude');
            hold(app.TransferFunctionAxes, 'off');
        end

        function updateLP2(app, LP2)
            LP2 = str2double(LP2);
            cla(app.TransferFunctionAxes);
            if isempty(LP2), LP2 = 0; end

            x2LP = app.appState.mirroir2.x0LP;
            neff2LP = app.appState.mirroir2.neffLP;
            theta2 = -Anatole_Courbe_Inverse(x2LP, neff2LP, LP2);

            [x, y, ~] = Anatole_spectro_mirrror(theta2 + app.appState.mirroir2.calibration, app.spectro, 2);
            plot(app.TransferFunctionAxes, x, y);
            title(app.TransferFunctionAxes, 'Spectre');
            xlabel(app.TransferFunctionAxes, 'Frequency');
            ylabel(app.TransferFunctionAxes, 'Amplitude');
            hold(app.TransferFunctionAxes, 'off');
        end

    end

    methods (Access = private)
        
        function updateSpectrum(app, peak1, Width1)
            cla(app.SpectrumAxes);
            cla(app.TransferFunctionAxes);

            if isempty(peak1), peak1 = 0; end
            if isempty(Width1), Width1 = 1; end

            x2LP = app.appState.mirroir2.x0LP;
            x0SP = app.appState.mirroir1.x0SP;
            neffSP = app.appState.mirroir1.neffSP;
            neff2LP = app.appState.mirroir2.neffLP;
            neffLP = app.appState.mirroir1.neffLP;
            neff2SP = app.appState.mirroir2.neffSP;

            [theta1, theta2, theta3] = Anatole_Calcule_des_Angles(peak1, Width1 / 2, x2LP, x0SP, neffSP, neff2LP, neffLP, neff2SP);
            calibration3 = -2; % lame compensatrice

            [x, y, ~] = Anatole_spectro_mirrror(-90 + app.appState.mirroir1.calibration, app.spectro, 1);
            [x, y, ~] = Anatole_spectro_mirrror(-90 + app.appState.mirroir2.calibration, app.spectro, 2);
            [x, yl, ~] = Anatole_spectro_mirrror(-90 + calibration3, app.spectro, 3);
            [x, y, ~] = Anatole_spectro_mirrror(theta1 + app.appState.mirroir1.calibration, app.spectro, 1);
            y1 = (y - min(y)) ./ (yl - min(y));
            plot(app.SpectrumAxes, x, y1, 'DisplayName', 'BP1');
            legend(app.SpectrumAxes);
            hold(app.SpectrumAxes, 'on');
            [x, y, ~] = Anatole_spectro_mirrror(-90 + app.appState.mirroir1.calibration, app.spectro, 1);
            [x, y, ~] = Anatole_spectro_mirrror(theta2 + app.appState.mirroir2.calibration, app.spectro, 2);
            y2 = (y - min(y)) ./ (yl - min(y));
            plot(app.SpectrumAxes, x, y2, 'DisplayName', 'BP2');
            [x, y, ~] = Anatole_spectro_mirrror(-90 + app.appState.mirroir2.calibration, app.spectro, 2);
            [x, y, ~] = Anatole_spectro_mirrror(theta3 + calibration3, app.spectro, 3);
            y3 = (y - min(y)) ./ (yl - min(y));
            plot(app.SpectrumAxes, x, y3, 'DisplayName', 'CP');
            xlabel(app.SpectrumAxes, '$\lambda$ nm', 'Interpreter', 'latex');
            ylabel(app.SpectrumAxes, 'Intensity', 'Interpreter', 'latex');
            plot(app.TransferFunctionAxes, x, y1 .* y2 .* y3, 'DisplayName', 'product y1*y2*y3','Color',[0,0,1,0.2],'LineStyle',':');
            ylim(app.TransferFunctionAxes,[-0.1,1.1]);

            Anatole_moove_system(theta1, theta2, theta3, app.appState.mirroir1.calibration, app.appState.mirroir2.calibration, calibration3);
            [x, y] = Anatole_spectro_mesure(app.spectro);
            hold(app.TransferFunctionAxes, 'on');
            y = (y - min(y)) ./ (yl - min(y));
            plot(app.TransferFunctionAxes, x, y, 'DisplayName', 'FT');
            legend(app.TransferFunctionAxes);
            plot(app.TransferFunctionAxes, [peak1, peak1], [0, max(y)],'DisplayName', 'peak expected');
            plot(app.TransferFunctionAxes, [peak1 + Width1 / 2, peak1 + Width1 / 2], [0, max(y)], 'g', 'DisplayName', 'SP expected');
            plot(app.TransferFunctionAxes, [peak1 - Width1 / 2, peak1 - Width1 / 2], [0, max(y)], 'g', 'DisplayName', 'LP expected');
            title(app.TransferFunctionAxes, 'Spectre');
            xlabel(app.TransferFunctionAxes, '$\lambda$ nm', 'Interpreter', 'latex');
            ylabel(app.TransferFunctionAxes, 'Intensity', 'Interpreter', 'latex');
            hold(app.TransferFunctionAxes, 'off');
        end

        function updateSpectrum2(app, peak2, Width2)
            % copy paste updateSpectrum

        end

    end

    % Component initialization
    methods (Access = private)

        function createComponents(app)
            % Initialize appState before creating components
            app.appState = AppState();
            Init = SpectroInit();
            app.spectro = Init.InstrInfo.Spectrometer;

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100, 100, 1000, 800];
            app.UIFigure.Name = 'Application de Filtrage';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.RowHeight = {'1x', '1x', '2x', '1x'};
            app.GridLayout.ColumnWidth = {'1x', '1x'};

            % Create SpectrumAxes
            app.SpectrumAxes = uiaxes(app.GridLayout);
            title(app.SpectrumAxes, 'Spectre de la calibration');
            app.SpectrumAxes.Layout.Row = 2;
            app.SpectrumAxes.Layout.Column = [1, 2];

            % Create TransferFunctionAxes
            app.TransferFunctionAxes = uiaxes(app.GridLayout);
            title(app.TransferFunctionAxes, 'Spectre de la fonction de transfert');
            app.TransferFunctionAxes.Layout.Row = 3;
            app.TransferFunctionAxes.Layout.Column = 1;

            % Create CalibrationPanel
            app.CalibrationPanel = uipanel(app.GridLayout);
            app.CalibrationPanel.Title = 'Calibration';
            app.CalibrationPanel.Layout.Row = 1;
            app.CalibrationPanel.Layout.Column = 1;

            % Create CalibrationGrid
            app.CalibrationGrid = uigridlayout(app.CalibrationPanel);
            app.CalibrationGrid.RowHeight = {'1x', '1x'};
            app.CalibrationGrid.ColumnWidth = {'1x', '1x'};

            % Create CalibrationButton1
            app.CalibrationButton1 = uibutton(app.CalibrationGrid, 'push');
            app.CalibrationButton1.ButtonPushedFcn = @(btn, event) runCalibration(app, 'COM8', 1);
            app.CalibrationButton1.Layout.Row = 1;
            app.CalibrationButton1.Layout.Column = 1;
            app.CalibrationButton1.Text = 'Calibration Filtre 1 Ligne 1';

            % Create CalibrationButton2
            app.CalibrationButton2 = uibutton(app.CalibrationGrid, 'push');
            app.CalibrationButton2.ButtonPushedFcn = @(btn, event) runCalibration(app, 'COM8', 2);
            app.CalibrationButton2.Layout.Row = 2;
            app.CalibrationButton2.Layout.Column = 1;
            app.CalibrationButton2.Text = 'Calibration Filtre 2 Ligne 1';

            % Create CalibrationButton3
            app.CalibrationButton3 = uibutton(app.CalibrationGrid, 'push');
            app.CalibrationButton3.ButtonPushedFcn = @(btn, event) runCalibration(app, 'COM9', 1);
            app.CalibrationButton3.Layout.Row = 1;
            app.CalibrationButton3.Layout.Column = 2;
            app.CalibrationButton3.Text = 'Calibration Filtre 1 Ligne 2';

            % Create CalibrationButton4
            app.CalibrationButton4 = uibutton(app.CalibrationGrid, 'push');
            app.CalibrationButton4.ButtonPushedFcn = @(btn, event) runCalibration(app, 'COM9', 2);
            app.CalibrationButton4.Layout.Row = 2;
            app.CalibrationButton4.Layout.Column = 2;
            app.CalibrationButton4.Text = 'Calibration Filtre 2 Ligne 2';

            % Create CalibrationParamPanel
            app.CalibrationParamPanel = uipanel(app.GridLayout);
            app.CalibrationParamPanel.Title = 'Paramétrage de la calibration';
            app.CalibrationParamPanel.Layout.Row = 1;
            app.CalibrationParamPanel.Layout.Column = 2;

            % Create CalibrationParamGrid
            app.CalibrationParamGrid = uigridlayout(app.CalibrationParamPanel);
            app.CalibrationParamGrid.RowHeight = {'1x', '1x', '1x', '1x'};
            app.CalibrationParamGrid.ColumnWidth = {'1x', '2x'};

            % Create LabelDebut
            app.LabelDebut = uilabel(app.CalibrationParamGrid);
            app.LabelDebut.Text = 'Début:';
            app.LabelDebut.Layout.Row = 1;
            app.LabelDebut.Layout.Column = 1;

            % Create DebutField
            app.DebutField = uieditfield(app.CalibrationParamGrid, 'text');
            app.DebutField.Value = num2str(app.appState.debut);
            app.DebutField.Layout.Row = 1;
            app.DebutField.Layout.Column = 2;

            % Create LabelFin
            app.LabelFin = uilabel(app.CalibrationParamGrid);
            app.LabelFin.Text = 'Fin:';
            app.LabelFin.Layout.Row = 2;
            app.LabelFin.Layout.Column = 1;

            % Create FinField
            app.FinField = uieditfield(app.CalibrationParamGrid, 'text');
            app.FinField.Value = num2str(app.appState.fin);
            app.FinField.Layout.Row = 2;
            app.FinField.Layout.Column = 2;

            % Create LabelStep
            app.LabelStep = uilabel(app.CalibrationParamGrid);
            app.LabelStep.Text = 'Step:';
            app.LabelStep.Layout.Row = 3;
            app.LabelStep.Layout.Column = 1;

            % Create StepField
            app.StepField = uieditfield(app.CalibrationParamGrid, 'text');
            app.StepField.Value = num2str(app.appState.step);
            app.StepField.Layout.Row = 3;
            app.StepField.Layout.Column = 2;

            % Create LabelSeuil
            app.LabelSeuil = uilabel(app.CalibrationParamGrid);
            app.LabelSeuil.Text = 'Seuil:';
            app.LabelSeuil.Layout.Row = 4;
            app.LabelSeuil.Layout.Column = 1;

            % Create SeuilField
            app.SeuilField = uieditfield(app.CalibrationParamGrid, 'text');
            app.SeuilField.Value = num2str(app.appState.seuil);
            app.SeuilField.Layout.Row = 4;
            app.SeuilField.Layout.Column = 2;

            % Create FilterParamPanel
            app.FilterParamPanel = uipanel(app.GridLayout);
            app.FilterParamPanel.Title = 'Paramétrage des filtres';
            app.FilterParamPanel.Layout.Row = [3, 4];
            app.FilterParamPanel.Layout.Column = 2;

            % Create FilterParamGrid
            app.FilterParamGrid = uigridlayout(app.FilterParamPanel);
            app.FilterParamGrid.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit'};
            app.FilterParamGrid.ColumnWidth = {'fit', '1x'};

            % Create LabelPeak1
            app.LabelPeak1 = uilabel(app.FilterParamGrid);
            app.LabelPeak1.Text = 'A Peak (nm):';
            app.LabelPeak1.Layout.Row = 1;
            app.LabelPeak1.Layout.Column = 1;

            % Create Peak1Field
            app.Peak1Field = uieditfield(app.FilterParamGrid, 'numeric');
            app.Peak1Field.Layout.Row = 1;
            app.Peak1Field.Layout.Column = 2;

            % Create LabelWidth1
            app.LabelWidth1 = uilabel(app.FilterParamGrid);
            app.LabelWidth1.Text = 'A width (nm):';
            app.LabelWidth1.Layout.Row = 2;
            app.LabelWidth1.Layout.Column = 1;

            % Create Width1Field
            app.Width1Field = uieditfield(app.FilterParamGrid, 'numeric');
            app.Width1Field.Layout.Row = 2;
            app.Width1Field.Layout.Column = 2;

            % Create LabelPeak2
            app.LabelPeak2 = uilabel(app.FilterParamGrid);
            app.LabelPeak2.Text = 'B Peak (nm):';
            app.LabelPeak2.Layout.Row = 3;
            app.LabelPeak2.Layout.Column = 1;

            % Create Peak2Field
            app.Peak2Field = uieditfield(app.FilterParamGrid, 'numeric');
            app.Peak2Field.Layout.Row = 3;
            app.Peak2Field.Layout.Column = 2;

            % Create LabelWidth2
            app.LabelWidth2 = uilabel(app.FilterParamGrid);
            app.LabelWidth2.Text = 'B width (nm):';
            app.LabelWidth2.Layout.Row = 4;
            app.LabelWidth2.Layout.Column = 1;

            % Create Width2Field
            app.Width2Field = uieditfield(app.FilterParamGrid, 'numeric');
            app.Width2Field.Layout.Row = 4;
            app.Width2Field.Layout.Column = 2;

            % Create AcquisitionButton
            app.AcquisitionButton = uibutton(app.FilterParamGrid, 'push');
            app.AcquisitionButton.Text = 'Start Acquisition';
            app.AcquisitionButton.ButtonPushedFcn = @(btn, event) startAcquisition(app);
            app.AcquisitionButton.Layout.Row = 5;
            app.AcquisitionButton.Layout.Column = [1, 2];

            % Create LabelSP1
            app.LabelSP1 = uilabel(app.FilterParamGrid);
            app.LabelSP1.Text = 'position sup BP1 (nm):';
            app.LabelSP1.Layout.Row = 6;
            app.LabelSP1.Layout.Column = 1;

            % Create SP1Field
            app.SP1Field = uieditfield(app.FilterParamGrid, 'text');
            app.SP1Field.Layout.Row = 6;
            app.SP1Field.Layout.Column = 2;

            % Create LabelLP2
            app.LabelLP2 = uilabel(app.FilterParamGrid);
            app.LabelLP2.Text = 'position inf BP2 (nm):';
            app.LabelLP2.Layout.Row = 7;
            app.LabelLP2.Layout.Column = 1;

            % Create LP2Field
            app.LP2Field = uieditfield(app.FilterParamGrid, 'text');
            app.LP2Field.Layout.Row = 7;
            app.LP2Field.Layout.Column = 2;

            % Create BP1Button
            app.BP1Button = uibutton(app.FilterParamGrid, 'push');
            app.BP1Button.Text = 'BP1 : 0°';
            app.BP1Button.ButtonPushedFcn = @(btn, event) newButton1Callback(app);
            app.BP1Button.Layout.Row = 8;
            app.BP1Button.Layout.Column = 1;

            % Create BP2Button
            app.BP2Button = uibutton(app.FilterParamGrid, 'push');
            app.BP2Button.Text = 'BP2 0°';
            app.BP2Button.ButtonPushedFcn = @(btn, event) newButton2Callback(app);
            app.BP2Button.Layout.Row = 8;
            app.BP2Button.Layout.Column = 2;

            % Create CPButton
            app.CPButton = uibutton(app.FilterParamGrid, 'push');
            app.CPButton.Text = 'CP 0°';
            app.CPButton.ButtonPushedFcn = @(btn, event) newButton3Callback(app);
            app.CPButton.Layout.Row = 9;
            app.CPButton.Layout.Column = [1, 2];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';

            % Add listeners for new fields
            addlistener(app.DebutField, 'ValueChanged', @(src, event) updateBalayageParams(app, src, 1));
            addlistener(app.FinField, 'ValueChanged', @(src, event) updateBalayageParams(app, src, 3));
            addlistener(app.StepField, 'ValueChanged', @(src, event) updateBalayageParams(app, src, 2));
            addlistener(app.SeuilField, 'ValueChanged', @(src, event) updateSeuil(app, src));
        end
    end

    % App initialization and construction
    methods (Access = public)

        % Construct app
        function app = AnatoleApp
            % Custom initialization
            app.appState = AppState();
            Init = SpectroInit();
            app.spectro = Init.InstrInfo.Spectrometer;
            
            % Create UIFigure and components
            createComponents(app);
        end

        % Code that executes before app deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.UIFigure);
        end
    end
end

function p = moove_mirror(Communication_Channel,mirror_nbr,angle)
    mir = elliptec_driver([1,2,3], Communication_Channel);
    p = set_position(mir,mirror_nbr,angle);
end
