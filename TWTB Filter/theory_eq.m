function [funcmid,funcLP, funcSP] = theory_eq
    % equation for wl as a function of theta
    %
    % lam = lam0 * sqrt( 1 - (sin(theta)./n_eff).^2 )

    %% 1. Find n_eff
    [rawdata, rawWL, AOI] = init;


    function r = range(data, dim)
        % Fonction personnalisée pour calculer l'étendue des données
        if nargin < 2
            dim = 1;  % Par défaut, la dimension est la première dimension non singleton
        end
        r = max(data, [], dim) - min(data, [], dim);
    end

    rawdata(rawdata<0.7) = NaN; % fill with NaN for easy identification

    % Initialisation des tableaux
    CenterWL = NaN(1, size(rawdata, 1));
    LPWL = NaN(1, size(rawdata, 1));
    SPWL = NaN(1, size(rawdata, 1));

    % foreach line(spectrum) find extrema of T~1 (T>1e-2) and center WL
    for i=1:size(rawdata,1)
        ind_first = find(~isnan(rawdata(i,:)), 1, 'first');
        ind_last = find(~isnan(rawdata(i,:)), 1, 'last');
        
        if ~isempty(ind_first) && ~isempty(ind_last)
            CenterWL(i) = rawWL(ind_first) + range(rawWL(ind_first:ind_last)) / 2;
            LPWL(i) = rawWL(ind_first);
            SPWL(i) = rawWL(ind_last);
        end
    end

    % fit to get n_eff
    [xData, yData] = prepareCurveData(AOI, CenterWL);
    [xDataLP, yDataLP] = prepareCurveData(AOI, LPWL);
    [xDataSP, yDataSP] = prepareCurveData(AOI, SPWL);

    % Set up fittype and options.
    ft = fittype('x0.*sqrt(1 - (sin(deg2rad(x))./n_eff).^2)', 'independent', 'x', 'dependent', 'y');
    opts = fitoptions('Method', 'NonlinearLeastSquares');
    opts.Display = 'Off';
    opts.StartPoint = [2 565];

    % Fit model to data.
    [fitresult, gof] = fit(xData, yData, ft, opts);
    [fitresultLP, gofLP] = fit(xDataLP, yDataLP, ft, opts);
    [fitresultSP, gofSP] = fit(xDataSP, yDataSP, ft, opts);

    funcmid = fitresult;
    funcLP = fitresultLP;
    funcSP = fitresultSP;
end
