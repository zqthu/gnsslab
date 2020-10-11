% plot by sp3 file in WGS84 reference system:
% 1. Earth centered earth fixed(ECEF)
% 2. Earth centered inertia (ECI)
% 3. Worldmap
% 4. Skyplot

% ---------------- settings ----------------
% navigation file
sp3_file = './igs21212.sp3';
% order of lagrange polynominal
order = 5;
% sampling intervals (sec)
interval = 30;
% reveiver position of sky plot [latitude, longitude, height]
rec = [39.907500, 116.388056, 6371008.7714]; % Beijing, llh = [39.907500, 116.388056, 6371008.7714]

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
% prn_list = sat2prn(unique(itrf(:,1)));

% -------------- preprocessing --------------
% read navigation file
[sp3_hdr, sp3] = read_sp3(sp3_file);
% select checked satellites
bool_mat = zeros([length(sp3(:,1)),1]);
for i = 1:length(checkbox)
    bool_mat = bool_mat | (sp3(:,1)==prn2sat(char(checkbox(i))));
end
sp3 = sp3(bool_mat,:);
% transform sp3 into itrf
itrf = sp32itrf(sp3, order, interval);


% ---------------- plot ECEF ----------------
if sum(anime) == 0 || anime(1)
    clf(figure(1));
    figure(1);
    plot_orbit(itrf,'ECEF',anime(1));
end

% ---------------- plot ECI ----------------
if sum(anime) == 0 || anime(2)
    % convert xyz to eci_xyz
    Omega_e = 7.292115147 * 1e-5; % (rad/sec) mean earth rotation rate [WGS84]
    pi = 3.1415926535898; % pi
    gpst = cal2gpst(itrf(:, 2:7)); % GPS time
    GAST_week = gpst2gast([sp3_hdr.start_gpst(1),0]); % GAST_week
    psi = -Omega_e * gpst(:,2) - GAST_week; % rotation angle  = -omega_e * t -  GAST_week
    R_z = geo_spinz(psi); % rotation matrix 3x3xn
    itrf_eci = itrf;
    for i = 1:length(itrf_eci(:,1))
        itrf_eci(i,8:10) = (R_z(:,:,i) * itrf_eci(i,8:10).').'; 
    end
    clf(figure(2));
    figure(2);
    plot_orbit(itrf_eci,'ECI',anime(2),1);

    clear Omega_e pi i wgs84_eci GAST_week psi gpst R_z
end

% ---------------- map plot ----------------
if sum(anime) == 0 || anime(3)
    clf(figure(3));
    figure(3);
    plot_map(itrf, anime(3));
end

% ---------------- sky plot ----------------
if sum(anime) == 0 || anime(4)
    clf(figure(4));
    figure(4);
    plot_sky(itrf, rec, anime(4));
end