%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Genearating Bearing Fault %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    p = {0.05, 0.10, 0.12, 0.15}; % pitch diameter (cm)
    d = 0.02; % ball diameter
    n = {8, 10}; % number of balls
    th = 0; % contact angle of ball
    f0 = {100, 200};% shaft speed
    fs = 12000; % sampling frequency
    amplitude = 0.2;
    total_time = 1;%(seconds)
    
    xBPFO_multi = [];
    xBPFI_multi=[];
    xHealthy_multi=[];
    
    for i = 1:numel(p)
        for j = 1:numel(n)
            for k = 1:numel(f0)
                [xHealthy, xBPFI, xBPFO] = syntheticDataGeneration(p{i}, d, n{j}, th, f0{k}, fs, amplitude, total_time);
                xHealthy_multi = [xHealthy_multi, xHealthy];
                xBPFI_multi = [xBPFI_multi, xBPFI];
                xBPFO_multi = [xBPFO_multi, xBPFO];
            end
        end
    end
    
    xHealthy = xHealthy_multi;
    xBPFI = xBPFI_multi;
    xBPFO = xBPFO_multi;
    subplot(3,1,1);
    plot(xHealthy(1:200));
    legend('Healthy');
    % save('..\Fault Datasets\Useful dataset\model_sim\xHealthy_multi.mat','xHealthy');
    subplot(3,1,2);
    plot(xBPFI(1:200));
    legend('BPFI');
    % save('..\Fault Datasets\Useful dataset\model_sim\xBPFI_multi.mat','xBPFI');
    subplot(3,1,3);
    plot(xBPFO(1:200));
    legend('BPFO');
    % save('..\Fault Datasets\Useful dataset\model_sim\xBPFO_multi.mat','xBPFO');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Genearating Gear Fault %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%



fs = 12000;
Np = {16};
Ng = {30, 40, 50};
fPin = {200, 100};%, 45, 75};
fImpact = {4000, 2000};%, 2000};
duration = {1e-3, 2.5e-3};
total_time = 2;%(seconds)
fault_amplitude = {0.2, 0.5};

vMT_multi=[];
vCT_multi=[];
vNoFaultNoisy_multi=[];

for i = 1:numel(Np)
    for j = 1:numel(Ng)
        for k = 1:numel(fPin)
            for ii = 1:numel(fImpact)
                for jj = 1:numel(duration)
                    for kk = 1:numel(duration)
                        % disp(Np{i})
                        % disp(Ng{j})
                        % disp(fPin{k})
                        % disp(fImpact{ii})
                        [vNoFaultNoisy,vMT, vCT] = syntheticGearGeneration(fs, Np{i}, Ng{j}, fPin{k}, total_time, fImpact{ii}, duration{jj}, fault_amplitude{kk});
                        vMT_multi = [vMT_multi, vMT];
                        vCT_multi = [vCT_multi, vCT];
                        vNoFaultNoisy_multi = [vNoFaultNoisy_multi, vNoFaultNoisy];
                    end
                end
            end
        end
    end
end

vFaultNoisy = vFaultNoisy_multi;
vNoFaultNoisy = vNoFaultNoisy_multi;
vCT = vCT_multi;
vMT = vMT_multi;

subplot(7,1,1);
plot(vNoFaultNoisy(1:1200));
legend('vNoFaultNoisy');
save('..\Fault Datasets\Useful dataset\model_sim\vNoFaultNoisy_multi.mat','vNoFaultNoisy');
subplot(7,1,2);
plot(vFaultNoisy(1:1200));
legend('vCT');
save('..\Fault Datasets\Useful dataset\model_sim\vCT_multi.mat','vCT');
subplot(7,1,3);
plot(vFaultNoisy(1:1200));
legend('vMT');
save('..\Fault Datasets\Useful dataset\model_sim\vMT_multi.mat','vMT');























