function ratingMatrix = getRatingMatrixFromAnnotations (annotations)
    ratingMatrix = cell(14, 1);
    for i = 1:14
        imageAnnotations = annotations(annotations(:,1) == i, :);
        cellVals = mean(imageAnnotations(:, 2:end), 1);
        cellVals(isnan(cellVals)) = 0.5;
        ratingMatrix{i} = reshape(cellVals, [8, 6])';
    end
end