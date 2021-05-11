function [ nosse ] = removesse(s)
%removesse locates dates when SSEs occured within the time series, removes position data
%from those days and corrects any ensuing offsets.
%   nosse = removesse(s) iteratively analyses each station's positions
%   in an array and an finds the SSEs felt by that station. For each day
%   that was part of an SSE, those positions are deleted. Each subsequent
%   position is corrected using the displacement corresponding to each SSE.
%
%   The position data and SSE detections are given in structure s, as 
%   returned from detectsse.m, with necessary fields:
%
%   sde: east position for each station on each day (nStation-by-nDays)
%   sdn: north position for each station on each day (nStation-by-nDays)
%   sdate: catalogue of each day the station was online (nStation-by-nDays)
%   eastVel: east displacement for each SSE in catalogue (nStation-by-nEvents)
%   northVel: north velocity for each SSE in catalogue (nStation-by-nDays)
%   sselogical: logical of all days of detected SSEs (nStation-by-nDays)
%   eventdate: station-specific start dates of each event (nStation-by-nEvents)
%   durationsse: duration of all detected events for each station (nStation-by-nEvents)
%
%   The corrected position time series are returned to structure nosse, as fields
%   eastpos and northpos. 
%
%   nosse = removesse(file) creates structure s by reading the variables saved in
%   the specified filename. 
%
%   Code by Juliette Saux

if ischar(s)
   s = load(s);
end

eastpos =  s.sde;
northpos = s.sdn;
posdate = s.date; 
eastVel = s.eastVel;
northVel = s.northVel;
sselogical = s.sselogical;
eventdate = s.listsse;
durationsse = s.durationsse;
                    
                    
a = size(posdate,1); % gives number of stations
b = size(posdate,2); % gives number of days

nosse.eastpos = zeros(a,b);
nosse.northpos = zeros(a,b);
nosse.date = zeros(a,b);
nosse.SSEstart = zeros(a,b);
nosse.SSEnum = zeros(a,1);


for i = 1:size(posdate,1); % goes through each station and "corrects" the east and north position data
  
    
    epos = eastpos(i,:); %save only the east positions for station i
    npos = northpos(i,:); %save only the north positions for station i
    date = posdate(i,:); %save only the days for station i
    sse = find(sselogical(i,:)); %finds indices of all days in which an SSE event was detected
    epos(sse) = 0; % sets all east postions data from SSEs to 0
    npos(sse) = 0; % sets all north postions data from SSEs to 0
    date(sse) = 0; % sets all days in which SSEs were felt to 0
    
    
    startdate = eventdate(i,:); %saves only the start days of events felt by station i 
    [startdate, idx] = unique(startdate); %uses only unique start days and saves their location in idx
    duration = durationsse(i,idx); %saves only corresponding duration of unique SSEs
    for j = 1:(length(startdate(1,:))-1)  
        if (startdate(1,j) + duration(1,j)) >= startdate(1, j+1) % deletes any SSE startdates that are "inside" of another SSE duration (prevents overcorrecting of data)
            startdate(1, j+1) = 0; 
        end
    end
    
    nz = startdate ~=0; %finds and saves nonzero values of startdates, so finds the real start days of SSEs 
    startdate = startdate(1,nz);
    if ~isempty(startdate) % If there are any SSEs felt at this station,
       date(date < startdate(1)) = 0; % Set dates prior to the first SSE to zero
    end
    eastdisp = eastVel(i,idx);%saves SSE velocities corresponding to the unique SSEs in line 51.
    eastdisp = eastdisp(1,nz); %saves displacement values that have corresponding start days for station i (line 59)
    northdisp = northVel(i,idx); %does the same but for north displacement
    northdisp = northdisp(1,nz);

  
        for k = 1:length(startdate(1,:))
 
                epos(1,(date(1,:) > startdate(1,k))) = (epos(1, (date(1,:) > startdate(1,k))) - eastdisp(1,k)); %all days after SSE startdate are corrected with east displacement (from eastVel)
                npos(1,(date(1,:) > startdate(1,k))) = (npos(1, (date(1,:) > startdate(1,k))) - northdisp(1,k)); %all days after SSE startdate are corrected with north displacement (from northVel)

          
        end
  
  % save the new positions (east and north), days,

 nosse.eastpos(i,:) = epos(1,:);
 nosse.northpos(i,:) = npos(1,:);
 nosse.date(i,:) = date(1,:);
 nosse.SSEstart(i,1:length(startdate)) = startdate; %saves the stardate of each event felt for each station
 nosse.SSEnum(i,1) = length(startdate);%saves the number of events felt by each station.
        
end



nosse.SSEstart(:,max(nosse.SSEnum)+1 :end)=[];%deletes the zeros at the end of  the stardate list


end



     
 
