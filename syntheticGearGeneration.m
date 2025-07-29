function [vNoFaultNoisy,vMT, vCT] = syntheticGearGeneration(fs, Np, Ng, fPin, total_time, fImpact, duration, fault_amplitude)
    % fs: Sample Rate (Hz)
    % Np: Number of teeth on pinion
    % Ng: Number of teeth on gear
    % fPin: Pinion (Input) shaft frequency (Hz)
    % total_time: total simulation time
    % fImpact: vibration signal caused by faulty part impact (Hz)
% if 1
    % fs = 12000;
    % Np = 16;%, 24, 32};
    % Ng = 30;%, 40, 50};
    % fPin = 200;%, 45, 75};
    % fImpact = 4000;%, 2000};
    % total_time = 1;%(seconds)
    % duration = 1e-3;
    % fault_amplitude = 0.5; % Amplitude of the faults


    fGear = fPin*Np/Ng; % Gear (Output) shaft frequency (Hz)
    
    fMesh = fPin*Np;    % Gear Mesh frequency (Hz)

    t = 0:1/fs:total_time-1/fs;

    vfIn = 0.2*sin(2*pi*fPin*t);    % Pinion waveform     
    vfOut = 0.1*sin(2*pi*fGear*t);  % Gear waveform
    
    vMesh = sin(2*pi*fMesh*t);      % Gear-mesh waveform

    % The local fault causes an impact that has a duration shorter than the duration of tooth mesh.
    % A dent on the tooth surface of the gear generates high-frequency oscillations over the duration of the impact. 
    % The frequency of impact is dependent on gearbox component properties and its natural frequencies. 
    % In this example, it is arbitrarily assumed that the impact causes a 
    % 'fImpact' Hz vibration signal and occurs over a duration of about
    % 8% of 1/fMesh, or 0.25 milliseconds. The impact repeats once per rotation of the gear.
    
    ipf = fGear;       
    % duration = 1e-3;%1/fMesh*0.08;% 2.5e-4; duration of the faulty impact

    tImpact = 0:1/fs:duration-1/fs; 
    xImpact = sin(2*pi*fImpact*tImpact)/3;

    xComb = zeros(size(t));
    
    % Make the impact periodic by convolving it with a comb function.
    Ind = (0.25*fs/fMesh):(fs/ipf):length(t);
    Ind = round(Ind);
    xComb(Ind) = 1;
    
    xPer = 2*conv(xComb,xImpact,'same');

    vNoFault = vfIn + vfOut + vMesh;
    
    % amplitude = 0.2;
    % f0 = 100;
    % z = [1 0.5 0.2 0.1 0.05]*sin(2*pi*f0*[1 2 3 4 5]'.*t);
    % vNoFault =amplitude*z + randn(size(z))/2;

    % Add the fault signal xPer to the shaft signal.
    vFault = vNoFault + xPer*2;
    
    %% Missing tooth fault
    % Calculate missing tooth index range based on number of teeth and gear mesh frequency
    % missing_tooth_interval = round(length(t) / num_faults);
    num_faults = floor(length(t) / fPin);       % Number of missing tooth faults
    missing_tooth_interval = round(length(t) / num_faults);
    missing_tooth_duration = 10;
    
    % Initialize missing tooth fault
    fault_missing_tooth = zeros(size(t));
    
    % Introduce missing tooth faults at regular intervals
    for i = 1:num_faults
        missing_tooth_start = (i - 1) * missing_tooth_interval + 1;
        fault_missing_tooth(missing_tooth_start:missing_tooth_start+missing_tooth_duration-1) = fault_amplitude;
    end
    %% Chipped tooth fault
    chipped_tooth_index = round(0.8 * length(t));
    fault_chipped_tooth = fault_amplitude * cos(2*pi*fMesh*t);
    fault_chipped_tooth(chipped_tooth_index:chipped_tooth_index+round(fs/(2*fMesh))) = 0;

    % Add white Gaussian noise to the output signals
    vNoFaultNoisy = vNoFault + randn(size(t))/10;
    % vFaultNoisy = vFault + randn(size(t))/5;
    vMT = vNoFault + fault_missing_tooth (1:length(vNoFault)) + randn(size(t))/10;
    vCT = vNoFault + fault_chipped_tooth (1:length(vNoFault)) + randn(size(t))/10;
    
    subplot(3,1,1)
    plot(t(1:1000),vNoFaultNoisy(1:1000))
    xlabel('Time (s)')
    ylabel('Acceleration')
    % xlim([0.0 0.3])
    % ylim([-2.5 2.5])
    title('Noisy Signal for Healthy Gear')


    subplot(3,1,2)
    plot(t(1:1000),vMT(1:1000))
    xlabel('Time (s)')
    ylabel('Acceleration')
    % xlim([0.0 0.3])
    % ylim([-2.5 2.5])
    title('Noisy Signal for Faulty Gear (Missing Tooth)')

    subplot(3,1,3)
    plot(t(1:1000),vCT(1:1000))
    xlabel('Time (s)')
    ylabel('Acceleration')
    % xlim([0.0 0.3])
    % ylim([-2.5 2.5])
    title('Noisy Signal for Faulty Gear (Chipped Tooth)')
    % hold on
    % MarkX = t(Ind(1:3));
    % MarkY = 2.5;
    % plot(MarkX,MarkY,'rv','MarkerFaceColor','red')
    % hold off
end