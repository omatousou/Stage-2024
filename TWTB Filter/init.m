function [rawdata, rawWL, AOI] = init()
    load("DataL057B.mat")

    % get data
    rawdata = SemrockFilters.TBP0156114x25x36.Data;
    rawWL = SemrockFilters.TBP0156114x25x36.WL;
    AOI = SemrockFilters.TBP0156114x25x36.AOI;
end