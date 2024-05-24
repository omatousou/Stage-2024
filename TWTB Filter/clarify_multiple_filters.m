% Plot Transmission of Two Filters as a Function of Wavelength and AOIs
%
% Objective: clarify what can be done with two filters
%
% Input: The script requires a data file (DataL057B.mat) that contains information about the filters and their transmission as a function of wavelength and angle of incidence (AOI).
%
% Output: The script outputs multiple plots showing the maximum transmission, centerWL, FWHM of the transmission spectrum.
%
% Parameters: The script has two global parameters that control the calculations performed. "half_plot" specifies whether to calculate only half of the plot or the full square. "show_full_range" specifies whether to show the full spectral range or just the region of interest (ROI). The ROI can be defined by the user using the "WL_range" parameter.
%
% Process: The data from the DataL057B.mat file is loaded and processed to provide insights into the transmission behavior of the filters. The two T spectra of the two filters are multiplied and the resulting spectrum is processed to identify its type and recover its characteristics (max transmission and FWHM). These characteristics are stored in the "VisualClues" structure. Finally, the relevant quantities from the output are plotted.



% Need function to find a particuliar configuration for one arm
%
% and give what can be done in the other arm


%% Script parameters

global half_plot show_full_range
half_plot = 1;			% calculate full square or just triangle
show_full_range = 0;	% show full spectral range (1) or just ROI (0)

% range of WL of interest
WL_range = [495	535];
recalculate = 1;

%% Loading
%%%%%%%%%%


filtername = 'TBP0156114x25x36';%'TSP0156125x36';%'TBP0156114x25x36';%'TLP0156125x36';

% load data
if ~exist('SemrockFilters','var')
	load('DataL057B.mat','SemrockFilters')
else
	disp('Already loaded')
end

if recalculate

	this_filter = SemrockFilters.(filtername);
	this_filter.Data=this_filter.Data(:,this_filter.WL>475);
	this_filter.WL = this_filter.WL(this_filter.WL>475);
	num_el = length(this_filter.AOI);

	VisualClues = struct;%
	VisualClues.Max = NaN(num_el,num_el);
	VisualClues.FWHM = NaN(num_el,num_el);
	VisualClues.Edges = NaN(num_el,num_el);
	VisualClues.CenterWL = NaN(num_el,num_el);
	VisualClues.MaxMinWL = NaN(num_el,num_el,2);
	VisualClues.Steepness = NaN(num_el,num_el,2);

	tic
	beep
	for i=1:length(this_filter.AOI)  % foreach aoi of filter 1
		aoi_1 = this_filter.AOI(i);
		for j=1:length(this_filter.AOI) % foreach aoi of filter 2

			if ~all([j<i half_plot]) % calculate except half of plot if half_plot

				aoi_2 = this_filter.AOI(j);

				% ROI
				% use full ROI and specify closer ROI
				% easier for bandwidth identification
				ROI = ones(1,length(this_filter.WL)); % dummy ROI; we always take everything
				ROI_opt = this_filter.WL>=min(WL_range) & this_filter.WL<=max(WL_range); % in case it's needed
				WL_ROI = this_filter.WL(find(ROI));

				% multiply the two T spectra (now from same filter)
				spectrum_ij = getTspectrum(this_filter.Data, i,j, ROI);

				% identify spectrum type and recover characteristics in VisualClues
				VisualClues = identify_spectrum_type(VisualClues, this_filter, spectrum_ij, i, j);


			else
				continue
			end

		end

	end
	toc
	beep; pause(0.1); beep

	SemrockFilters.(filtername).VisualClues = VisualClues;
else
	this_filter = SemrockFilters.(filtername);
	VisualClues = this_filter.VisualClues;
end


%% Plot relevant quantities from output %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ROI for plot only
WL_range = [495	535];

figure
colormap(brewermap(400 ,'RdYlBu'))
axs{1} = nexttile;
plotsomeinfo(VisualClues.Max, 'Max transmission', 'T_{max}','lin')

