%% Theory multiple filters
%
% DONE
% 1. Find n_eff for the filter of interest for centerWL, shortWL, longWL
%
% TODO
% 2. Use theoretical expression to simulate the transmission of stacked
% filters at different AOIs
% 3. Program to input wavelength and bandwidth which outputs two angles


% equation for wl as a function of theta
%
% lam = lam0 * sqrt( 1 - (sin(theta)./n_eff).^2 )

function r = range(data, dim)
    % Fonction personnalisée pour calculer l'étendue des données
    if nargin < 2
        dim = 1;  % Par défaut, la dimension est la première dimension non singleton
    end
    r = max(data, [], dim) - min(data, [], dim);
end


%% 1. Find n_eff

load("DataL057B.mat")

% get data
rawdata = SemrockFilters.TBP0156114x25x36.Data;
rawWL = SemrockFilters.TBP0156114x25x36.WL;
AOI = SemrockFilters.TBP0156114x25x36.AOI;
figure("Name",'figure1')


%
% imshow(rawdata, 'XData', rawWL, 'YData', AOI );
% h = gca;
% h.Visible = 'On';
% ylabel('AOI (°)');
% xlabel('WL (nm)');
% axis("square");

rawdata(rawdata<1e-2) = NaN; % fill with NaN for easy identification
 
% foreach line(spectrum) find extrema of T~1 (T>1e-2) and center WL
for i=1:size(rawdata,1)
	ind_first = find(~isnan(rawdata(i,:)),1,'first');
	ind_last = find(~isnan(rawdata(i,:)),1,'last');
	CenterWL(i) = rawWL(ind_first) + range(rawWL(ind_first:ind_last))./2;
	LPWL(i) = rawWL(ind_first);
	SPWL(i) = rawWL(ind_last);
end

% fit to get n_eff
[xData, yData] = prepareCurveData( AOI, CenterWL );
[xDataLP, yDataLP] = prepareCurveData( AOI, LPWL );
[xDataSP, yDataSP] = prepareCurveData( AOI, SPWL );

% Set up fittype and options.
ft = fittype( 'x0.*sqrt(1 - (sin(deg2rad(x))./n_eff).^2)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [2 565];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
[fitresultLP, gofLP] = fit( xDataLP, yDataLP, ft, opts );
[fitresultSP, gofSP] = fit( xDataSP, yDataSP, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
hold on
h = plot( fitresultSP, xDataSP, yDataSP );
h = plot( fitresultLP, xDataLP, yDataLP );
legend( 'CenterWL vs. AOI', sprintf('\\lambda_0 = %.2f nm; n_{eff} = %.3f',fitresult.x0,fitresult.n_eff), ...
	'SPWL vs. AOI',sprintf('\\lambda_0^{SP} = %.2f nm; n_{eff}^{SP} = %.3f',fitresultSP.x0,fitresultSP.n_eff), ...
	'LPWL vs. AOI',sprintf('\\lambda_0^{LP} = %.2f nm; n_{eff}^{LP} = %.3f',fitresultLP.x0,fitresultLP.n_eff), 'Location', 'NorthEast', 'Interpreter', 'tex' );
% Label axes
xlabel('AOI (°)');
ylabel('CenterWL (nm)');
grid on
drawnow
