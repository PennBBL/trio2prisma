function communitypartition(subject)

fprintf('%s',subject);
adjmats = findfiles(pwd,strcat(subject,'*_adjmat.mat'));
partition = zeros(264,4);
zrandmat = zeros(4,4,4);

for i = 1:4
    load(adjmats{i});
    partition(:,i) = community_louvain(threshold_absolute(adjmat,0));
end

for i = 1:4
    for j = 1:4
        a = zeros(4,1);
        [a(1) a(2) a(3) a(4)] = zrand(squeeze(partition(:,i)),squeeze(partition(:,j)));
        zrandmat(i,j,:) = a;
    end
end

outfile = strcat(subject,'_zrand.mat');
save(outfile,'zrandmat');
outfile = strcat(subject,'_partition.mat');
save(outfile,'partition');

end