% axs{2} = nexttile;
% plotsomeinfo(VisualClues.Max, 'Max transmission', 'T_{max}','log')

axs{3} = nexttile;
plotsomeinfo(VisualClues.FWHM, 'Transmitted bandwidth', '\Delta\lambda (nm)','lin')


FWHM_ROI = KeepOnlyROI(VisualClues.FWHM,VisualClues.CenterWL,WL_range);
axs{4} = nexttile;
plotsomeinfo(FWHM_ROI, 'Transmitted bandwidth in ROI', '\Delta\lambda (nm)','lin')


axs{5} = nexttile;
VisualClues.CenterWL_ROI = KeepOnlyROI(VisualClues.CenterWL,VisualClues.CenterWL,WL_range);
plotsomeinfo(VisualClues.CenterWL_ROI, ...
	'Center wavelength', '<\lambda> (nm)','lin')


% keep only data in ROI
x_eup= KeepOnlyROI(VisualClues.MaxMinWL(:,:,1),VisualClues.MaxMinWL(:,:,1),WL_range);
x_edown = KeepOnlyROI(VisualClues.MaxMinWL(:,:,2),VisualClues.MaxMinWL(:,:,2),WL_range);

% define common colormap bounds for next plots
[min_eup, max_eup] = bounds(x_eup,'all');
[min_edown, max_edown] = bounds(x_edown,'all');

mmin = min(min_eup, min_edown);
mmax = max(max_eup, max_edown);


axs{6} = nexttile;
plotsomeinfo(x_eup, ...
	'Edges up (LP)', '\lambda_{edge} (nm)','lin', ...
	[mmin mmax])
hold on
plot([35 40 40 45 45 50],[5 5 20 20 5 5], 'k-','linewidth',1.5)
plot([40 40],[20 5], 'r--','linewidth',1.5)


% keep only data in ROI
s_eup = KeepOnlyROI(VisualClues.Steepness(:,:,1),VisualClues.MaxMinWL(:,:,1),WL_range);
s_edown = KeepOnlyROI(VisualClues.Steepness(:,:,2),VisualClues.MaxMinWL(:,:,2),WL_range);
axs{7} = nexttile;
plotsomeinfo(s_eup, ...
	'Steepness (LP)', '\Delta\lambda_{LP} (nm)','lin', [0 3])



axs{8} = nexttile;
plotsomeinfo(x_edown, ...
	'Edges down (SP)', '\lambda_{edge} (nm)','lin', ...
	[mmin mmax])
hold on
plot([50 45 45 40 40 35],[5 5 20 20 5 5], 'k-','linewidth',1.5)
plot([45 45],[20 5], 'r--','linewidth',1.5)


axs{9} = nexttile;
plotsomeinfo(s_edown, ...
	'Steepness (SP)', '\Delta\lambda_{SP} (nm)','lin', [0 3])

sgtitle(filtername)
%% Plot particular T spectra
%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% pp=cell(1,length(axs));
%CREATE FUNCTION DE SELECTION DATA AND PLOT PARTICULAR INFO


%slct_indices = round(ginput(1));


%
slct_indices = [44 31];
% for i=1:length(axs)
%  	axs{i};
% 	hold on
% 	if exist('pp','var') & ~isempty(pp{i})
% 		hold on
% 	pp{i}.XData = slct_indices(1);
% 	pp{i}.YData = slct_indices(2);
% 	else
% 		hold on
% 	pp{i} = plot(axs{i},slct_indices(1),slct_indices(2),'*g');
% 	hold on
% 	end
% end
%
[steepness, LP_edge, SP_edge, dataOI] = find_steepness(VisualClues,this_filter, slct_indices);



% plot example data

figure(43)
plot(this_filter.WL,dataOI)
hold on
plot([LP_edge LP_edge],[0 1],'--g')
plot([SP_edge SP_edge],[0 1],'-.g')

plot([LP_edge - steepness(1) LP_edge - steepness(1)],[0 1],'--r')
plot([SP_edge + steepness(2) SP_edge + steepness(2)],[0 1],'--r')


