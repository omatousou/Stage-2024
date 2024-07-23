function [x,y,p] = Anatole_spectro_filter(i,spectro,mirror_nbr,com)
    if ~ischar(com)
        if isstring(com)
            com = char(com);
        else
            error('com input is not the wright output')
        end
    end
    
    mir = elliptec_driver([1,2,3],'COM8');
    p=set_position(mir,mirror_nbr,i);
    %disp(p)
    app.AndorReadoutModeDropDown.Value = "Single-track";
    
    [ret]=SetShutter(1, 0, 0, 0);%   Open Shutter IN FULLY AUTO
    CheckWarning(ret);
    
    % set single track ROI
    [ret]=SetSingleTrack(72,50);%)app.centralvalueSpinner.Value, app.heightSpinner.Value);
    CheckWarning(ret);
    [ret,xpixels, ~] = GetDetector;           %   Get the CCD size
    CheckWarning(ret);
    app.InstrInfo.Spectrometer.xpixels= xpixels;
    
    acqcode = 1; %Single scan for background if requested
    trigmode=0;
    readcode = 3;
    
    app.AcqTimeEditField.Value = 1;
    
    [ret]=SetAcquisitionMode(acqcode);                  %   Set acquisition mode; 1 for Single Scan
    CheckWarning(ret);
    [ret]=SetExposureTime(double(app.AcqTimeEditField.Value));                  %   Set exposure time in second
    CheckWarning(ret);
    [ret]=SetReadMode(readcode);                         %   Set read mode; 4 for Image
    CheckWarning(ret);
    [ret]=SetTriggerMode(trigmode);                      %   Set internal trigger mode
    CheckWarning(ret);
    
    app.InstrInfo.CCD.bkg =0 ;% acquire_background(app,0);
    
    app.AndorAcqModeDropDown.Value ="Single scan";
    app.thismeas = 'Spectrum';
    [ret] = StartAcquisition();
    CheckWarning(ret);
    
    [ret] = WaitForAcquisition();
    CheckWarning(ret);
    
    
    [ret, imageData] = GetMostRecentImage(xpixels);
    CheckWarning(ret);
    x = double(spectro.calib);
    y = double(imageData-app.InstrInfo.CCD.bkg);
    [ret]=AbortAcquisition;
    CheckWarning(ret);
  
end
