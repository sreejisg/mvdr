function MVDR_QR_Without_acc_VER(rcvdata)
% j%%make
% clear all
% LoadData
clc
close all
%% DEFINE ARRAY
f0 = 2.976e6; % Central frequency [Hz]
fs = 4*f0; % Sampling frequency [Hz]
c = 1540; % Speed of sound [m/s]
N = 64;% Number of elements in the transducer
L=8;% subarray size
Ts = 1/fs;
lambda = c / f0; % Wavelength [m]
% width = (0.4831/1000)*lambda;
% kerf = (0.2895/1000)*lambda; % Inter-element spacing [m]
% pitch = width+kerf;
  pitch = 0.299/1000;% Pitch - center-to-center [m]
% pitch = 0.1;
% pitch = 0.30/1000;% Pitch - center-to-center [m]
% kerf = 0.025/1000;% Inter-element spacing [m]
% width = pitch - kerf;% Width of the element [m]
% height = 13/1000; % Size in the Y direction [m]
Nd=(N-1)/2;
d=pitch;
% checkGaussDist = 1; 

 % Define and create the image
 sector = 60 * pi / 180;
 no_lines = 61;
 d_theta = sector / (no_lines-1);
 %theta=-1* pi / 180;;
 theta = (-sector/2);
%  theta = -(no_lines-1) / 2 * d_theta;
%  times = zeros(1, 61); 
%  theta_emit = -sector/2;                 % Start angle for transmit aperture
%  theta_receive = theta_emit;             % Start angle for receive aperture
%  theta_start = theta_emit; 

%  Rmax = max(sqrt(pht_pos(:,1).^2  + pht_pos(:,2).^ 2 + pht_pos(:,3).^ 2)) + 15/1000;
% Rmax=82.8/1000;
 Rmax=120/1000;
 no_rf_samples = 1536;
 rf_line = zeros(no_rf_samples, 1);
 conv_line=zeros(2048,1);%zeros(2^nextpow2(no_rf_samples), 1);
 
%  env_line = zeros(no_rf_samples, no_lines);
 conv_temp2  = zeros(2^nextpow2(no_rf_samples), no_lines);
  
%  xmt_r = (max(focus_r) + min(focus_r) )/2;
%  FRx=focus_r;
 FTx=60/1000;
 
 CBFY(no_lines,2^nextpow2(no_rf_samples))=0;
 sln=61
 MVDRY=zeros(1,2048);
 for i = 1 :no_lines 
   rf_line(:) = 0;
   disp(['Line_no' num2str(i)]);

 % Beamform with Field II
 rf_data=rcvdata(1+((scan-1)*(1536*1)):scan*(1536*1),:);
