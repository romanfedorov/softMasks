close all;
clear all;
clc;

hexW = 100;
hexH = sqrt(3)/2*hexW;
hexCols = 8;
hexRows = 6;
frameW = round((1+(hexCols-1)*0.75)*hexW);
frameH = round((hexRows + 0.5)*hexH);
frameStartX = 1060 - frameW + 1;
frameStartY = 960 - frameH + 1;

d = dir('./original_shots/*.jpg');

for iOrgShot = 1:length(d)
    orgShotPath = strcat('./original_shots/', d(iOrgShot).name);
    [~, orgShotName] = fileparts(d(iOrgShot).name);
    orgShotImage = im2double(imread(orgShotPath));
    frameImage = orgShotImage(frameStartY:frameStartY+frameH-1, frameStartX:frameStartX+frameW-1, :);
    imwrite(frameImage, strcat('./entire_shots/','image_',orgShotName,'_','.jpg'));
end