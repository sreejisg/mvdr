clear all;

P.numRays = 61;
P.startDepth = 0;
P.endDepth = 160;
P.txFocus = 100;

% Specify system parameters.
Resource.Parameters.numTransmit = 64;  % number of transmit channels.
Resource.Parameters.numRcvChannels = 64;  % number of receive channels.
Resource.Parameters.speedOfSound = 1540;
Resource.Parameters.verbose = 2;
Resource.Parameters.initializeOnly = 0;
Resource.Parameters.simulateMode = 0;
%  Resource.Parameters.simulateMode = 1 forces simulate mode, even if hardware is present.
%  Resource.Parameters.simulateMode = 2 stops sequence and processes RcvData continuously.

% Specify Trans structure array.
Trans.name = 'P4-2v';
Trans.units = 'wavelengths'; % required in Gen3 to prevent default to mm units
Trans = computeTrans(Trans);
Trans.maxHighVoltage = 50;  % set maximum high voltage limit for pulser supply.
Trans.HVMux = computeUTAMux64(); % add the HVMux structure for UTA module

P.theta = -pi/6;
P.rayDelta = 2*(-P.theta)/(P.numRays-1);
P.aperture = 64*Trans.spacing;
P.radius = (P.aperture/2)/tan(-P.theta); % dist. to virt. apex
% Change default settings for Mux Adapter
Trans.numelements = 128;
Trans.ElementPos = cat(1,zeros(32,4),Trans.ElementPos,zeros(32,4));
Trans = rmfield(Trans,'Connector');

% Specify Media.  Use point targets in middle of PData.
% Set up Media points
% - Uncomment for speckle
% Media.MP = rand(40000,4);
% Media.MP(:,2) = 0;
% Media.MP(:,4) = 0.04*Media.MP(:,4) + 0.04;  % Random amplitude 
% Media.MP(:,1) = 2*halfwidth*(Media.MP(:,1)-0.5);
% Media.MP(:,3) = P.endDepth*Media.MP(:,3);
% Media.MP(1,:) = [35,0,30,1.0];
% Media.MP(2,:) = [35,0,20,1.0];
% Media.MP(3,:) = [35,0,70,1.0];
% Media.MP(4,:) = [35,0,40,1.0];
% Media.MP(5,:) = [35,0,60,1.0];
Media.MP(1,:) = [0,0,90,1.0];
Media.MP(2,:) = [0,0,93,1.0];
% Media.MP(7,:) = [35,0,120,1.0];
% Media.MP(8,:) = [35,0,150,1.0];
% Media.MP(2,:) = [-15,0,30,1.0];
% Media.MP(3,:) = [15,0,30,1.0];
% Media.MP(4,:) = [45,0,30,1.0];
% Media.MP(5,:) = [-15,0,60,1.0];
% Media.MP(6,:) = [-15,0,90,1.0];
% Media.MP(7,:) = [-15,0,120,1.0];
% Media.MP(8,:) = [-15,0,150,1.0];
% Media.MP(9,:) = [-45,0,120,1.0];
% Media.MP(10,:) = [15,0,120,1.0];
% Media.MP(11,:) = [45,0,120,1.0];
% Media.MP(12,:) = [-10,0,69,1.0];
% Media.MP(13,:) = [-5,0,75,1.0];
% Media.MP(14,:) = [0,0,78,1.0];
% Media.MP(15,:) = [5,0,80,1.0];
% Media.MP(16,:) = [10,0,81,1.0];
% Media.MP(17,:) = [-75,0,120,1.0];
% Media.MP(18,:) = [75,0,120,1.0];
% Media.MP(19,:) = [-15,0,180,1.0];
Media.numPoints = 1;
Media.attenuation = -0.5;
Media.function = 'movePoints';
% Specify Resources.
Resource.RcvBuffer(1).datatype = 'int16';
Resource.RcvBuffer(1).rowsPerFrame = 2048*P.numRays; % This is for the max range on range slider. 
Resource.RcvBuffer(1).colsPerFrame = Resource.Parameters.numTransmit;
Resource.RcvBuffer(1).numFrames = 1;  
%Resource.InterBuffer(1).numFrames = 1;  % 1 frame defined but no intermediate buffer needed.
%Resource.ImageBuffer(1).numFrames = 1;
%Resource.ImageBuffer(1).rowsPerFrame = 768;%2048*P.numRays; % This is for the max range on range slider. 
%Resource.ImageBuffer(1).colsPerFrame = 61;%Resource.Parameters.numTransmit;

% Specify TW structure array.
TW(1).type = 'parametric';
TW(1).Parameters = [Trans.frequency,.67,4,1];   
% Specify TGC Waveform structure.
TGC(1).CntrlPts = [500,590,650,710,770,830,890,950];
TGC(1).rangeMax = 200;
TGC(1).Waveform = computeTGCWaveform(TGC);
% Specify TX structure array.
TX = repmat(struct('waveform', 1, ...
                   'Origin', [0.0,0.0,0.0], ...
                   'focus', P.txFocus, ...
                   'Steer', [0.0,0.0], ...
                   'aperture', 33,...
                   'Apod', ones(1,64), ...  % set TX.Apod for 64 elements
                   'Delay', zeros(1,64)), 1, P.numRays);
% - Set event specific TX attributes.
Angles = P.theta:P.rayDelta:(P.theta + (P.numRays-1)*P.rayDelta);
TXorgs = P.radius*tan(Angles);
for n = 1:P.numRays   % P.numRays transmit events
    TX(n).Origin = [TXorgs(n),0.0,0.0];
    TX(n).Steer = [Angles(n),0.0];
    TX(n).Delay = computeTXDelays(TX(n));
end

