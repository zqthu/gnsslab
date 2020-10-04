function gmst = mjd2gmst(mjd, sod)
% mjd2gmst: convert Modified Julian Date at 0hr (MJD0) & seconds of day(SOD)
%           to Greenwich Mean Sidereal Time(GMST)
%
% Syntax: gmst = mjd2gmst(mjd)
%

if nargin < 2
    sod = vpa(mjd, 15) * 86400;
    mjd = int64(mjd);
end

h = sod / 86400; % hours of day
t = mjd / 36525; % number of centuries since J2000

% Calculate GMST in hours (0h to 24h) ... then convert to degrees
GMST = mod(6.697374558 + 0.06570982441908*mjd  + 1.00273790935*h + ...
    0.000026*(t^2),24)*15; 

end