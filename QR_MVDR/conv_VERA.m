function conv_VERA(rcvdata)
% clear all
% LoadData
clc
close all
%% DEFINE ARRAY
N_elements = 64;           % number of antenna elements
c = 1540;                  % speed of ultrasound wave in soft tissue
f0 = 2.976e6;              % central frequency
fs = 4*f0;                 % sampling frequency
Ts = 1/fs;                 % sampling period
lambda = c/f0;             % wavelength
d = 0.30/1000;             % center to center of adjacent elements [m]
focus = [0 0 60]/1000;
z_focus = 60/1000;
f1 = 2e6;
f2 = 4e6;
Nd = (N_elements - 1)/2;
checkGaussDist = 1;         % Check if the rf data amplitudes are gaussian distributed
apodTx = 0;
impulse_response=sin(2*pi*f0*(0:1/fs:2/f0));%gauspuls(t_ir,f0,Bw);
impulse_response = impulse_response.*hanning(max(size(impulse_response)))';
excitation=sin(2*pi*f0*(0:1/fs:2/f0));
%% DEFINE APODIZATION FOR THE EMIT APERTURE 
switch apodTx
    case 0
        apo_emit = ones(1,N_elements);   % Rectangular apodization
    case 1
        apo_emit = kaiser(N_elements,100)'; % Hanning apodization on the emit-apperture
    case 2
        apo_emit = tukeywin(N_elements, 0.5)'; % Cosine-tapered apodization
    case 3
        windowww = hanning(N_elements);
        apo_emit = windowww';  
end
figure(8)
subplot(211)
stem(apo_emit);
title('Transmit apodization');
xlabel('Element index');
ylabel('Element amplitude weighting');
axis tight
ylim([0 1]);
%%  DEFINE IMAGING SECTOR 
sector=60 * pi/180;                             % Size of image sector [rad]
%% DEFINE SPATIAL SAMPLING DENSITY 
aTx = (N_elements - 1)*d;                     % Width of physical aperture
dThetaRayleigh = lambda/aTx;                  % Rayleigh resolution (in radians)
dThetaDesired=1*(pi/180);                     %lateral resolution=1 degree
N_lines = round(sector/dThetaDesired)+1; % Number of scan lines in image
d_theta_emit = sector/(N_lines-1);       % Increment in emit angle for 90 deg. image
d_theta_receive = d_theta_emit;
%% INITIALIZE SIMULATION 
rf_data=zeros(3570,8,61);          % Preallocating storage for image data
times = zeros(1, N_lines);              % Preallocating storage for times data
theta_emit = -sector/2;                 % Start angle for transmit aperture
theta_receive = theta_emit;             % Start angle for receive aperture
theta_start = theta_emit; 
ppp=zeros(1,61);
%load rfdata_cyst;
sln = 61;
%% Start scan loop
ffff=zeros(1534,61);
for scan = 1:1:N_lines 
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % receiver zones
      rec_zone_start = 1/1000;           %depth where dyn receive focusing starts
      rec_zone_size = 1/1000;            %axial resolution
      rec_zone_stop = ((1/1000)- 1/1000)+6/100;%((t1*c/2)- 1.2/1000)+7.872/100;     %depth where dyn receive focusing stops
      rec_focal_zones_center=[rec_zone_start:rec_zone_size:rec_zone_stop]';
      
      rec_focal_zones=rec_focal_zones_center-0.5*rec_zone_size;
      Nfr=max(size(rec_focal_zones));
      
      pp=1;
 %% set the focus for this direction

% v = rcvdata(:,:,sln,1);
v=rcvdata(1+((scan-1)*(1536*1)):scan*(1536*1),:);
sln = sln -1;
        [N M]=size(v);
     N
    time_stop=N*Ts;
%---------calculating no of samples for each r value by eqn->prp=2r/c;samples=prp/Ts-------%

for p=rec_zone_start:rec_zone_size:rec_zone_stop
    prp(pp)=2*p/c;
    no_sam(pp)=round(prp(pp)/Ts);
    pp=pp+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FAR FIELD 
