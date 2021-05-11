function [name, refe, refn] = readpangacoords(file)

fid = fopen(file);
c = textscan(fid, '%s %f %f\n');
fclose(fid);

name = char(c{1});
refe = wrapTo360(c{3});
refn = c{2};
