function [PropertyId] = GetZPropertyId(AddressStr)

% Generate Zillow URL.
URL = GenerateZPropertySearchUrl(AddressStr);

XmlData = urlread(URL);

ZpidTagIndex = strfind(XmlData, 'zpid');

if (length(ZpidTagIndex) > 1)
    ZpidString = XmlData((ZpidTagIndex(1)+5):(ZpidTagIndex(2)-3));
    PropertyId = str2num(ZpidString);
else
    disp('ERROR: Could not find ZPID.');
    PropertyId = 0;
end

%%-----------------------------------------------------------------------------
% Generate Zillow URL.
function [URL] = GenerateZPropertySearchUrl(AddressStruct)

ZWSID = 'getyourid';

if (strcmp(ZWSID, 'getyourid'))
    error('No ZWS ID found.  You must register for a ZWS-ID.');
end

% Format...
% http://www.zillow.com/webservice/GetSearchResults.htm?zws-id=<ZWSID>&address=2
% 114+Bigelow+Ave&citystatezip=Seattle%2C+WA
URL = [ ...
    'http://www.zillow.com/webservice/GetSearchResults.htm' ...
    '?zws-id=' ZWSID ...
    '&address=' AddressStruct.Street ...
    '&citystatezip=' ...
        int2str(AddressStruct.ZipCode)];

SpaceIdx = strfind(URL, ' ');
URL(SpaceIdx) = '+';
