% Créer et initialiser l'objet spectro
% Créer un objet app pour stocker les informations
app = SpectroInit();
spectro = app.InstrInfo.Spectrometer();


% Créer et calibrer l'objet mirroir
communicationChannel = 'COM8'; % Remplacez par votre canal de communication
mirroir1 = AnatoleMirroir(communicationChannel);
range = 0:6:360; % Plage d'angles à parcourir
mirroir1 = mirroir1.calibration(range, spectro,1);

