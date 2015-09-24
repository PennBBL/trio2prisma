allmat = findfiles(pwd,'*_gmd');
allgmd = [];
nummat = numel(allmat);
for i = 1:nummat
    
    allgmd = cat(3,allgmd, importdata(allmat{i}));
    
end

meangmd = mean(allgmd,3);
stdgmd = std(allgmd,0,3);