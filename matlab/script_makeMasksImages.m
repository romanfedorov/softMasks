close all;
clear all;
clc;

hexW = 100;
hexH = sqrt(3)/2*hexW;
hexCols = 8;
hexRows = 6;
frameW = round((1+(hexCols-1)*0.75)*hexW);
frameH = round((hexRows + 0.5)*hexH);

reducedFrameW = 0.5 * frameW;
reducedFrameH = 0.5 * frameH;

frameStartX = 1060 - frameW + 1;
frameStartY = 960 - frameH + 1;

d = dir('./original_shots/*.jpg');

for iOrgShot = 1:length(d)
    orgShotPath = strcat('./original_shots/', d(iOrgShot).name);
    [~, orgShotName] = fileparts(d(iOrgShot).name);
    orgShotImage = im2double(imread(orgShotPath));
    for row = 1:hexRows
        for col = 1:hexCols
            hexCenterX = (0.5 + (col - 1)*0.75)*hexW;
            hexCenterY = (0.5 + mod(col+1,2)*0.5 + (row - 1))*hexH;
            m = poly2mask(...
                [hexCenterX-0.5*hexW,hexCenterX-0.25*hexW,hexCenterX+0.25*hexW,hexCenterX+0.5*hexW,hexCenterX+0.25*hexW,hexCenterX-0.25*hexW,hexCenterX-0.5*hexW],...
                [hexCenterY,hexCenterY-0.5*hexH,hexCenterY-0.5*hexH,hexCenterY,hexCenterY+0.5*hexH,hexCenterY+0.5*hexH,hexCenterY],...
                frameH, frameW);
            kInternal = 0.9;
            mInternal = poly2mask(...
                [hexCenterX-0.5*hexW*kInternal,hexCenterX-0.25*hexW*kInternal,hexCenterX+0.25*hexW*kInternal,hexCenterX+0.5*hexW*kInternal,hexCenterX+0.25*hexW*kInternal,hexCenterX-0.25*hexW*kInternal,hexCenterX-0.5*hexW*kInternal],...
                [hexCenterY,hexCenterY-0.5*hexH*kInternal,hexCenterY-0.5*hexH*kInternal,hexCenterY,hexCenterY+0.5*hexH*kInternal,hexCenterY+0.5*hexH*kInternal,hexCenterY],...
                frameH, frameW);
            mBorder = xor(m, mInternal);
            mInv = ~m;
            frameImage = orgShotImage(frameStartY:frameStartY+frameH-1, frameStartX:frameStartX+frameW-1, :);
            frameImage([mInv(:),mInv(:),mInv(:)]) = frameImage([mInv(:),mInv(:),mInv(:)])*0.5;
            frameImage([mBorder(:),logical(zeros(length(mBorder(:)),1)),mBorder(:)]) = 0;
            frameImage([logical(zeros(length(mBorder(:)),1)),mBorder(:),logical(zeros(length(mBorder(:)),1))]) = 1;
            
            %reducedFrameCenterX = hexCenterX;
            %reducedFrameCenterX = max(reducedFrameCenterX, reducedFrameW/2 + 1);
            %reducedFrameCenterX = min(reducedFrameCenterX, frameW-reducedFrameW/2 - 1);
            %reducedFrameCenterY = hexCenterY;
            %reducedFrameCenterY = max(reducedFrameCenterY, reducedFrameH/2 + 1);
            %reducedFrameCenterY = min(reducedFrameCenterY, frameH-reducedFrameH/2 - 1);
            %reducedFrameImage = frameImage(ceil(reducedFrameCenterY-reducedFrameH/2):ceil(reducedFrameCenterY+reducedFrameH/2),floor(reducedFrameCenterX-reducedFrameW/2):floor(reducedFrameCenterX+reducedFrameW/2),:);
            
            paddedFrameImage = padarray(frameImage, round([reducedFrameH reducedFrameW]), 1);
            reducedFrameImage = paddedFrameImage(ceil(hexCenterY+reducedFrameH-reducedFrameH/2):ceil(hexCenterY+reducedFrameH+reducedFrameH/2),floor(hexCenterX+reducedFrameW-reducedFrameW/2):floor(hexCenterX+reducedFrameW+reducedFrameW/2),:);
            
            imwrite(reducedFrameImage, strcat('./shots/','shot_',orgShotName,'_',num2str(col),'_',num2str(row),'_','.jpg'));
        end
    end
end