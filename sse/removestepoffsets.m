function [opos, otime] = removestepoffsets(s, n, comp)
% REMOVESTEPOFFSETS corrects any known offsets in times series (because of maintainance
% etc...) Offest correction usually happens after SSEs have been removed
% from the dataset.
% 
% This function uses a logical array cataloguing offsets to correct any discrepancies
% in the timeseries that could hinder future calculations of station velocity. East 
% and north positions must be analyzed separately by calling the function twice.
% 
% Inputs:
% s: Raw time series, structure or .mat filename
% n: Time series with SSEs removed (from removesse.m), structure or .mat filename
% comp: Component (1 for east, 2 for north)
%
%   Code by Juliette Saux

if ~isstruct(s)
   s = load(s);
end
if ~isstruct(n)
   n = load(n);
end

if strcmp(comp, 'east') == 1;
    pos = n.eastpos;
end

if strcmp(comp, 'north') == 1;
    pos = n.northpos;
end

disp = s.offs;

time = n.date;

opos = zeros(size(pos));
otime = zeros(size(time));


for j = 1:size(time,1) %loops through each station

    nz = time(j, :) ~= 0;  %logical find all the non zero entries of time (only days where the station was online)
    cortime = time(j, nz); %resave time so that only one station is analysed at a time, and only nonzero values are used
    corpos = pos(j, nz); % does the same as above, but with position
    offs = disp(j,nz);% does the same as above, but with offsets
    offs = offs - min(offs); % correct so that minimum offset counter is 0
   
            numoffsets = unique(offs);
            k = length(numoffsets)-1; % finds the number of total offsets for this station(removes the zero)

    
            for i = 1:k  %loops through each offset
                
                displacement = 0;
                 x = find(offs(1,:) == i); %finds all the days that felt that offset (and only that offset).
               
                    if isempty(x) == 0;
                        leeway = 1;
                        
                                while corpos(1, x(1) - leeway) == 0; %find the first nonzero day before the offset
                                     leeway = leeway+1;
                                end
                         waylee = 1;
                                while corpos(1, x(1) + waylee) == 0;%find the first nonzero day after the offset
                                      waylee = waylee+1;
                                end
                                
                                for i = 1:13;
                                    num_days= 1;
                                    pos_before = corpos(1, x(1) - leeway);
                                    if (x(1) - (leeway+i)) > 0;
                                        if isempty(corpos(1, x(1) - (leeway+i))) == 0;
                                            pos_before = pos_before + corpos(1, x(1) - (leeway+i));
                                            num_days = num_days + 1;
                                        end
                                        pos_before = pos_before / num_days;
                                    end
                                end
                                
                                for i = 1:13;
                                    num_days= 1;
                                    pos_after = corpos(1, x(1) + waylee);
                                    if (x(1) + (waylee+i)) < length(corpos(1,:)) ;
                                        if isempty(corpos(1, x(1) + (waylee+i))) == 0;
                                            pos_after = pos_after + corpos(1, x(1) + (waylee+i));
                                            num_days = num_days + 1;
                                        end
                                        pos_after = pos_after / num_days;
                                    end
                                end
                                
                                displacement =  pos_before - pos_after;% finds the difference in position between the day before and the day after the offset. 
              
                        corpos(1, (cortime(1,:) >= cortime(1,(x(1)-leeway)))) = (corpos(1, (cortime(1,:) >= cortime(1,(x(1)-leeway)))) + displacement); % any day after the first offset gets corrected with the displacement found in line 50.
                    end
            end
            
            
            counter = 1;
            for i = 1:length(nz)
                if nz(i) == 0  %essentially reinserts all the zeros into both the position and the time matrices to maintin the a uniform size.
                    opos(j,i) = 0;
                    otime(j,i) = 0;
                    
                else
                    otime(j,i) = cortime(counter);
                    opos(j,i) = corpos(counter);
                    counter = counter +1;
                end
            end   


end

end