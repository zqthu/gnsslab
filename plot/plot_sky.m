function plot_sky(stxyz, rec, anime)
%plot_map - plot satellite orbits and position in a world map
%
% Syntax: plot_map(stxyz, rec)
% Syntax: plot_map(stxyz, anime)
%
% INPUT:
%   stxyz    - satellite positions [sat, year, month, day, hour, minute, second, x, y, z]
%   rec      - receiver point in llh [latitude, longitude, height]
%
%   OPTIONAL:
%   anime    - refresh the plot [default 1 for refresh] 
%
% OUTPUT:
%   None
%
    
if nargin < 3
    anime = 1;
end

% reveiver position
origin = llh2xyz(rec);
% get satellite list
sat_list = unique(stxyz(:,1));

% calculate NEU to origin
neu = xyz2neu(stxyz(:,8:10),origin);
% elevation and azimuth
project = sqrt(neu(:,1).*neu(:,1) + neu(:,2).*neu(:,2));
ele_attach = atand(neu(:,3)./project(:)); % neu -> elc (rad)
azi_attach = atan2(neu(:,2), neu(:,1)); % azi = arctan(E/N) (rad)
azi_attach = mod(-azi_attach + pi/4, 2*pi);

% attach to stxyz
stxyz = [stxyz ele_attach azi_attach];

% start plot
pax = polaraxes;
for i = 1:length(sat_list)
    bool_index = (stxyz(:,1)==sat_list(i));
    refresh_period(i,:) = [find(bool_index,1,'first'), find(bool_index,1,'last')];
    
    points = stxyz(bool_index,:); % points of sat
    ele = points(:,11);
    azi = points(:,12);
    polarscatter(azi, ele, 2, 'o','filled')
    hold on;
end
% prepare for refresh
if anime
    index = refresh_period(:,1);
    dot = polarscatter(stxyz(index,12), stxyz(index,11), 40, 'r','o','filled');
    t = text(2*pi/3,-30,'Time');
end

% settings
pax.ThetaDir = 'clockwise';
pax.RDir = 'reverse';
pax.RLim = [0,90];
pax.RTick = 0:15:90;
pax.ThetaZeroLocation = 'top';

% annoation
if anime
    legend([string(sat2prn(sat_list)).', 'Satellite']);
else
    legend(string(sat2prn(sat_list)).');
end
title_str = 'SkyPlot [' + string(rec(1)) + 'N ' + string(rec(2)) + 'E]';
title(title_str);

% refresh
if anime
    while true
        dot.RData = stxyz(index,11);
        dot.ThetaData = stxyz(index,12);
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