%    rf_data = rcvdata(:,:,sln,1);
   sln = sln -1;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % MVDR and Freq Domain BF Beamforming
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %%%%%%%%%%%%%%% Array Signal Generation %%%%%%%%%%%%%%%%%%%%%%
   
  M=length(rf_data);
   Nfft = 2^nextpow2(no_rf_samples);
   Nbin = Nfft;
   rf_datatr=rf_data';
   rf_data_fft=fft(rf_datatr.',Nfft).';
     
     
%   %%%%%%%%%%%%%%%%% Overlapped FFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   OL_SKIP = 896; %%% 12.5 % overlap
%   OL_BLOCK = floor(M/OL_SKIP);
%    for q=0:OL_BLOCK-1;
%      p=rf_data(((OL_SKIP*q)+1):(Nfft+(OL_SKIP*q)),1:N);
%      rf_data_fft=fft(p,Nfft).';
   %%%%%%%%%%%%%%%%%% Delay Calculation %%%%%%%%%%%%%%%%%%%%%%%
 
     y1=sqrt(1+((Nd*d)/FTx)^2+((2*Nd*d)/FTx)*sin(theta));
     y2=sqrt((1+((((0:1:N-1)-Nd)*d)/FTx).^2-(((2*((0:1:N-1)-Nd)*d)/FTx)*sin(theta))));
     tauTxFocus =((FTx/c)*(y1-y2)*fs);
     
     
%      for i0=1:N
%         angle=theta;
%         F=FTx;
%         aa=(Nd*d/F)^2;
%         bb=2*Nd*d*sin(angle)/F;
%         cc=((i0-1-Nd)*d/F)^2;
%         dd=2*(i0-1-Nd)*d*sin(angle)/F;
%         tt=(F/c)*((sqrt(1+aa+bb))-(sqrt(1+cc-dd)));
%         time(i0)=tt*fs;   %time delays
% end   
   
   
%     for k=1:1:N
%      if(tauTxFocus(k)<0)
%        tauTxFocus(k)=tauTxFocus(k)+max(abs(tauTxFocus));
%      end
%    end  
%      
 
     if tauTxFocus>0
       tauTxFocus=tauTxFocus;
     else   
       tauTxFocus=tauTxFocus + abs(min(tauTxFocus));
      end
  
%    rf_data_fft1=zeros(64,2048);
%    delay=fix(tauTxFocus)+ones(1,64);
%    for g=1:1:64
%       rf_data_fft1(g,delay(g):2048)=rf_data_fft(g,1:(2048-delay(g)+1));
%    end
  for ibin=1:Nbin
      StVect(:,ibin)=exp(j*2e-4*pi*(1/Nfft)*ibin*tauTxFocus);
   end
  
%      pow_bin=0;  
     for k=1:Nbin
       mmm=Nbin-k+1;
       X= rf_data_fft(:,k).* StVect(:,k); % Delay compensated Frequency domain data.
       U=zeros(N-L+1,8);

       %R=zeros(8,8);
       %D=zeros(8,1);
       for l=0:1:N-L 
           s=l+1;
             U(s,:)=X(N-l-7:N-l);
%              U(s,:)=X(s:s+7);
             %D=D+X(l:l+7);
             %R= R + D*D';
       end
       [Q,S,E] = qr(U,0);
       %R=1/(N-L+1)*R;
       %D=1/(N-L+1)*D;
       sv1=[1;1;1;1;1;1;1;1];
%         sv=zeros(64,1);
%         sv=StVect(:,i);
       S_tran=S';
       nn=8;
       sv1_z=forwardSubstitution(S_tran,sv1,nn); 
       %R= (R+eye(L,L));
       %RiE= (R\sv1);
       W=sv1_z/(sv1_z'*sv1_z);
       %pow_bin = pow_bin +  1/(sv1'*RiE);
       Zmean= zeros(L,1);
       Zmean=1/(N-L+1)*sum(Q',2);
       MVDRY(k) = W'*Zmean;
     end
%        power_tot_bin(i) = abs(pow_bin); 
%     
%      power_instantaneous(i)=MVDRY(i,:)*MVDRY(i,:)';
%      
 
     
     %Power(i)=alpha*Power(i)+(1-alpha)*power_instantaneous(i);
     
   %del = exp(-j*2*pi*(fs/M)*tau*t);
 %%%%%%%%%%%%%%%%%%% Delay Estinmatioin %%%%%%%%%%%%%%%%%%%%%%
   l=1;
   for j=1:1:N
       for k=1:1:M
           if(rf_data(k,j)~=0)
               count_indx(l)=k;
               l=l+1;
               break;
           end
        end
   end
    
%     est_delay = max(count_indx)-count_indx;
%     stem(est_delay);
%     hold on
%     stem(tauTxFocus,'r');
%     delay_err=abs(est_delay-tauTxFocus);
%     delay_tot(i)=sum(delay_err');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Bin Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     for ibin=1:Nbin
%             s=StVect(:,ibin)';
%             s_conj = conj(s);
%             X= rf_data_fft(:,ibin);
% %             R=X*X';
% %             RinvS= (R+eye(N,N))\s';
% %             W=RinvS/(s*RinvS);
% %             MVDRY(ibin,i) = W'*X;
%             CBFY(ibin,i)=s * rf_data_fft(:,ibin); %Conv BF
%     end
%     
 
%    temp_power_cbf=0;
%         temp_power_mvdr=0;
%             for ibin = 1 : Nbin/2
%                 temp_power_cbf=temp_power_cbf+CBFY(i,ibin)*conj(CBFY(i,ibin));
%                 %temp_power_mvdr = temp_power_mvdr + MVDRY(ibin-1,ntheta)*conj(MVDRY(ibin-1,ntheta));
%             end
%         powercbf(i)=temp_power_cbf;
%        % powermvdr(i) = temp_power_mvdr;
%    %conv_temp=sum(conv_bf_data');
%    %conv_temp = sum(conv_bf_data_fract);
%    
% 
%    start_t = start_t+2/ fs;
%   % conv_temp = conv_beamform(start t, rf_data);
% 
%    start_sample = t(i)*fs; no_temp_samples = length(rf_temp);
%    
% 
%    rf_line(start_sample:start_sample+no_temp_samples-1) = rf_temp(1:no_temp_samples);
%    env_line(:,i) = abs(hilbert(rf_line(:)));
% 
%     start_sample = floor(start_t*fs); 
    
    conv_temp1(:,i) = real(ifft(MVDRY));
    
%     mvdr_time_domain(((OL_SKIP*q)+1):(Nfft+(OL_SKIP*q)))=conv_temp1;
    
    
   

   
   
%    end
  
%     conv_temp =mvdr_time_domain;
%    
%     no_temp_samples = length(mvdr_time_domain);
%     conv_line = mvdr_time_domain;
%    env_bf(:,i) = abs(hilbert(conv_temp1 ));
   theta = theta + d_theta;
 
 end
 
 
%% GENERATE IMAGE FROM RF-DATA 
D = 1;              % Decimation factor
% dyn = 40;           % Dynamic range
% gain = 5; 
dyn = 40;           % Dynamic range
gain = 0;           % Image gain


%% Decimate
rf_d =flipud(conv_temp1);%(1:D:size(conv_temp1, 1), :);
fn= fs/D;           % New sampling frequency

% % Check distribution
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
env_n = env/max(max(env)); %1e-12;
log_env = 10*log10(env_n);
% figure(6)
% % l1=size(log_env);
% % l2= [1:1:l1(1)];
% % l3=(2*l2)/c;
% 
% plot(log_env);
%% Display resulting image
% Create axes
timetxrx =(0:size(rf_d,1)-1)/fn;
% [max_pulse_val, max_pulse_idx] = max(abs(hilbert(conv(excitation,conv(impulse_response,impulse_response)))));
% timetxrx=timetxrx-max_pulse_idx/fs;     % Correct depth axis for duration of excitation and impulse response
disttxrx=(timetxrx)*c/2;
x_axis_angle = linspace((-sector/2),(sector/2), size(env_n, 2));

% Plot image in beam space
% figure (9);
% h_ph_img = imagesc(x_axis_angle*180/pi, disttxrx*1000, log_env);
% caxis([-dyn 0]-gain);
% xlabel(['Beam angle [deg]'])
% ylabel('Range [mm]')
% colormap(gray(256));
% axis on

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
