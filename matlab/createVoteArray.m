imageIds = [0, 2, 4, 6, 8, 10, 15, 23, 33, 35, 38, 39, 41, 44, 50];

votes = zeros(0,5); %image1, image2, row, col, vote

workersList = loadjson('workers.json');
for iWorker = 1 : length(workersList)
    worker = workersList{iWorker};
    for iContrib = 1 : length(worker.contributions)
        contrib = worker.contributions{iContrib};
        contribParams = strsplit(contrib.compairId, '_');
        image1 = find(imageIds == str2num(contribParams{2}));
        image2 = find(imageIds == str2num(contribParams{3}));
        col = str2num(contribParams{4});
        row = str2num(contribParams{5});
        votes(size(votes,1) + 1, :) = [image1, image2, row, col, contrib.answer];
    end
end

save('votes.mat', 'votes');