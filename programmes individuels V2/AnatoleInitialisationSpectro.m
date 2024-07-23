
% initialise connection
[ret] = ATSpectrographInitialize('');
ATSpectrographCheckError(ret);

% initialise connection with Andor CCD

% initialise connection
ret=AndorInitialize('');


[ret,app.InstrInfo.CCD.Capabilities]=GetCapabilities;
CheckWarning(ret);

% check if CCD is cooled and turn on cooling
[ret, app.ison] = IsCoolerOn();


app.InstrInfo.CCD.SetT = -80;
[ret] = SetTemperature(app.InstrInfo.CCD.SetT);
%             add2Log(app,myCheckWarning(ret));

if ~app.ison
    [ret]=CoolerON();                             %   Turn on temperature cooler
end
[ret, app.InstrInfo.CCD.CoolingOn] = IsCoolerOn();
%             add2Log(app,myCheckWarning(ret));

[ret, app.InstrInfo.CCD.T] = GetTemperature();


if app.InstrInfo.CCD.CoolingOn~=1 % au cas ou
    add2Log(app,'Coolor not on')
end

[ret, app.InstrInfo.CCD.PixelSize] = GetPixelSize();
%             add2Log(app,myCheckWarning(ret));

[ret, app.InstrInfo.CCD.xpixels, app.InstrInfo.CCD.ypixels] = GetDetector();
%             add2Log(app,myCheckWarning(ret));





% check num devices = 1
% but beware devices are called with indices 0 to N
[ret, app.deviceCount] = ATSpectrographGetNumberDevices();
ATSpectrographCheckWarning(ret);

if app.deviceCount~=1 & app.deviceCount~=0
    error('more than 1 spectrometer found')
else
    i=0;
end


%             for i=0:(deviceCount-1)
% get serial number to check connection
[ret, spectro.serial] = ATSpectrographGetSerialNumber(0, 256);
ATSpectrographCheckWarning(ret);

[ret, spectro.noGratings] = ATSpectrographGetNumberGratings(0);
ATSpectrographCheckWarning(ret);

[ret, spectro.currGrating] = ATSpectrographGetGrating(0);
ATSpectrographCheckWarning(ret);

[ret] = ATSpectrographSetGrating(0,2); %modifier le gratting
ATSpectrographCheckWarning(ret);

[ret] = ATSpectrographSetWavelength(0,550);%centre de la mesure
ATSpectrographCheckWarning(ret);





switch spectro.currGrating
    case 1
        app.GratingDropDown.Value='150';
    case 2
        app.GratingDropDown.Value='600';
    case 3
        app.GratingDropDown.Value='1200';
end

for grat = 1:3
    [ret, spectro.currGratingInfo(grat).lines, spectro.currGratingInfo(grat).blaze, spectro.currGratingInfo(grat).home, spectro.currGratingInfo(grat).offset] = ATSpectrographGetGratingInfo(0,grat,256);
    ATSpectrographCheckWarning(ret);
end

[ret, spectro.currWL] = ATSpectrographGetWavelength(0);
ATSpectrographCheckWarning(ret);

app.WavelengthnmEditField.Value = spectro.currWL;

[ret, spectro.WLmin_bef, spectro.WLmax_bef] = ATSpectrographGetWavelengthLimits(0,spectro.currGrating);
ATSpectrographCheckWarning(ret);

[ret] = ATSpectrographSetPixelWidth(0,app.InstrInfo.CCD.PixelSize);
ATSpectrographCheckWarning(ret);

[ret, spectro.isshutter] = ATSpectrographShutterIsPresent(0);
ATSpectrographCheckWarning(ret);



[ret, spectro.isflipperinput] = ATSpectrographFlipperMirrorIsPresent(0,1);
ATSpectrographCheckWarning(ret);

[ret, spectro.isflipperoutput] = ATSpectrographFlipperMirrorIsPresent(0,2);
ATSpectrographCheckWarning(ret);


[ret] = ATSpectrographSetNumberPixels(0,app.InstrInfo.CCD.xpixels);
ATSpectrographCheckWarning(ret);

[ret, spectro.calib] = ATSpectrographGetCalibration(0,app.InstrInfo.CCD.xpixels);
ATSpectrographCheckWarning(ret);

[ret, spectro.WLmin, spectro.WLmax] = ATSpectrographGetWavelengthLimits(0,spectro.currGrating);
ATSpectrographCheckWarning(ret);


[ret, spectro.low, spectro.high] = ATSpectrographGetCCDLimits(0,1);
ATSpectrographCheckWarning(ret);

[ret, spectro.port] = ATSpectrographGetFlipperMirror(0,1);
ATSpectrographCheckError(ret);

switch spectro.port
    case 0
        app.InputportDropDown.Value='Direct';
    case 1
        app.InputportDropDown.Value='Side';
end
[ret] = ATSpectrographSetFlipperMirror(0,1,1);% 'Direct' =0 ;'Side' = 1
            ATSpectrographCheckError(ret);

[ret, spectro.port] = ATSpectrographGetFlipperMirror(0,2);
ATSpectrographCheckError(ret);

switch spectro.port
    case 0
        app.OutputportDropDown.Value='CCD';
    case 1
        app.OutputportDropDown.Value='Free space';
end





for i=0:2
    [ret, shutterbncpossible] = ATSpectrographIsShutterModePossible(0,i);
    %              ATSpectrographCheckError(ret)
    spectro.shutterbncpossible(i+1) = shutterbncpossible;
end
[ret] = ATSpectrographSetShutter(0,2);
%              ATSpectrographCheckError(ret)
spectro.shuttermode(2) = 2;



[ret, shuttermode] = ATSpectrographGetShutter(0);
%              ATSpectrographCheckError(ret)
spectro.shuttermode(1) = shuttermode;
app.InstrInfo.Spectrometer = spectro;


