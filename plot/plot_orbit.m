function plot_orbit(stxyz, tit, anime, rotation)
%plot_orbit - plot satellite orbits and position
%
% Syntax: plot_orbit(stxyz)
% Syntax: plot_orbit(stxyz, tit)
% Syntax: plot_orbit(stxyz, tit, anime)
%
% INPUT:
%   stxyz    - satellite positions [sat, year, month, day, hour, minute, second, x, y, z]
%
%   OPTIONAL:
%   title    - title of the plot
%   anime    - refresh the plot [default 1 for refresh] 
%   rotation - rotation of earth [default 0 for not rotating, only functions when anime==1]
%
% OUTPUT:
%   None
%

if nargin < 2
    t = 0;
end
if nargin < 3
    anime = 1;
end
if nargin < 4
    rotation = 0;
end
% constant
Omega_e = 7.292115147 * 1e-5; % (rad/sec) mean earth rotation rate [WGS84]

% figure
% figure(1)
% get satellite list
sat_list = unique(stxyz(:,1));
% draw earth
ax = axes;
% plot_earth;

Re = 6371008.7714 ;
[xe, ye, ze] = sphere(30); 
xe = xe * Re;
ye = ye * Re;
ze = ze * Re;
earth = mesh(xe,ye,ze); %»­µ¥Î»ÇòÃæ
hold on;

% start plot
refresh_period = zeros([length(sat_list), 2]); % [start end] index of sat i in stxyz
for i = 1:length(sat_list)
    bool_index = (stxyz(:,1)==sat_list(i));
    refresh_period(i,:) = [find(bool_index,1,'first'), find(bool_index,1,'last')];
    
    points = stxyz(bool_index,:); % points of sat
    x = points(:,8);
    y = points(:,9);
    z = points(:,10);
    plot3(x,y,z,'LineWidth',1);
    hold on;
end
% prepare for refresh
if anime
    index = refresh_period(:,1);
    dot = scatter3(stxyz(index,8), stxyz(index,9), stxyz(index,10), 40, 'r','o','filled');
    t = text(3.5e7,-2.5e7,-2.5e7,'Time');
end

% settings
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.ZGrid = 'on';

% annoation
if tit ~= 0
    title(tit);
end
if anime
    legend(['Earth', string(sat2prn(sat_list)).', 'Satellite']);
else
    legend(['Earth', string(sat2prn(sat_list)).']);
end
xlabel('x');
ylabel('y');
zlabel('z');
axis([-5e7 5e7 -5e7 5e7 -5e7 5e7]);
axis equal;

% refresh
if anime
    skip = 10;
    delta_gpss = cal2gpst(stxyz(index(1)+skip,2:7)) - cal2gpst(stxyz(index(1),2:7));
    delta_gpss = delta_gpss(2);
    Rz = geo_spinz(-delta_gpss * Omega_e); % rotation of earth for every delta_gpss
    while true
        dot.XData = stxyz(index,8);
        dot.YData = stxyz(index,9);
        dot.ZData = stxyz(index,10);
        t.String = ["Time ",join(string(stxyz(index(1),2:7)),["/","/"," ",":",":"])];
        if rotation
            xe = Rz(1,1) * xe + Rz(1,2) * ye + Rz(1,3) * ze;
            ye = Rz(2,1) * xe + Rz(2,2) * ye + Rz(2,3) * ze;
            ze = Rz(3,1) * xe + Rz(3,2) * ye + Rz(3,3) * ze;
            earth.XData = xe;
            earth.YData = ye;
            earth.ZData = ze;
        end
        index = index + skip;
        pause(0.1);
        if prod(index > refresh_period(:,2))
            index = refresh_period(:,1);
        end
    end
end

end