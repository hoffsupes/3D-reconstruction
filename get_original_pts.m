function [zpk,zpk2] = get_original_pts(LI,Lpts,matches,padr,WL,WR,cl,cr,Pl,Pr)

calc_lpts = [Lpts(:,2)-padr Lpts(:,1)-padr ones(length(Lpts),1)]';
zpk = inv(WL)*calc_lpts;
zpk = zpk ./ zpk(3,:);
zpk(3,:) = [];
zpk = round(zpk)';

calc_rpts = [matches(:,2)-padr matches(:,1)-padr ones(length(matches),1)]';
zpk2 = inv(WR)*calc_rpts;
zpk2 = zpk2 ./ zpk2(3,:);
zpk2(3,:) = [];
zpk2 = round(zpk2)';



end