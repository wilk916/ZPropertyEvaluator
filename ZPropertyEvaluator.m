function [] = ZPropertyEvaluator(AddressStr, AskingPrice)
% [] = ZPropertyEvaluator(AddressStr, AskingPrice)
%
% Description:
%   This function performs a simple pricing report of a rental property using
%   Z-Estimate data published on the Zillow API.
%
% Inputs:
%   AddressStr - A data structure containing the address info with the following
%   fields
%     'Street' - A character string with the street address.
%     'ZipCode' - The zip code.
%   AskingPrice - The asking price. 
%
% Example Usage:
%
%   AddressStr.Street = '4419 Andrew Alan Ln';
%   AddressStr.ZipCode = 95628;
%   ZPropertyEvaluator(AddressStr, 150000);
%

format short;

% Property ID for accessing ZEstimate values.
PropertyId = GetZPropertyId(AddressStr);

% Property/Zip/City ZEstimate Values
ChartType = 1;

ZData = GetZData(PropertyId, ChartType);

PropertyData = ZData(1);
PropertyTime = [PropertyData.points(:).x];
PropertyTime = ConvertAndRoundZtimes(PropertyTime);
PropertyZestimate = [PropertyData.points(:).y];

ZipCodeData = ZData(2);
ZipCodeTime = [ZipCodeData.points(:).x];
ZipCodeTime = ConvertAndRoundZtimes(ZipCodeTime);
ZipCodeZestimate = [ZipCodeData.points(:).y];

[CommonTimes, CommonPropIdx, CommonZipIdx] = intersect(PropertyTime, ZipCodeTime);

if (~isempty(CommonTimes))
    RelativeZValue = PropertyZestimate(CommonPropIdx) ./ ZipCodeZestimate(CommonZipIdx);

    %hist(RelativeZValue);
    %plot(CommonTimes, 100.0 * RelativeZValue, 'g');
    %xlabel('Unix Time (s)');
    %ylabel('Relative Zestimate (% of ZipCode)');

    MeanRelativeValue = mean(RelativeZValue);
    StdDevRelativeValue = sqrt(var(RelativeZValue));

    disp(['== Z-Property Evaluator ==']);
    disp(['Address = ' AddressStr.Street ' / AskingPrice = $' num2str(AskingPrice)]);
    disp(['  Mean Relative Value = ' num2str(100*MeanRelativeValue) '%']);
    disp(['  StdDev Relative Value = ' num2str(100*StdDevRelativeValue) '%']);

    CurrentZipCodeZestimate = ZipCodeZestimate(end);
    CurrentMeanRelativeValueZestimate = MeanRelativeValue * CurrentZipCodeZestimate;

    RelativePrice = AskingPrice / CurrentZipCodeZestimate;
    %NSigma = abs(RelativePrice - MeanRelativeValue) / StdDevRelativeValue;
    PriceDifference = AskingPrice - CurrentMeanRelativeValueZestimate;
    ValueString = 'underpriced';
    if (PriceDifference > 0)
        ValueString = 'overpriced';
    end
    disp([ ...
        '  Property is ' ValueString ' by $' num2str(abs(PriceDifference)) ...
        ' (' num2str(100 * PriceDifference / CurrentMeanRelativeValueZestimate) '%)']);

end
