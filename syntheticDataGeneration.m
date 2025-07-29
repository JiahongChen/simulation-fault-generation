
function [xHealthy,xBPFI,xBPFO] = syntheticDataGeneration(p, d, n, th, f0, fs, amplitude, total_time)
    %%%%%%%%%%%%%%%
    %%% Bearing %%%
    %%%%%%%%%%%%%%%

    t = 0:1/fs:total_time-1/fs;
    z = [1 0.5 0.2 0.1 0.05]*sin(2*pi*f0*[1 2 3 4 5]'.*t);
    % xHealthy = z + randn(size(z))/10;
    xHealthy =amplitude*z + randn(size(z))/2;
    % subplot(3,1,1);
    % plot(xHealthy);
    % legend('xHealthy');
    % save('..\Fault Datasets\Useful dataset\model_sim\xHealthy.mat','xHealthy');
    
    bpfo = n*f0/2*(1-d/p*cos(th));
    
    tmp = 0:1/fs:5e-3-1/fs;
    xmp = sin(2*pi*3000*tmp).*exp(-1000*tmp);
    % noise = randn(size(t));	% Create noise.
    % noise = amplitude*noise/max(noise);
    xHealthy =amplitude*z + randn(size(z))/2;
    xBPFO = xHealthy+pulstran(t,0:1/bpfo:1,xmp,fs)*3;
    
    
    bpfi = n*f0/2*(1+d/p*cos(th));
    % noise = randn(size(t));	% Create noise.
    % noise = amplitude*noise/max(noise);
    xHealthy =amplitude*z + randn(size(z))/2;
    xBPFI = xHealthy+pulstran(t,0:1/bpfi:1,xmp,fs)*3;
    
    % subplot(3,1,2);
    % plot(xBPFI);
    % legend('BPFI');
    % % save('..\Fault Datasets\Useful dataset\model_sim\xBPFI.mat','xBPFI');
    % subplot(3,1,3);
    % plot(xBPFO);
    % legend('BPFO');
    % % save('..\Fault Datasets\Useful dataset\model_sim\xBPFO.mat','xBPFO');
end