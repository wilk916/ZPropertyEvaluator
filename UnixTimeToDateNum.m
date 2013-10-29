function [DataNum] = UnixTimeToDateNum(UnixTime)

% datenum(1970,1,1) == 719529
DataNum = UnixTime/86400000 + 719529;
