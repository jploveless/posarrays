# posarrays
Matlab utility for reading GPS position files from Japan's GEONET 

After downloading F3 coordinates from GSI, place all yearly directories into a single 'master' directory, then run:

    posarrays('master_directory', 'output.mat')

to save an output file containing 2-dimensional arrays of time series information, including serial date and position. The dimensions of the resulting arrays are nStations-by-nDays, where nStations is the number of unique stations across all years, and nDays is the total number of days on which there is at least one position observation across all years. 
