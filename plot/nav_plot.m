% plot by navigation file in WGS84 reference system:
% 1. Earth centered earth fixed(ECEF)
% 2. Earth centered inertia (ECI)
% 3. Worldmap
% 4. Skyplot

% ---------------- settings ----------------
% navigation file
nav_file = './brdc2450.20n';
% sampling intervals (sec)
interval = 30;
% reveiver position of sky plot [latitude, longitude, height]
rec = [39.907500, 116.388056, 0]; % Beijing, llh = [39.907500, 116.388056, 0]

% animation checkbox
% 0 for static, while 1 for animation
anime = [0,0,0,0]; % ECEF orbit, ECI orbit, worldmap plot, sky plot

% satellite checkbox
% checkbox = [ "G01", "G02", "G03", "G04", "G05", "G06", "G07", "G08", "G09", "G10",...
%              "G11", "G12", "G13", "G15", "G16", "G17", "G18", "G19", "G20",...
%              "G21", "G22", "G23", "G24", "G25", "G26", "G27", "G28", "G29", "G30",...
%              "G31", "G32"];
checkbox = ["G08","G10", "G18", "G24","G25", "G32"]; % Slots: C3, E2, D3, A1, B2, F1

% Note: to get satellite PRN list, run
% prn_list = sat2prn(unique(wgs84(:,1)));

% -------------- preprocessing --------------
% read navigation file
[hdr, nav] = read_rinex_nav(nav_file);
% select checked satellites
bool_mat = zeros([length(nav(:,1)),1]);
for i = 1:length(checkbox)
    bool_mat = bool_mat | (nav(:,1)==prn2sat(char(checkbox(i))));
end
nav = nav(bool_mat,:);
% transform nav into wgs84
wgs84 = nav2wgs84(nav,interval);

% ---------------- plot ECEF ----------------
figure(1);
plot_orbit(wgs84,'ECEF',anime(1));

% ---------------- plot ECI ----------------
% convert xyz to eci_xyz
Omega_e = 7.292115147 * 1e-5; % (rad/sec) mean earth rotation rate [WGS84]
pi = 3.1415926535898; % pi
gpst = cal2gpst(wgs84(:, 2:7)); % GPS time
GAST_week = gpst2gast([hdr.gpst(1),0]); % GAST_week
psi = -Omega_e * gpst(:,2) - GAST_week; % rotation angle  = -omega_e * t -  GAST_week
R_z = geo_spinz(psi); % rotation matrix 3x3xn
wgs84_eci = wgs84;
for i = 1:length(wgs84_eci(:,1))
    wgs84_eci(i,8:10) = (R_z(:,:,i) * wgs84_eci(i,8:10).').'; 
end
figure(2);
plot_orbit(wgs84_eci,'ECI',anime(2));

clear Omega_e pi i wgs84_eci GAST_week psi gpst R_z

% ---------------- map plot ----------------
% wgs84 = nav2wgs84(nav,30); % more samples
figure(3);
plot_map(wgs84, anime(3));

% ---------------- sky plot ----------------
figure(4);
plot_sky(wgs84, rec, anime(4));