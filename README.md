# Simulation Fault Generation

This repository contains MATLAB scripts for generating synthetic fault signals for bearings and gears. These datasets can be used for vibration analysis, fault diagnosis, and other condition monitoring experiments.

## Contents

- `main.m` - Example script that demonstrates how to generate bearing and gear fault datasets.
- `syntheticDataGeneration.m` - Function for creating bearing vibration signals (healthy, ball-pass-frequency-inner race, ball-pass-frequency-outer race).
- `syntheticGearGeneration.m` - Function for simulating gear faults such as missing and chipped teeth.

## Requirements

- MATLAB R2016b or later. The scripts rely on basic MATLAB functions and do not require additional toolboxes.

## Usage

1. Clone this repository and open the project folder in MATLAB.
2. Run `main.m` to generate example datasets for bearings and gears. The script creates synthetic time-series signals and displays sample plots.

    ```matlab
    % From the MATLAB command window
    main
    ```

   The generated signals include:
   - `xHealthy`, `xBPFI`, `xBPFO` for bearing conditions.
   - `vNoFaultNoisy`, `vMT`, `vCT` for gear conditions.

3. Customize the parameters inside `main.m` or call the functions directly for more specific simulations.

### Example: Bearing Fault Generation

```matlab
% Parameters
p = 0.05;      % pitch diameter (m)
d = 0.02;      % ball diameter (m)
n = 8;         % number of balls
th = 0;        % contact angle (rad)
f0 = 100;      % shaft speed (Hz)
fs = 12000;    % sampling frequency (Hz)
amplitude = 0.2;
total_time = 1; % seconds

[xHealthy,xBPFI,xBPFO] = syntheticDataGeneration(p,d,n,th,f0,fs,amplitude,total_time);
```

### Example: Gear Fault Generation

```matlab
fs = 12000;         % sample rate
Np = 16;            % pinion teeth count
Ng = 30;            % gear teeth count
fPin = 200;         % pinion shaft speed (Hz)
impactFreq = 4000;  % impact-induced vibration frequency (Hz)
duration = 1e-3;    % impact duration (s)
faultAmp = 0.5;     % amplitude of the fault signal

totalTime = 2;      % seconds

[vNoFaultNoisy,vMT,vCT] = syntheticGearGeneration(fs,Np,Ng,fPin,totalTime,impactFreq,duration,faultAmp);
```