xlabel('Wavelength (nm)'); ylabel('T');

xlim(WL_range)
xlim([-Inf Inf])



%% Function definitions %%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate transmission spectrum after two filters
function res = getTspectrum(Data, i,j, ROI)
% multiply the two T spectra (now from same filter)
res = Data(i,find(ROI)).*Data(j,find(ROI));
end

% identify type of spectrum obtained with the two filters and analyse its characteristics
function [VisualClues] = identify_spectrum_type(VisualClues, this_filter, spectrum_ij, i, j)

% disable warning if data below MinPeakHeight
warning off signal:findpeaks:largeMinPeakHeight

% use the derivative to identify the steep slopes
[ass, asss] = findpeaks(abs(diff(spectrum_ij)),'MinPeakProminence',0.01,'MinPeakHeight',0.1);

% recover identifiable spectra and FWHM + center WL
VisualClues.Edges(i,j) = length(ass);
if length(ass)==2  % clear bandwidth (2 steep edges)
	if mean(ass)>1e-2 % minimum max transmission
		VisualClues.FWHM(i,j)=abs(diff(this_filter.WL(asss)));
		VisualClues.CenterWL(i,j)=mean(this_filter.WL(asss));
		VisualClues.MaxMinWL(i,j,:)= [min(this_filter.WL(asss)) ...
			max(this_filter.WL(asss))];
				VisualClues.Steepness(i,j,:) = find_steepness(VisualClues, this_filter, [i j]);

		VisualClues.Max(i,j) = mean(spectrum_ij(asss(1):asss(2)));
	end
else

	[m_mn, id_mn] = maxk(spectrum_ij,30);
	id = round(mean(id_mn));


	if length(asss)==1
			VisualClues.Max(i,j) = max(spectrum_ij);

		VisualClues.FWHM(i,j)=fwhm(this_filter.WL,spectrum_ij);
		VisualClues.MaxMinWL(i,j,:)= [this_filter.WL(asss) ...
			this_filter.WL(asss)+VisualClues.FWHM(i,j)];
	end

	if ~isempty(asss)
		VisualClues.FWHM(i,j)=fwhm(this_filter.WL,spectrum_ij);
				VisualClues.Steepness(i,j,:) = find_steepness(VisualClues, this_filter, [i j]);

		if length(asss)>1
			VisualClues.Max(i,j) = mean(spectrum_ij(asss(1):asss(2)));
			VisualClues.MaxMinWL(i,j,:)= [min(this_filter.WL(asss)) ...
				max(this_filter.WL(asss(2)))];
		end

	else

	end
end

%%%%!!!!!
VisualClues.CenterWL(i,j) = min(VisualClues.MaxMinWL(i,j,:))+abs(diff(VisualClues.MaxMinWL(i,j,:)))./2;
end

% find the steepness of the filter's edge
function [steepness, LP_edge, SP_edge, dataOI] = find_steepness(VisualClues, this_filter, slct_indices)


dataOI = this_filter.Data(slct_indices(1),:).*this_filter.Data(slct_indices(2),:);


slope_pos_up = VisualClues.MaxMinWL(slct_indices(2),slct_indices(1),1);
slope_pos_down = VisualClues.MaxMinWL(slct_indices(2),slct_indices(1),2);

% plot([slope_pos_up slope_pos_up],[0 1],'--k')
% plot([slope_pos_down slope_pos_down],[0 1],'--k')

int_threshold = 0.94;
[dsmin,dsmax]=bounds(find(dataOI>=int_threshold));

if isempty(dsmin)
	% if no value above threshold we have a single line
	[dm, dsm]= max(dataOI);
	LP_edge = this_filter.WL(dsm);
	SP_edge = this_filter.WL(dsm);
else
	dm = mean(dataOI([dsmin dsmax]));
	try
	LP_edge = mean(this_filter.WL([dsmin dsmin-1]));
	catch
		LP_edge=[];
	end
	try
	SP_edge = mean(this_filter.WL([dsmax dsmax+1]));
		catch
		SP_edge=[];
	end
