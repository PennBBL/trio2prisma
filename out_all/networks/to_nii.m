% this script doesn't work -- mv not in MATLAB -- but can be run piecewise
% for the same effect

hdr = spm_vol('/import/monstrum2/Users/rastko/rewardTemplate.nii');

a = findfiles('hup6/BBL','*_adjmat.mat');
numfile = numel(a);
for i = 1:numfile
    load(a{i});
    hdr.fname = strcat(a{i}(end-20:end-4),'.nii');
    hdr.dim = [264 264 1];
    spm_write_vol(hdr,adjmat);
end

mv *adjmat.nii hup6/BBL

a = findfiles('hup6/HCP','*_adjmat.mat');
numfile = numel(a);
for i = 1:numfile
    load(a{i});
    hdr.fname = strcat(a{i}(end-20:end-4),'.nii');
    hdr.dim = [264 264 1];
    spm_write_vol(hdr,adjmat);
end

mv *adjmat.nii hup6/HCP

a = findfiles('prisma/BBL','*_adjmat.mat');
numfile = numel(a);
for i = 1:numfile
    load(a{i});
    hdr.fname = strcat(a{i}(end-20:end-4),'.nii');
    hdr.dim = [264 264 1];
    spm_write_vol(hdr,adjmat);
end

mv *adjmat.nii prisma/BBL

a = findfiles('prisma/HCP','*_adjmat.mat');
numfile = numel(a);
for i = 1:numfile
    load(a{i});
    hdr.fname = strcat(a{i}(end-20:end-4),'.nii');
    hdr.dim = [264 264 1];
    spm_write_vol(hdr,adjmat);
end

mv *adjmat.nii prisma/HCP