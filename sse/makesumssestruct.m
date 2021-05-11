function st = makesumssestruct(sse, mindate)
% makesumssestruct   Makes cumulative SSE displacement (velocity) structure.
%   st = makesumssestruct(sse) uses the input sse structure, as returned from
%   detectsse.m, to make a cumulative slow slip event velocity structure, 
%   suitable for use in constraining slip using triinvx.m. Station displacements
%   are summed across all events, and normalized by the station time series
%   duration to express average SSE velocities.
%
%   st = makesumssestruct(sse, mindate) sums displacements since mindate, which
%   is a scalar datenum giving the earliest date to be considered. Displacements
%   due to SSEs occurring after this date are summed and normalized by durations
%   since this date. 
%

% Full list of datenums
fulldate = max(sse.date);

% If no minimum cutoff date was specified, set mindate to the first day of any time series
if ~exist('mindate', 'var')
   mindate = fulldate(1);
end

% Construct structure
st.lon = sse.lon; st.lat = sse.lat; % Station locations

% Time series durations
% Durations are since the specified minimum date
mindidx = mindate - fulldate(1) + 1; % Column index of mindate
st.duration = sum(sse.date(:, mindidx:end) ~= 0, 2); 

% Cumulative velocities and uncertainties, in mm/yr

firstevent = find(sse.daterange(:, 1) >= mindate, 1); % Find index of first SSE after mindate

% Sum east and north displacement components, from mindate onward
st.eastVel = sum(sse.eastVel(:, firstevent:end), 2)./st.duration*365.25;
st.northVel = sum(sse.northVel(:, firstevent:end), 2)./st.duration*365.25;
st.eastSig = sum(sse.eastSig(:, firstevent:end), 2)./st.duration*365.25;
st.northSig = sum(sse.northSig(:, firstevent:end), 2)./st.duration*365.25;
