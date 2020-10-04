function plot_map(stxyz,  anime)
%plot_map - plot satellite orbits and position in a world map
%
% Syntax: plot_map(stxyz)
% Syntax: plot_map(stxyz, anime)
%
% INPUT:
%   stxyz    - satellite positions [sat, year, month, day, hour, minute, second, x, y, z]
%
%   OPTIONAL:
%   anime    - refresh the plot [default 1 for refresh] 
%
% OUTPUT:
%   None
%

if nargin < 2
    anime = 1;
end

% get satellite list
sat_list = unique(stxyz(:,1));

% constant
pi = 3.1415926535898; % pi
% convert xyz to llh(degree)
stxyz(:,8:10) = xyz2llr(stxyz(:,8:10)); % xyz(m) to llh(rad)
stxyz(:,8:10) = rad2deg(stxyz(:,8:10));% llh(rad) to llh(degree)

% start plot
geobasemap('grayland');
geolimits([-90 90],[-180 180]);

for i = 1:length(sat_list)
    bool_index = (stxyz(:,1)==sat_list(i));
    refresh_period(i,:) = [find(bool_index,1,'first'), find(bool_index,1,'last')];
    
    points = stxyz(bool_index,:); % points of sat
    x = points(:,8);
    y = points(:,9);
    geoscatter(x, y, 2, 'o', 'filled');
    hold on;
end
% prepare for refresh
if anime
    index = refresh_period(:,1);
    dot = geoscatter(stxyz(index,8), stxyz(index,9), 40, 'r','o','filled');
    t = text(-65,160,'Time');
end

% annoation
if anime
    legend([string(sat2prn(sat_list)).', 'Satellite']);
else
    legend(string(sat2prn(sat_list)).');
end
title('WorldMap Plot');

% refresh
if anime
    while true
        dot.LatitudeData = stxyz(index,8);
        dot.LongitudeData = stxyz(index,9);
        t.String = ["Time ",join(string(stxyz(index(1),2:7)),["/","/"," ",":",":"])];
        index = index + 10;
        pause(0.1);
        if prod(index > refresh_period(:,2))
            index = refresh_period(:,1);
        end
    end
end

% remove constant pi from workspace
clear pi;

end