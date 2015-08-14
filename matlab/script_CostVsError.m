clear;
clc;
close all;

imageIds = [2, 4, 6, 8, 10, 15, 23, 33, 35, 38, 39, 41, 44, 50]';

costs1 = [];
costs2 = [];
errorsAbs1 = [];
errorsSquare1 = [];
errorsAbs2 = [];
errorsSquare2 = [];

votes = load('votes.mat', 'votes');
votes = votes.votes;

votes(votes(:, 1) == votes(:, 2), :) = [];

annotations = load('annotations.mat', 'annotations');
annotations = annotations.annotations;

for i = 1:size(annotations, 1)
    annotations(i, 1) = find(imageIds == annotations(i, 1));
end

goldMasks = getRatingMatrixFromScoreMatrix(getScoreMatrixFromVotes(votes));
%goldMasks = getRatingMatrixFromAnnotations(annotations);

currentVotes = zeros(0, 5);
currentCost = 0;

nVotesPerStep = 100;

while size(votes, 1) > 0
    for iUseless = 1:nVotesPerStep
        if size(votes, 1) == 0
            break;
        end
        size(votes, 1)
        votesPerImage = hist(currentVotes(:,1), 1:15) + hist(currentVotes(:,2), 1:15);
        [~, imageId] = min(votesPerImage);
        votesOfImage = currentVotes(currentVotes(:, 1) == imageId | currentVotes(:, 2) == imageId, :);
        votesOfImageCellInds = sub2ind([6, 8], votesOfImage(:, 3), votesOfImage(:, 4));
        votesPerCellInd = hist(votesOfImageCellInds, 1:6*8);
        [~, cellInd] = min(votesPerCellInd);
        [cellRow, cellCol] = ind2sub([6, 8], cellInd);
        validVoteIds = find( (votes(:, 1) == imageId | votes(:, 2) == imageId) & (votes(:, 3) == cellRow & votes(:, 4) == cellCol));
        if isempty(validVoteIds)
            %actually for now, it means that we are done and few votes are
            %missing (overdue of the required comparisons), for now we will
            %just peak the first of the remaining items
            validVoteIds = 1;
        end
        validVoteId = validVoteIds(1);
        currentVotes = [currentVotes; votes(validVoteId, :)];
        votes(validVoteId, :) = [];

        currentCost = currentCost + 1;
    end
    
    currentMasks = getRatingMatrixFromScoreMatrix(getScoreMatrixFromVotes(currentVotes));
    errorMatrix = [currentMasks{:}] - [goldMasks{:}];
    errorAbs = mean(abs(errorMatrix(:)));
    errorSquare = mean(errorMatrix(:).^2);
    
    costs1 = [costs1; currentCost];
    errorsAbs1 = [errorsAbs1; errorAbs];
    errorsSquare1 = [errorsSquare1; errorSquare];
end

currentAnnotations = zeros(0, 49);
currentCost = 0;

nAnnotationsPerStep = 1;


while size(annotations, 1) > 0
    for iUseless = 1:nAnnotationsPerStep
        size(annotations, 1)
        annotationsPerImage = hist(currentAnnotations(:,1), 1:15);
        [~, imageId] = min(annotationsPerImage);
        validAnnotationIds = find( annotations(:, 1) == imageId );
        if isempty(validAnnotationIds)
            %actually for now, it means that we are done and few votes are
            %missing (overdue of the required comparisons), for now we will
            %just peak the first of the remaining items
            validAnnotationIds = 1;
        end
        validAnnotationId = validAnnotationIds(1);
        currentAnnotations = [currentAnnotations; annotations(validAnnotationId, :)];
        annotations(validAnnotationId, :) = [];

        currentCost = currentCost + 1;
    end
    
    currentMasks = getRatingMatrixFromAnnotations(currentAnnotations);
    errorMatrix = [currentMasks{:}] - [goldMasks{:}];
    errorAbs = mean(abs(errorMatrix(:)));
    errorSquare = mean(errorMatrix(:).^2);
    
    costs2 = [costs2; currentCost];
    errorsAbs2 = [errorsAbs2; errorAbs];
    errorsSquare2 = [errorsSquare2; errorSquare];
end

figure;
hold on;
plot(costs1, errorsAbs1, 'b-');
plot(costs1, errorsSquare1, 'b--');
plot(costs2*100, errorsAbs2, 'r-');
plot(costs2*100, errorsSquare2, 'r--');
hold off;