function getpanga
% getpanga   Download raw PANGA .zip file and unzip

url = 'http://www.panga.cwu.edu/panga/officialresults/archives/panga_raw.zip';
unzip(url)
!cp panga.coords raw/.