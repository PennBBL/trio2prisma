function tc2adjmat( tc )

[~,subjid,~]=fileparts(tc);
subjid=subjid(1:10);
fprintf('%s\n',subjid);
tc = importdata(tc);
tc = tc.data;
adjmat = corr(tc);
outname = strcat(subjid,'_adjmat.mat');
save(outname,'adjmat');

end

