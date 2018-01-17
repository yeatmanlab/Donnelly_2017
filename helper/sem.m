function [ y ] = sem( x )
% Calculates standard error for input array
%   

y = std(x) / sqrt(numel(x));



end

