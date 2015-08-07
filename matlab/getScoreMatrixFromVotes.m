function scoreMatrix = getScoreMatrixFromVotes (votes, nVotes)

    scoreMatrix = cell(6,8);
    for r = 1:6
        for c = 1:8
            scoreMatrix{r,c} = zeros(15, 15);
        end
    end

    %workersList = loadjson('workers.json');
    sampledVotes = datasample(votes, nVotes, 'Replace', false);
    for i = 1 : size(sampledVotes, 1)
        image1 = sampledVotes(i,1);
        image2 = sampledVotes(i,2);
        row = sampledVotes(i,3);
        col = sampledVotes(i,4);
        answer = sampledVotes(i,5);

        if image1 == image2
            continue;
        end

        if answer == '>'
            scoreMatrix{row, col}(image1, image2) = scoreMatrix{row, col}(image1, image2) + 1;
        end

        if answer == '<'
            scoreMatrix{row, col}(image2, image1) = scoreMatrix{row, col}(image2, image1) + 1;
        end

        if answer == '='
            scoreMatrix{row, col}(image1, image2) = scoreMatrix{row, col}(image1, image2) + 0.5;
            scoreMatrix{row, col}(image2, image1) = scoreMatrix{row, col}(image2, image1) + 0.5;
        end        
    end

end