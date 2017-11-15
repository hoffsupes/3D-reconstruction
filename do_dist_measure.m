function [L,inliers] = do_dist_measure(C1,C2,thresh)
L = (sqrt( sum(bsxfun(@power,(C1 - C2),2))) < thresh);
inliers = nnz(L);
end