# posarrays
Matlab utilities for reading and analyzing GPS position files.

These utilities read daily position data from Japan's GEONET and Cascadia's PANGA networks and organize observations into station-by-date matrices. The sse directory contains functions for detecting and cataloging slow slip events, as well as estimating velocities from position data. 

## For GEONET:
After downloading F3 coordinates from GSI, place all yearly directories into a single 'master' directory, then run:

    geonetarrays('master_directory', 'output.mat')

to save an output file containing 2-dimensional arrays of time series information, including serial date and position. The dimensions of the resulting arrays are nStations-by-nDays, where nStations is the number of unique stations across all years, and nDays is the total number of days on which there is at least one position observation across all years. 

## For PANGA:
Run: 

    % Clone GitHub repository. Change into desired parent directory first
    !git clone https://github.com/jploveless/posarrays
    % Change to cloned directory
    cd posarrays
    % Add its functions to path
    addpath ./
    % Change to PANGA directory
    cd panga
    % Run function to download raw PANGA data and unzip
    getpanga
    % Read PANGA data files and place into arrays
    s = pangaarrays(‘raw/panga_coords.mat’);
    % Save arrays as .mat file. Re-read in as a structure. 
    save panga.mat -struct s

These commands will arrange all data into position and uncertainty matrices, with each row corresponding to a station and each column corresponding to a day. The number of columns spans the full time series, from the first day on which any day was collecting through the last day available in the downloaded files. Zero values are given for days on which no observation was made. Matrices are stored as fields in a MATLAB structure. 
   
