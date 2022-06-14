function [F_res, S_min] = find_F_res(Sparam, F_low, F_high)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    F_low_index = min(find(Sparam.Frequencies > F_low));
    F_high_index = max(find(Sparam.Frequencies < F_high));
    F_select = Sparam.Frequencies(F_low_index:F_high_index);
    S_select = abs(Sparam.Parameters(F_low_index:F_high_index));
    S_select = 20*log10(S_select);
    S_min = min(S_select);
    F_res = F_select(find(S_select == S_min));
end