no_sam(pp) = max(size(v)) - 2;%round(prp(pp)/Ts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time(Nfr,N_elements)=0;

%%---------------------DELAY CALCULATION AND APODIZATION-----------------------------------%%
  
%----Coarse delay-------%

Fo=1;        %Reprsents F_resol->dyn receive points in a scan line
l=0;         %pointer to new position while circular buffering
for F_resol=rec_zone_start:rec_zone_size:rec_zone_stop
for i0=1:N_elements
        angle=theta_emit;
        F=F_resol;
        aa=(Nd*d/F)^2;
        bb=2*Nd*d*sin(angle)/F;
        cc=((i0-1-Nd)*d/F)^2;
        dd=2*(i0-1-Nd)*d*sin(angle)/F;
        tt=(F/c)*((sqrt(1+aa+bb))-(sqrt(1+cc-dd)));
        time(Fo,i0)=tt*fs;   %time delays
end   
Fo=Fo+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FAR FIELD DELAY CALCULATION
for far_i = 1 : 1 : N_elements 
    radian = pi/180*angle;
    far_delay = far_i * d * sin(radian)/c * fs;
    time(Fo,far_i) = far_delay;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for Foi=1:Nfr+1
for j=1:N_elements
    r_time(Foi,j)= fix(time(Foi,j));%rounded time delay values
end
end

offset = 0;%-1*max(max((r_time)));%(better offset,less noise)
v1=v';

input=zeros(N_elements,1298);
input_a(Nfr,:)=0;
a_apo=zeros(32,10);


%------------ADDING DELAYS--coarse and fine to each transducer echo--------------------- 
temp_a_1win = zeros(32,9000);
q=1;
for dyn=1:Nfr + 1  %for each point in scan line
    if dyn==1
        num1=0;
        num2=no_sam(dyn);
    else
    num1=no_sam(dyn-1);
    num2=no_sam(dyn);
    end
 num_diff(dyn)=num2-num1;
 coeff=0;
 p=num_diff(dyn);
 sum1 = zeros(1,63);
 a=zeros(N_elements,1);
  
for i=1:N_elements %for each transducer element
%    v2(i,1:num_diff(dyn))=v1(i,num1+1:num2);
    pos=abs(r_time(dyn,i))+ offset+1;
    if (num2 + pos) > max(size(v1))
        nval = (num2+pos)-(max(size(v1)));
        v2(i,1:num_diff(dyn)-nval)=v1(i, pos + num1+1:num2 + pos - nval);
    else
        v2(i,1:num_diff(dyn))=v1(i, pos + num1+1:num2 + pos);
    end

input(i,1:num_diff(dyn)) = v2(i,1:num_diff(dyn));

l = 0;
pos = 1;
%%------------fractional delay(MMSE filter)------------------------------------
    del=time(dyn,i);
    del_round=fix(del);
    del_frac=del-del_round;     %taking fractional part of time delays
    
    %calculating mmse filter coefficients
    w=pi*(f2-f1)/fs;w1=pi*(f2+f1)/fs;w3=w*del_frac;w4=w1*del_frac;
    r=[1 cos(w1)*sin(w)/w;cos(w1)*sin(w)/w 1];
    coeff=inv(r)*[(cos(w4).*sin(w3+eps))./(w3+eps);(cos(w1-w4).*sin(w-w3+eps))./(w-w3+eps)];%filter coefficient 
    c1=coeff(1,1);
    c2=coeff(2,1);
    a(i,1)=input(i,1) * c1 * apo_emit(i);
    a_1win(i,1) = a(i,1);
    %a(1,1)=input(1,1);
    for k=2:1:num_diff(dyn) 
        a(i,k)=c1*input(i,k)+c2*input(i,k-1);%interpolation(filter coefficients multiplied with samples delayed by coarse delay)
        a_1win(i,k)=a(i,k)*apo_emit(i);      %ONE WINDOW APODIZATION
    end
end 
%%-------------------------------------------------------------------------------------------------%%
 
%%--------------------------------SUMMER UNIT------------------------------------------%%
  size_val = size(a_1win);
  if size_val(1,2) >= 64
  sum1(1:max(size(a_1win)))=sum(a_1win); % 11 is the maximum number of samples from each dyn recieve foci
  else
  sum1(1:min(size(a_1win)))=sum(a_1win); % 11 is the maximum number of samples from each dyn recieve foci      
  end
%  sum1(1:11)=sum(a_1win);
  input_a(dyn,1:num_diff(dyn))=sum1(1:num_diff(dyn)); 
  bf(q:q+p-1)=input_a(dyn,1:num_diff(dyn));% collecting beamformed output of all points in a scan line 
  q=q+p;
end
bf_t=bf'; %beamformed output from one scan line
ffff(:,scan)=bf_t;
% ppp(scan)=bf_t'*bf_t;
%%------------------------------------------BEAMFORMING for one scan line OVER-------------------------------------------------------------------------%%
    
%-------------------back end processing(from mycyst.m)------------------------------

% Store the result
    image_data(1:max(size(bf_t)), scan)=bf_t;
 %   times(scan) = t1;
    
    % Increment emit angle
    theta_emit = theta_emit + d_theta_emit;
    theta_receive = theta_emit;
    
    % Update waitbar
   % waitbar(scan/N_lines, h_wb);
end    
%scan_line loop ends
theta_end = theta_receive-d_theta_emit;
% power=10*log10(ppp);
%% ADD TIMECORRECTION
min_sample=round(min(times)*fs);
max_sample=round(max(times)*fs);
[n,m]=size(image_data);
image_data2=image_data*(2^70);
file='imade_data2.txt';
fid1=fopen(file,'w');
for sc=1:m
    for bf_values=1:n
     fprintf(fid1,'%f\n',image_data2(bf_values,sc));
    % image_data(bf_values,sc)
    end
end
fclose(fid1);
n=n+(max_sample-min_sample);

 rf_data = zeros(n, N_lines);
 for i=1:N_lines
    rf_temp = [image_data(:,i) ];    
    rf_data(1:size(rf_temp, 1),i)=rf_temp;
end

%%IMAGING TRYING 22-AUG-2017

%% GENERATE IMAGE FROM RF-DATA 
D = 1;              % Decimation factor
dyn = 17;           % Dynamic range
gain = 15;           % Image gain


%% Decimate
rf_d = rf_data(1:D:size(rf_data, 1), :);
fn= fs/D;           % New sampling frequency
power11=zeros(61,1);
for nn=1:61
    ppp=ffff(:,nn);
    power=ppp'*ppp;
    power11(nn)=power
end
power22=power11/max(power11);
power_db=10*log10(power22);
figure (7);
plot(power_db);
set(gca,'XTick',0:10:60)
set(gca,'XTickLabel',-30:10:30)
xlabel('Beam angle [deg]');
ylabel('power in dB');
figure (12);
plot(power_db);
set(gca,'XTick',0:10:60)
set(gca,'XTickLabel',-20:6.6:19.6)
xlabel('Lateral distance [mm]');
ylabel('power in dB');
% Check distribution
% if checkGaussDist==0
%     figure
%     imagesc(rf_d);
%     [x, y] = ginput(2);
%     hold on
%     plot([x(1), x(1), x(2), x(2), x(1)], [y(1), y(2), y(2), y(1), y(1)], 'r')
%     hold off
%     histData = rf_d(y(1):y(2), x(1):x(2));
%     figure;
%     histfit(histData(:), 100);
% end
%     figure(1);
%     plot(rf_d);
%     x11=rf_d*2^70;
%     x1=int16(x11);
%    figure(7);
%    plot(x1);
%% Hilbert transform data
rf_h = hilbert(rf_d);
% figure(2);
% plot (abs(rf_h));
%% IQ demodulate data
t_dmod = (0:size(rf_h,1)-1)'/fn;
iqData = rf_h;%.*repmat(exp(-2*pi*j*f0*t_dmod),1,size(rf_h,2) );
% figure(5)
% plot(abs(iqData));

%% Detection
env = iqData.*conj(iqData);
env_n = env/max(max(env))+1e-12;
log_env = 10*log10(env_n);
% figure(6)
l1=size(log_env);
l2= [1:1:l1(1)];
l3=(2*l2)/c;

% plot(log_env);
%% Display resulting image
% Create axes
timetxrx = min(times) + (0:size(rf_d,1)-1)/fn;
[max_pulse_val, max_pulse_idx] = max(abs(hilbert(conv(excitation,conv(impulse_response,impulse_response)))));
timetxrx=timetxrx-max_pulse_idx/fs;     % Correct depth axis for duration of excitation and impulse response
disttxrx=(timetxrx)*c/2;
x_axis_angle = linspace(theta_start,theta_end, size(env_n, 2));

% Plot image in beam space
figure (9);
h_ph_img = imagesc(x_axis_angle*180/pi, disttxrx*1000, log_env);
caxis([-dyn 0]-gain);
xlabel(['Beam angle [deg]'])
ylabel('Axial distance [mm]')
colormap(gray(256));
axis on
figure (11);
h_ph_img = imagesc(x_axis_angle*180/pi, disttxrx*1000, log_env);
caxis([-dyn 0]-gain);
set(gca,'XTick',-30:10:30)
set(gca,'XTickLabel',-20:6.6:19.6)
xlabel(['Lateral distance [mm]'])
ylabel('Axial distance [mm]')
colormap(gray(256));
axis on
% Plot scan converted image
angles_mat = ones(length(disttxrx), 1)*(x_axis_angle+pi/2);
ranges_mat = (disttxrx)'*ones(1, length(x_axis_angle));
angles_mat;
ranges_mat;
[X_im, Y_im] = pol2cart(angles_mat, ranges_mat);

figure (10); 
pcolor(X_im*1000,Y_im*1000,log_env); 
caxis([-dyn 0]-gain);       % Set dynamic range and gain in image
shading interp; colormap(gray(256));
axis ij
axis equal;
xlabel('Azimuth [mm]');ylabel('Depth [mm]');
return
