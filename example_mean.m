clc
clear


% addpath('~/script/tools/matFVCOM')
% addpath('~/script/tools/ndbc')
addpath('/Users/siqili/Dropbox/tools/matFVCOM')
addpath('/Users/siqili/Dropbox/tools/ndbc')



ndbc_download_historical_stdmet('./data/', '44013');


buoy = ndbc_read_stdmet('./data/' );

time0 = buoy.time;
wspd0 = buoy.wspd;

tlim = [2000 2002];

[hour, wspd_hour] = data_mean(time0, wspd0, 'hourly', tlim);
[day, wspd_day] = data_mean(time0, wspd0, 'daily', tlim);
[month, wspd_month] = data_mean(time0, wspd0, 'monthly', tlim);
[year, wspd_year] = data_mean(time0, wspd0, 'annual', tlim);
[season, wspd_season] = data_mean(time0, wspd0, 'seasonal', tlim);


figure
hold on
plot(time0, wspd0, '-', 'color', [.8 .8 .8])
% plot(hour, wspd_hour, '-', 'color', 'g')
plot(day, wspd_day, '-', 'color', 'r')
plot(month, wspd_month, '-', 'color', 'b')
% plot(year, wspd_year, '-', 'color', 'k')
plot(season(:,1), wspd_season(:,1), '-', 'color', 'k')
plot(season(:,2), wspd_season(:,2), '-', 'color', 'k')
plot(season(:,3), wspd_season(:,3), '-', 'color', 'k')
plot(season(:,4), wspd_season(:,4), '-', 'color', 'k')



xlim(datenum([tlim(1) tlim(end)+1], 1,1,0,0,0))