maxAcqLength = ceil(sqrt(P.aperture^2 + P.endDepth^2 - 2*P.aperture*P.endDepth*cos(P.theta-pi/2)) - P.startDepth);
wlsPer128 = 128/(2*2); % wavelengths in 128 samples for 2 samplesPerWave
Receive = repmat(struct('Apod', ones(1,64), ...
                        'startDepth', P.startDepth, ...
                        'endDepth', P.startDepth + wlsPer128*ceil(maxAcqLength/wlsPer128), ...
                        'aperture', 33,...
                        'TGC', 1, ...
                        'bufnum', 1, ...
                        'framenum', 1, ...
                        'acqNum', 1, ...
                        'sampleMode', 'NS200BW', ...
                        'mode', 0, ...
                        'callMediaFunc', 0),1,P.numRays*Resource.RcvBuffer(1).numFrames);
% - Set event specific Receive attributes.
for i = 1:Resource.RcvBuffer(1).numFrames
    Receive(P.numRays*(i-1)+1).callMediaFunc = 1;
    for j = 1:P.numRays
        Receive(P.numRays*(i-1)+j).framenum = i;
        Receive(P.numRays*(i-1)+j).acqNum = j; 
    end
end        

% Specify Recon structure array.
% Recon = struct('senscutoff', 0.5, ...
%                'pdatanum', 1, ...
%                'rcvBufFrame',-1, ...
%                'IntBufDest', [1,1], ...
%                'ImgBufDest', [1,-1], ...
%                'RINums', 1:P.numRays);

% % Define ReconInfo structures.
% ReconInfo = repmat(struct('mode', 'replaceIntensity', ...  % replace data.
%                    'txnum', 1, ...
%                    'rcvnum', 1, ...
%                    'regionnum', 0), 1, P.numRays);
% % - Set specific ReconInfo attributes.
% for i = 1:P.numRays
%     ReconInfo(i).txnum = i;
%     ReconInfo(i).rcvnum = i;
%     ReconInfo(i).regionnum = i;
% end
    
% Specify an external processing event.
% CHECK 1 -- PLOTING THE RF DATA
% Process(1).classname = 'External';
% Process(1).method = 'myDisplay';
% Process(1).Parameters = {'srcbuffer','receive',... % name of buffer to process.
% 'srcbufnum',1,...
% 'srcframenum',1,...
% 'dstbuffer','none'};
% CHECK 2 -- CHECKING
Process(1).classname = 'External';
%Process(1).method = 'myDBF';
Process(1).method = 'MVDR_QR_VER';
Process(1).Parameters = {'srcbuffer','receive',... % name of buffer to process.
'srcbufnum',1,...
'srcframenum',-1,...
'dstbuffer','none'};
% %'dstbufnum',1,...
% %'dstframenum',1,...
% %};
% Specify SeqControl structure arrays.
t1 = 2*354*.4 + 20; % ray line acquisition time for worst case range in usec
t2 = round((1e+06-127*t1*25)/25);   % Time between frames at 25 fps.
 SeqControl(1).command = 'jump'; %  - Jump back to start.
 SeqControl(1).argument = 1;
 SeqControl(2).command = 'timeToNextAcq';  % set time between rays
 SeqControl(2).argument = t1; 
 SeqControl(3).command = 'timeToNextAcq';  % set time between frames
 SeqControl(3).argument = t2;
% SeqControl(4).command = 'returnToMatlab';
nsc = 4;
n = 1;
for i = 1:Resource.RcvBuffer(1).numFrames
        for j = 1:P.numRays                      % Acquire rays
            Event(n).info = 'Acquire ray line';
            Event(n).tx = j; 
            Event(n).rcv = P.numRays*(i-1)+j;   
            Event(n).recon = 0;      
            Event(n).process = 0;    
            Event(n).seqControl = 2; 
            n = n+1;
        end
        Event(n-1).seqControl = [3,nsc]; % Replace last event's seqControl for frame time and transferToHost.
        SeqControl(nsc).command = 'transferToHost'; % transfer frame to host buffer
        nsc = nsc + 1;
    Event(n).info = 'recon and process'; 
    Event(n).tx = 0;         
    Event(n).rcv = 0;        
    Event(n).recon = 0;      
    Event(n).process = 1;     
      if floor(i/3) == i/3     % Exit to Matlab every 3rd frame reconstructed 
        Event(n).seqControl = 4;
    else
        Event(n).seqControl = 0;
    end
   % Event(n).seqControl = 0;
   n = n + 1;
end
Event(n).info = 'Jump back';
Event(n).tx = 0;        
Event(n).rcv = 0;       
Event(n).recon = 0;     
Event(n).process = 0; 
Event(n).seqControl = 1;
% ===================================================
% Event(1).info = 'Acquire ray line';
% Event(1).tx = 1; 
% Event(1).rcv = 1;%P.numRays*(i-1)+j;   
% Event(1).recon = 0;      
% Event(1).process = 0;  
% Event(1).info = 'Acquire ray line';
% Event(1).seqcontrol = 2;
% Event(2).tx = 1; 
% Event(2).rcv = 1;%P.numRays*(i-1)+j;   
% Event(2).recon = 0;      
% Event(2).process = 0;  
% Event(2).seqControl = 1; % transfer data to host
% SeqControl(1).command = 'transferToHost';
% 
% Event(3).info = 'Call external Processing function.';
% Event(3).tx = 0; % no TX structure.
% Event(3).rcv = 0; % no Rcv structure.
% Event(3).recon = 0; % no reconstruction.
% Event(3).process = 1; % call processing function
% Event(3).seqControl = 0;
% ===================================================
% Save all the structures to a .mat file.
save('./MatFiles/P4-2v_61lines_focus_liya');