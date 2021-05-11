function [vel, standev] = midas(pos, time)

%Mean Interannual Difference Adjusted for Skewness (MIDAS) Robust Trend Estimator 

% MIDAS calculates the slope for all pairs of GPS daily position
% observations separated by one year, For each station. Slopes that are
% more than two standard deviations away from the median are removed,
% assuming that the majority of data will fit a normal distribution. The
% output is the median of all the slopes calculated for each station, as
% well as the standard deviation for that station.

% INPUTS: 
% pos is a matrix of all positions for each day, for each station.
% Each row should be a new station, each column is the position on each day.
% 
% time is a matrix of the day corresponding to each correpsonding position
% in pos. Each row is a new station, each column is the day written in
% serial date number form (i.e. the number of days sincs 01-00-0000)
%
% Code by Juliette Saux, based on:
%  Blewitt, G., Kreemer, C., Hammond, W. C., & Gazeaux, J. (2016). 
%  MIDAS robust trend estimator for accurate GPS station velocities 
%  without step detection: MIDAS Trend Estimator for GPS Velocities. 
%  Journal of Geophysical Research: Solid Earth, 121(3), 2054–2068. 
%  https://doi.org/10.1002/2015JB012552

vel = zeros(size(time,1),1); % creates vector to save all slope values
standev = zeros(size(time,1),1);% creates vector to save all standard deviations

for j = 1:size(time,1) %i.e. for each station (the number of rows in input time is the number of stations in the dataset)

    nz = time(j, :) ~= 0;  %logical find all the non zero entries of time
    cortime = time(j, nz); %resave time so that only the one row (station) and all non zero entries are used for each iteration of the loop.
    corpos = pos(j, nz); %resave pos so that only the one row (station) and all non zero entries are used for each iteration of the loop.
   
    slopevector = zeros(length(cortime(1,:)), 2);  % prepare a vector of zeros to save all the slopes and standard deviations (# of rows = # of days; 2 columns, for slop and standard deviation)
   
    
                   
      
    
    for i = 1:length(cortime(1,:))  %For every day that this station was active:

        colday2 = find(cortime(1,:) == (cortime(1, i)+365),1);  %colday2 is the index for the day that is 365 days away from day i.
        leeway = 0;
        
           while ((isempty(find(cortime(1,:) == (cortime(1, i)+365+leeway),1))) == 1)&& (leeway < 37)  % if day i+365 does not exist, keep adding a day until a match is found (until 37 days have been added (10th of a year)).
                leeway = leeway + 1;
                colday2 = (find(cortime(1,:) == (cortime(1, i)+365+leeway),1));
           end
            
           if isempty(colday2) == 0  %Once a matched pair of dates is found, save the slope between the two pairs in the first column of slopevector
                slopevector(i,1) = ((corpos(1, i) - corpos(1, colday2))/((cortime(1,i) - cortime(1, colday2)))*365);
                slopevector(i,2) = (corpos(1,i) - (slopevector(i,1)*cortime(1,i))); 
                       
           else % If no matched pair can be found, save the corresponding entry in slopevector as zero
                slopevector(i,1) = 0;
                slopevector(i,2) = 0; 
           end
    end
    
    
    nz = slopevector(:, 1) ~= 0; %logical argument that finds the location of all nonzero elements of slopevector
    slopevector = slopevector(nz,:); %resaves slope vector so that it removes all the 0s.
    
    slopevector = slopevector((abs(slopevector(:,1) - median(slopevector(:,1))) < 2*std(slopevector(:,1))), :); %Resaves slopevector, but only keeps slopes that are less than two standard deviations away from the median 
    
    if isempty(slopevector) == 1 %If there is nothing in the slopevector (could be a campaign station, or a station that has not been active for very long), than save those values as NaN in final output vectors
          vel(j,1) = NaN;
          standev(j,1) = NaN;
    else
          
        while numel(find(abs(slopevector(:,1) - median(slopevector(:,1))) > 2*std(slopevector(:,1)))) > 1 %Will filter out outliers until there are less than 10 outliers left          
              slopevector = slopevector((abs(slopevector(:,1) - median(slopevector(:,1))) < 2*std(slopevector(:,1))), :); %Resaves slopevector but only saves values that are less than 2 standard deviations away from the median 
        end
    end
    
    
   medslope = median(slopevector(:,1)); %finds the median slope
   vel(j,1) = medslope; %saves the velocity in mm/year to vel vector
   standev(j,1) = 3 * (sqrt(pi/2)*(std(slopevector(:,1))/sqrt( (length(slopevector(:,1)) / 4) ))); %saves the error

   
end

end


     
        