% mkV1SimpleReceptiveField.m
%
% DESCRIPTION -------------------------------------------------------------
% This file makes V1 simple cell receptive field as described in Iyer and
% Burge 2018 BioRxived paper "Model neuron response statistics to natural
% images."
%
% DEPENDENCIES ------------------------------------------------------------
% mkCenterSurroundFilter.m from Githubrepository retina2v1_code
addpath(genpath('/Volumes/GoogleDrive/My Drive/projects/frontendModel/retina2v1_code'))
%
% HISTORY:
% 08/27/2018, JYZ

%% PRE-DEFINED PARAMETERS

sigma    = 0.01; % in degree of visual angles, std of the Gaussian filter
filterSR = 0.001; % filter sampling rate, in unit of degrees
angle    = 1/2 * pi; % in unit of radians, clock-wise
freq     = 7; % number of cycles per degree
phse     = 0 * pi;
%
%% MAKE GABOR FILTER WITH DESIRED ORIENTATION AND SPATIAL FREQUENCY BANDWIDTH

% According to Iyer and Burge: 
%   The median orientation bandwidth in cortex in 42 degrees (De Valois,
%   Ynd, & Hepler, 1982b). 
%   The distribution of simple cell bandwidths in cortex ranges between 0.8
%   to 1.8 octaves at half-height, with a median bandwidth of 1.2 octaves
%   (De Valois, Albrecht, & Thorell, 1982a).
% The goal here is to construct the gabor receptive field as described, but
% with specified orientation and phase.

%% MAKE GAUSSIAN RECEPTIVE FIELD (RF range)

[gaussian, gaussGrid] = mkCenterSurroundFilter_mismatched(sigma, 0, 1, filterSR, 'on');

%% MAKE ORIENTED GRATING

[X, Y]   = meshgrid(gaussGrid, gaussGrid);

rotation = X * sin(angle) + Y * cos(angle);
filterSz = max(gaussGrid) - min(gaussGrid);
grating  = sin(rotation * 2 * pi * filterSz * freq + phse); % Grating values are between 0 and 1

%% MAKE GABOR FILTER

gabor = gaussian .* grating;

% zero-mean the filter:
gabor   = gabor - mean(gabor(:));
f_gabor = fftshift2(abs(fft2(gabor)));

%f = [0 : length(baseline_tRange)-1]./(length(baseline_tRange)/1000);

f_axis     = ((0 : 1 : length(gaussGrid) - 1)/length(gaussGrid)-0.5)/filterSR;
%f_axis     = gaussGrid ./filterSR;
[F_X, F_Y] = meshgrid(f_axis, f_axis);

%% COMPUTE ORIENTATION AND FREQUENCY BANDWIDTH



%% VISUALIZE FILTERS

% According to Iyer and Burge:
% Spatial frequency bandwidth is the range of frequencies spanned by the
% spectrum, oxtage bandwidth is the log-base-two ratio of the frequencies.

% Orientation bandwidth is the polar angle spanned by the amplitude
% spectrum at half-height

figure (1), clf
subplot(3, 3, 1), imagesc(gaussGrid, gaussGrid, gaussian), colorbar, title('Gaussian'), ylabel('deg.')
subplot(3, 3, 2), imagesc(gaussGrid, gaussGrid, grating), colorbar, title('oriented grating'), ylabel('deg.')
subplot(3, 3, 3), imagesc(gaussGrid, gaussGrid, gabor), colorbar, title('gabor'), ylabel('deg.')
subplot(3, 3, 4), imagesc(f_axis, f_axis, f_gabor),  caxis([0, 1]), colorbar, xlim([-30, 30]), title('gabor (frequency domain)'), ylabel('cyc/deg.'), ylim([-30, 30]),
subplot(3, 3, 5), surf(F_X, F_Y, f_gabor),  title('gabor (frequency domain)'), xlabel('cyc/deg.'), xlim([-30, 30]), ylim([-30, 30]),


%subplot(3, 3, 7), plot()