function gast = gpst2gast(gpst)
% gpst2gast - calculate Greenwich Apparent Sidereal Time (GAST) at GPS time 
%
% Syntax: gast = gpst2gast(gpst)
% INPUT
%   gpst - GPS time (nx2)
%
% OUTPUT
%   gast - Greenwich Apparent Sidereal Time (GAST) (nx1) (rad)
%
% See: https://www.mathworks.com/matlabcentral/fileexchange/28232-convert-julian-date-to-greenwich-apparent-sidereal-time

mjd = gpst2mjd(gpst);
jd = 2400000.5 + mjd(:,1) + mjd(:,2);
%Find the Julian Date of the previous midnight, JD0
jd0 = NaN(size(jd));
jd_min = floor(jd)-.5;
jd_max = floor(jd)+.5;
jd0(jd > jd_min) = jd_min(jd > jd_min);
jd0(jd > jd_max) = jd_max(jd > jd_max);
H = (jd-jd0).*24;       %Time in hours past previous midnight
D = jd - 2451545.0;     %Compute the number of days since J2000
D0 = jd0 - 2451545.0;   %Compute the number of days since J2000
T = D./36525;           %Compute the number of centuries since J2000
%Calculate GMST in hours (0h to 24h) ... then convert to degrees
gmst = mod(6.697374558 + 0.06570982441908.*D0  + 1.00273790935.*H + ...
    0.000026.*(T.^2),24).*15;

%Mean obliquity of the ecliptic (EPSILONm)
% see http://www.cdeagle.com/ccnum/pdf/demogast.pdf equation 3
% also see Vallado, Fundamentals of Astrodynamics and Applications, second edition.
%pg. 214 EQ 3-53
EPSILONm = 23.439291-0.0130111.*T - 1.64E-07.*(T.^2) + 5.04E-07.*(T.^3);
%Nutations in obliquity and longitude (degrees)
% see http://www.cdeagle.com/ccnum/pdf/demogast.pdf equation 4
L = 280.4665 + 36000.7698.*T;
dL = 218.3165 + 481267.8813.*T;
OMEGA = 125.04452 - 1934.136261.*T;
%Calculate nutations using the following two equations:
% see http://www.cdeagle.com/ccnum/pdf/demogast.pdf equation 5
dPSI = -17.20.*sind(OMEGA) - 1.32.*sind(2.*L) - .23.*sind(2.*dL) ...
    + .21.*sind(2.*OMEGA);
dEPSILON = 9.20.*cosd(OMEGA) + .57.*cosd(2.*L) + .10.*cosd(2.*dL) - ...
    .09.*cosd(2.*OMEGA);
%Convert the units from arc-seconds to degrees
dPSI = dPSI.*(1/3600);
dEPSILON = dEPSILON.*(1/3600);
%(GAST) Greenwhich apparent sidereal time expression in degrees
% see http://www.cdeagle.com/ccnum/pdf/demogast.pdf equation 1
gast = mod(gmst + dPSI.*cosd(EPSILONm+dEPSILON),360)*pi/180;

end