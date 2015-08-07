function ratingMatrix = getRatingMatrixFromScoreMatrix (scoreMatrix)
    ratingMatrix = cell(15, 1);
    for i = 1:15
        ratingMatrix{i} = zeros(6, 8);
    end

    for row = 1 : 6
        for col = 1 : 8
            singlePatchScoreMatrix = scoreMatrix{row, col};
            singlePatchScoreMatrixFix = fix_counts(singlePatchScoreMatrix);
            ratings = scale_ls(singlePatchScoreMatrixFix + realmin);
            if max(ratings)-min(ratings) > 0
                ratings = (ratings - min(ratings))./(max(ratings)-min(ratings));
            else
                ratings = ones(1, 15) * 0.5;
            end
            for i = 1:15
                ratingMatrix{i}(row, col) = ratings(i);
            end
        end
    end
    
end

%     hexW = 100;
%     hexH = sqrt(3)/2*hexW;
%     hexCols = 8;
%     hexRows = 6;
%     frameW = round((1+(hexCols-1)*0.75)*hexW);
%     frameH = round((hexRows + 0.5)*hexH);
% 
%     reducedFrameW = 0.5 * frameW;
%     reducedFrameH = 0.5 * frameH;
% 
%     frameStartX = 1060 - frameW + 1;
%     frameStartY = 960 - frameH + 1;
% 
%     hexCenterX = [];
%     hexCenterY = [];
%     for col = 1:hexCols
%         for row = 1:hexRows
%             hexCenterX = [hexCenterX; (0.5 + (col - 1)*0.75)*hexW];
%             hexCenterY = [hexCenterY; (0.5 + mod(col+1,2)*0.5 + (row - 1))*hexH];
%         end
%     end
%     %[xmesh ymesh] = meshgrid(hexCenterX, hexCenterY);
% 
%     for i = 1:15
%         figure;
%         subplot(1,2,1);
%         im = imread(strcat('./original_shots/',num2str(imageIds(i)),'.jpg'));
%         im = im(frameStartY:frameStartY+frameH-1, frameStartX:frameStartX+frameW-1, :);
%         imshow(im);
%         %subplot(1,3,2);
%         %imshow(ratingMatrix{i});
%         subplot(1,2,2);
%         [xi,yi] = meshgrid(1:size(im,2), 1:size(im,1));
%         %x = [hexCenterX; 0; size(im,2); size(im,2); 0];
%         %y = [hexCenterY; 0; 0; size(im,1); size(im,1)];
%         %z = [ratingMatrix{i}(:); ratingMatrix{i}(1,1); ratingMatrix{i}(1,8); ratingMatrix{i}(6,8); ratingMatrix{i}(6,1)];
%         x = [hexCenterX];
%         y = [hexCenterY];
%         z = [ratingMatrix{i}(:)];
%         zi = griddata(x,y,z,xi,yi, 'natural');
%         imshow(zi);
%         set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     end