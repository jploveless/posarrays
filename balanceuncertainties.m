function sta1 = balanceuncertainties(sta1, sta2)
% balanceuncertainties  Balances uncertainties of two sta structures
%   sta1new = balanceuncertainties(sta1, sta2) balances the uncertainty
%   components of station structures sta1 and sta2. The uncertainty 
%   fields sta1.eastSig and sta1.northSig are balanced with the 
%   corresponding fields of sta2 by determining the ratios of the 
%   uncertainties' medians and then multiplying sta1's components
%   by this scaling factor. The scaled uncertainties are returned
%   as fields in structure sta1new.
%

% Make sure toggles are logicals
sta1.tog = logical(sta1.tog);
sta2.tog = logical(sta2.tog);

% Calculate component medians
emed1 = median(sta1.eastSig(sta1.tog));
emed2 = median(sta2.eastSig(sta2.tog));
nmed1 = median(sta1.northSig(sta1.tog));
nmed2 = median(sta2.northSig(sta2.tog));

% Determine scale factors
eastFactor = emed2./emed1;
northFactor = nmed2./nmed1;

% Balance sta1's uncertainties
sta1.eastSig = sta1.eastSig.*eastFactor;
sta1.northSig = sta1.northSig.*northFactor;
