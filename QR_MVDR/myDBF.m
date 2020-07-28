function myDBF(rcvdata)
tic 
% DEFINE ARRAY
N_elements = 64;
c = 1540;
f0 = 2.976e6;
fs = 4*f0;
Ts = 1/fs;
pitch = 0.30/1000;
f1 = 2e6;
f2 = 4e6;
Nd = (N_elements - 1)/2;
d = pitch;
apodTx = 2;

%  DEFINE IMAGING SECTOR 
sector=60 * pi/180;                             % Size of image sector [rad]
dThetaDesired=1*(pi/180);      %lateral resolution=1 degree
N_lines = round(sector/dThetaDesired)+1; % Number of scan lines in image
d_theta_emit = sector/(N_lines-1);       % Increment in emit angle for 90 deg. image
% INITIALIZE SIMULATION 
times = zeros(1, N_lines);              % Preallocating storage for times data
theta_emit = -sector/2;                 % Start angle for transmit aperture
theta_receive = theta_emit;             % Start angle for receive aperture
theta_start = theta_emit; 

impulse_response=sin(2*pi*f0*(0:1/fs:2/f0));%gauspuls(t_ir,f0,Bw);
impulse_response = impulse_response.*hanning(max(size(impulse_response)))';

% SET THE EXCITATION OF THE TRANSMIT APERTURE 
excitation=sin(2*pi*f0*(0:1/fs:2/f0));%square(2*pi*f0*t_ex);

switch apodTx
    case 0
        apo_emit = ones(1,N_elements);   % Rectangular apodization
    case 1
        apo_emit = kaiser(N_elements,100)'; % Hanning apodization on the emit-apperture
    case 2
        apo_emit = tukeywin(N_elements, 0.5)'; % Cosine-tapered apodization
end
image_data =zeros(1536,61);
%load rfdata_kidney;
sln = 61;
for scan = 1 : 1 : 61
% SECTION:1 Dynamic Receive Focusing setup
      rec_zone_start = 1/1000;           %depth where dyn receive focusing starts
      rec_zone_size = 1/1000;            %axial resolution
      rec_zone_stop = ((1/1000)- 1/1000)+5/100;%((t1*c/2)- 1.2/1000)+7.872/100;     %depth where dyn receive focusing stops
      rec_focal_zones_center=[rec_zone_start:rec_zone_size:rec_zone_stop]';      
      rec_focal_zones=rec_focal_zones_center-0.5*rec_zone_size;
      Nfr=max(size(rec_focal_zones));      
      pp=1;      
      v = rcvdata(1+((scan-1)*(768*2)):scan*(768*2),:);
      %v = rcvdata(:,:,sln,10);
      sln = sln -1;
       
for p=rec_zone_start:rec_zone_size:rec_zone_stop
    prp(pp)=2*p/c;
    no_sam(pp)=round(prp(pp)/Ts);
    pp=pp+1;
end
no_sam(pp) = max(size(v)) - 2;%round(prp(pp)/Ts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time(Nfr,N_elements)=0;

% SECTION:2 DELAY CALCULATION
%----Coarse delay-------%

Fo=1;        %Reprsents F_resol->dyn receive points in a scan line
% l=0;         %pointer to new position while circular buffering
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

%SECTION:3 COARSE DELAY AND FINE DELAY

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
 %sum1(1:num_diff(dyn))=0;
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

%    disp(['pos = ',num2str(pos)])
    
%------------CIRCULAR BUFFER(adding coarse delays)---------------------------
% for n1=1:num_diff(dyn) 
%     l=mod(pos,num_diff(dyn));%l->pointer to new position while circular buffering
% %    disp(['l = ',num2str(l)])
%     input(i,n1)=v2(i,l+1);
%     pos=pos+1;
%     if pos==num_diff(dyn)
%         pos=1;
%     end
% end

input(i,1:num_diff(dyn)) = v2(i,1:num_diff(dyn));

%l = 0;
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

% SECTION:4 SUMMER UNIT
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
bf_t=bf';  %beamformed output from one scan line

%%------------------------------------------BEAMFORMING for one scan line OVER-------------------------------------------------------------------------%%
    
%-------------------back end processing(from mycyst.m)------------------------------

% Store the result
    image_data(1:max(size(bf_t)), scan)=bf_t;
 %   times(scan) = t1;
    
    % Increment emit angle
    theta_emit = theta_emit + d_theta_emit;
    theta_receive = theta_emit;
   
end  

%scan_line loop ends
theta_end = theta_receive-d_theta_emit;
% IMAGING
 for i=1:N_lines
    %rf_temp = [ zeros(round(times(i)*fs)-min_sample,1) ; image_data(:,i) ];
    rf_temp = [image_data(:,i) ];    
    rf_data(1:size(rf_temp, 1),i)=rf_temp;
end
 mytime = toc; display(mytime)
%IMAGING TRYING 22-AUG-2017

% GENERATE IMAGE FROM RF-DATA 
D = 1;              % Decimation factor
dyn = 40;           % Dynamic range
gain = 0;           % Image gain
% Decimate
rf_d = rf_data(1:D:size(rf_data, 1), :);
fn= fs/D;           % New sampling frequency
% Hilbert transform data
rf_h = hilbert(rf_d);

% IQ demodulate data
iqData = rf_h;%;.*repmat(exp(-2*pi*j*f0*t_dmod),1,size(rf_h,2) );

% Detection
env = iqData.*conj(iqData);
env_n = env/max(max(env))+1e-12;
log_env = 10*log10(env_n);

% Display resulting image
timetxrx = min(times) + (0:size(rf_d,1)-1)/fn;
[~, max_pulse_idx] = max(abs(hilbert(conv(excitation,conv(impulse_response,impulse_response)))));
timetxrx=timetxrx-max_pulse_idx/fs;     % Correct depth axis for duration of excitation and impulse response
disttxrx=(timetxrx)*c/2;
x_axis_angle = linspace(theta_start,theta_end, size(env_n, 2));
% Plot scan converted image
angles_mat = ones(length(disttxrx), 1)*(x_axis_angle+pi/2);
ranges_mat = (disttxrx)'*ones(1, length(x_axis_angle));
[X_im, Y_im] = pol2cart(angles_mat, ranges_mat);
figure (10); 
pcolor(X_im*1000,Y_im*1000,log_env); 
caxis([-dyn 0]-gain);       % Set dynamic range and gain in image
shading interp; colormap(gray(256));
axis ij
axis equal;
xlabel('Azimuth [mm]');ylabel('Depth [mm]');
%mytime = toc; display(mytime)
return
 
