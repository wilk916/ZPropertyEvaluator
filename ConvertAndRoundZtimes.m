function [ConvertedDataNumbers] = ConvertAndRoundZtimes(Ztimes)

DateStrings = datestr(UnixTimeToDateNum(Ztimes));

% Set the day number to 00
DateStrings(:, 1) = '0';
DateStrings(:, 2) = '0';

% Set the hour number to 00
DateStrings(:, 13) = '0';
DateStrings(:, 14) = '0';

ConvertedDataNumbers = datenum(DateStrings);
