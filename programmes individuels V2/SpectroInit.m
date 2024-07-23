function Instr = SpectroInit() % Initialise connection
[ret] = ATSpectrographInitialize('');
ATSpectrographCheckError(ret);

% Initialise connection with Andor CCD
ret = AndorInitialize('');
[ret, Instr.InstrInfo.CCD.Capabilities] = GetCapabilities();
CheckWarning(ret);

% Check if CCD is cooled and turn on cooling
[ret, Instr.InstrInfo.CCD.isCoolerOn] = IsCoolerOn();
Instr.InstrInfo.CCD.SetT = -80;
[ret] = SetTemperature(Instr.InstrInfo.CCD.SetT);

if ~Instr.InstrInfo.CCD.isCoolerOn
    [ret] = CoolerON(); % Turn on temperature cooler
end

[ret, Instr.InstrInfo.CCD.CoolingOn] = IsCoolerOn();
[ret, Instr.InstrInfo.CCD.Temperature] = GetTemperature();

if Instr.InstrInfo.CCD.CoolingOn ~= 1 % au cas ou
    fprintf('CCD.CoolingOn~=1\n');
end

[ret, Instr.InstrInfo.CCD.PixelSize] = GetPixelSize();
[ret, Instr.InstrInfo.CCD.xpixels, Instr.InstrInfo.CCD.ypixels] = GetDetector();

% Check num devices = 1
[ret, Instr.InstrInfo.Spectrometer.deviceCount] = ATSpectrographGetNumberDevices();
ATSpectrographCheckWarning(ret);

if Instr.InstrInfo.Spectrometer.deviceCount ~= 1 && Instr.InstrInfo.Spectrometer.deviceCount ~= 0
    error('more than 1 spectrometer found');
else
    i = 0;
end

% Get serial number to check connection
[ret, Instr.InstrInfo.Spectrometer.serial] = ATSpectrographGetSerialNumber(0, 256);
ATSpectrographCheckWarning(ret);

[ret, Instr.InstrInfo.Spectrometer.noGratings] = ATSpectrographGetNumberGratings(0);
ATSpectrographCheckWarning(ret);

[ret, Instr.InstrInfo.Spectrometer.currGrating] = ATSpectrographGetGrating(0);
ATSpectrographCheckWarning(ret);

[ret] = ATSpectrographSetGrating(0, 2); % modifier le gratting
ATSpectrographCheckWarning(ret);

[ret] = ATSpectrographSetWavelength(0, 550); % centre de la mesure
ATSpectrographCheckWarning(ret);

switch Instr.InstrInfo.Spectrometer.currGrating
    case 1
        Instr.GratingDropDown.Value = '150';
    case 2
        Instr.GratingDropDown.Value = '600';
    case 3
        Instr.GratingDropDown.Value = '1200';
end

for grat = 1:3
    [ret, Instr.InstrInfo.Spectrometer.currGratingInfo(grat).lines, Instr.InstrInfo.Spectrometer.currGratingInfo(grat).blaze, Instr.InstrInfo.Spectrometer.currGratingInfo(grat).home, Instr.InstrInfo.Spectrometer.currGratingInfo(grat).offset] = ATSpectrographGetGratingInfo(0, grat, 256);
    ATSpectrographCheckWarning(ret);
end

[ret, Instr.InstrInfo.Spectrometer.currWL] = ATSpectrographGetWavelength(0);
ATSpectrographCheckWarning(ret);

Instr.WavelengthnmEditField.Value = Instr.InstrInfo.Spectrometer.currWL;

[ret, Instr.InstrInfo.Spectrometer.WLmin_bef, Instr.InstrInfo.Spectrometer.WLmax_bef] = ATSpectrographGetWavelengthLimits(0, Instr.InstrInfo.Spectrometer.currGrating);
ATSpectrographCheckWarning(ret);

[ret] = ATSpectrographSetPixelWidth(0, Instr.InstrInfo.CCD.PixelSize);
ATSpectrographCheckWarning(ret);

[ret, Instr.InstrInfo.Spectrometer.isshutter] = ATSpectrographShutterIsPresent(0);
ATSpectrographCheckWarning(ret);

[ret, Instr.InstrInfo.Spectrometer.isflipperinput] = ATSpectrographFlipperMirrorIsPresent(0, 1);
ATSpectrographCheckWarning(ret);

[ret, Instr.InstrInfo.Spectrometer.isflipperoutput] = ATSpectrographFlipperMirrorIsPresent(0, 2);
ATSpectrographCheckWarning(ret);

[ret] = ATSpectrographSetNumberPixels(0, Instr.InstrInfo.CCD.xpixels);
ATSpectrographCheckWarning(ret);

[ret, Instr.InstrInfo.Spectrometer.calib] = ATSpectrographGetCalibration(0, Instr.InstrInfo.CCD.xpixels);
ATSpectrographCheckWarning(ret);

[ret, Instr.InstrInfo.Spectrometer.WLmin, Instr.InstrInfo.Spectrometer.WLmax] = ATSpectrographGetWavelengthLimits(0, Instr.InstrInfo.Spectrometer.currGrating);
ATSpectrographCheckWarning(ret);

[ret, Instr.InstrInfo.Spectrometer.low, Instr.InstrInfo.Spectrometer.high] = ATSpectrographGetCCDLimits(0, 1);
ATSpectrographCheckWarning(ret);

[ret, Instr.InstrInfo.Spectrometer.port] = ATSpectrographGetFlipperMirror(0, 1);
ATSpectrographCheckError(ret);

switch Instr.InstrInfo.Spectrometer.port
    case 0
        Instr.InputportDropDown.Value = 'Direct';
    case 1
        Instr.InputportDropDown.Value = 'Side';
end

[ret] = ATSpectrographSetFlipperMirror(0, 1, 1); % 'Direct' =0 ;'Side' = 1
ATSpectrographCheckError(ret);

[ret, Instr.InstrInfo.Spectrometer.port] = ATSpectrographGetFlipperMirror(0, 2);
ATSpectrographCheckError(ret);

switch Instr.InstrInfo.Spectrometer.port
    case 0
        Instr.OutputportDropDown.Value = 'CCD';
    case 1
        Instr.OutputportDropDown.Value = 'Free space';
end

for i = 0:2
    [ret, shutterbncpossible] = ATSpectrographIsShutterModePossible(0, i);
    Instr.InstrInfo.Spectrometer.shutterbncpossible(i + 1) = shutterbncpossible;
end

[ret] = ATSpectrographSetShutter(0, 2);
Instr.InstrInfo.Spectrometer.shuttermode(2) = 2;

[ret, shuttermode] = ATSpectrographGetShutter(0);
Instr.InstrInfo.Spectrometer.shuttermode(1) = shuttermode;

Instr.InstrInfo.Spectrometer = Instr.InstrInfo.Spectrometer;
end
