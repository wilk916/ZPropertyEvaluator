function [ZData] = GetZData(PropertyId, ChartType)

if (~exist('ChartType', 'var'))
    ChartType = 1;
end

URL = GenerateZUrl(PropertyId, ChartType);

JsonData = urlread(URL);
ZData = loadjson(JsonData);

%%-----------------------------------------------------------------------------
% Generate Zillow URL.
function [URL] = GenerateZUrl(PropertyId, ChartType)

URL = [ ...
    'http://www.zillow.com/ajax/homedetail/HomeValueChartData.htm?mt=' ...
    int2str(ChartType) ...
    '&zpid=' ...
    int2str(PropertyId) ...
    '&format=json'];
