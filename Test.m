% Andrew Alan
AddressStr.Street = '4419 Andrew Alan Ln';
AddressStr.ZipCode = 95628;

% Swan Lake
%AddressStr.Street = '9660 Swan Lake Drive';
%AddressStr.ZipCode = 95746;

%PropertyId = 26046443;
PropertyId = GetZPropertyId(AddressStr);

% Property/Zip/City ZEstimate Values
ChartType = 1;

ZData = GetZData(PropertyId);

%UnixTimeToDateNum(UnixTime);

figure(1);
clf;
hold on;

% Property Value Plot.
PropertyData = ZData(1);
PropertyTime = [PropertyData.points(:).x];
PropertyZestimate = [PropertyData.points(:).y];
plot(PropertyTime, PropertyZestimate, 'b');

% Zip-code Value Plot.
ZipCodeData = ZData(2);
ZipCodeTime = [ZipCodeData.points(:).x];
ZipCodeZestimate = [ZipCodeData.points(:).y];
plot(ZipCodeTime, ZipCodeZestimate, 'r');

xlabel('Unix Time (s)');
ylabel('ZEstimate');
legend(PropertyData.name, ZipCodeData.name);

[CommonTimes, CommonPropIdx, CommonZipIdx] = intersect(PropertyTime, ZipCodeTime);

if (~isempty(CommonTimes))
    figure(2);
    clf;
    hold on;

    RelativeZValue = PropertyZestimate(CommonPropIdx) ./ ZipCodeZestimate(CommonZipIdx);
    
    plot(CommonTimes, 100.0 * RelativeZValue, 'g');
    xlabel('Unix Time (s)');
    ylabel('Relative Zestimate (% of ZipCode)');
end
