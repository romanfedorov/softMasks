clear;

load('votes');

fullScoreMatrix = getScoreMatrixFromVotes(votes, size(votes,1));
fullRatingMatrix = getRatingMatrixFromScoreMatrix(fullScoreMatrix);

errorsTotal = [];

nVotesArray = [1000:100:size(votes,1)];
for i = 1:20
    errors = [];
    for nVotes = nVotesArray
        scoreMatrix = getScoreMatrixFromVotes(votes, nVotes);
        ratingMatrix = getRatingMatrixFromScoreMatrix(scoreMatrix);
        singleErros = cat(1, ratingMatrix{:}) - cat(1, fullRatingMatrix{:});
        singleErros = abs(singleErros);
        errors = [errors mean(singleErros(:))];
    end
    errorsTotal = [errorsTotal; errors];
end