end


% plot([LP_edge LP_edge],[0 1],'--g')
% plot([SP_edge SP_edge],[0 1],'-.g')

if ~isempty(SP_edge)

% then look for value near 1e-2 of max on each side
% on the right of the SP
ind_above = find(this_filter.WL>SP_edge);
[~, id_above_sh] = min(abs(dataOI(ind_above)-1e-2.*dm));
id_above = id_above_sh + min(ind_above)-1;
end
if ~isempty(LP_edge)
% on the left of the LP
ind_below = find(this_filter.WL<LP_edge);
[~, id_below] = min(abs(dataOI(ind_below)-1e-2.*dm));
end

% plot(this_filter.WL([id_below id_below]),[0 1],'--r')
% plot(this_filter.WL([id_above id_above]),[0 1],'--r')

if ~isempty(SP_edge) & ~isempty(LP_edge)
% DEF: steepness = ecart en nm entre T = 1 et 1e-2
steepness = [ LP_edge-this_filter.WL(id_below)...
	this_filter.WL(id_above)-SP_edge]; % steepness en nm
else
	steepness=[NaN NaN];
end
% yyaxis right
% semilogy(this_filter.WL,this_filter.Data(slct_indices(1),:).*this_filter.Data(slct_indices(2),:))
% ylim([1e-3 1])
% xlabel('Wavelength (nm)'); ylabel('T');
% 
% xlim(WL_range)
% xlim([-Inf Inf])


end

% show 2D info data
function plotsomeinfo(quantity, atitle, alegend,linorlog,caxisrange)
global half_plot
p=pcolor(0:60,0:60,quantity);
p.EdgeColor='none';
c=colorbar; c.Label.String = alegend; c.Location='westoutside'; c.AxisLocation='in';
c.Label.Rotation=0;
try
	caxis(caxisrange)
catch
	try
	caxis([min(min(quantity)) max(max(quantity))])
	catch 
	end
end
cx=caxis; c.Label.Position = [0.5 (max(max(cx))-min(cx))./2.*1.2 + mean(cx)];
xlabel('Filter 1 angle (°)'); ylabel('Filter 2 angle (°)');
pbaspect([1 1 1])

switch linorlog
	case 'lin'
		set(gca,'ColorScale','lin')
	case 'log'
		set(gca,'ColorScale','log')
	otherwise
end
if half_plot
	box off
	set(gca,'YAxisLocation',"right")
	hold on
	plot([0 60], [0 60],'k-')
	set(gca,'Color','none')
	title(atitle,'Position',[30 35],'Rotation',45,'HorizontalAlignment','center')

else
	title(atitle,'HorizontalAlignment','center')

end
datatip_z2cdata(p)

function datatip_z2cdata(h)
    % h is a graphics object with a default X/Y/Z datatip and a 
    % CData property (e.g. pcolor).  The Z portion of the datatip
    % will be relaced with CData
    % Generate an invisible datatip to ensure that DataTipTemplate is generated
    dt = datatip(h,h.XData(1),h.YData(1),'Visible','off'); 
    % Replace datatip row labeled Z with CData
    idx = strcmpi('Z',{h.DataTipTemplate.DataTipRows.Label});
    newrow = dataTipTextRow('C',h.CData);
    h.DataTipTemplate.DataTipRows(idx) = newrow;
    % Remove invisible datatip
    delete(dt)
end

end

% remove un-interesting data from representation
function Data = KeepOnlyROI(Data,Data_WL,WL_ROI)
global show_full_range
switch show_full_range
	case 0
		upper = max(WL_ROI);
		lower = min(WL_ROI);
		relevant_mask = Data_WL>=upper | Data_WL<=lower;
		relevant_indices = find(relevant_mask);
		Data(relevant_indices)=NaN;
	case 1
		% do nothing
	otherwise
		error('num params')

end


end