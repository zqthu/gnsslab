function outbits = code_ca(xor_idx)
%code_ca - generate C/A signals
%
% Syntax: plot_orbit(reg_num, xor_idx)
%
% INPUT:
%   xor_idx  - index of 2 registers to be xor-ed, default [reg_num-1, reg_num]
%
% OUTPUT:
%   outbits  - list of output bits
%
% EXAMPLE:
%   outbits = code_ca(4, [1, 2])
%

reg_num = 10; % register number of C/A code

if nargin < 1
    xor_idx = [reg_num-1, reg_num];
end

% check xor_idx
if length(xor_idx) ~= 2 || sum(xor_idx <= reg_num) ~= 2
    error("xor_idx input wrong.")
end

reg = [bitshift(1,reg_num) - 1, bitshift(1,reg_num) - 1];
% reg_g1 = bitshift(1,reg_num) - 1; % initialize register G1
% reg_g2 = bitshift(1,reg_num) - 1; % initialize register G2
period = 2^reg_num - 1; % code period

shift = reg_num - [[3, 10], xor_idx]; % shift left number [G1_1, G1_2, G2_1, G2_2]
mask = bitshift([1,1,1,1],shift); % shift left is positive(+) in matlab
outbits = nan(1, period); % allocate output list

for i = 1:period
    head = bitshift(bitand([reg(1),reg(1),reg(2),reg(2)],mask),-shift);
    new_bit = [bitxor(head(1),head(2)), bitxor(head(3),head(4))]; % new bit for [G1, G2]
    outbits(i) = bitxor(bitand(reg(1), 1), bitand(reg(2), 1)); % output bit
    % next tick
    reg(1) = bitset(bitshift(reg(1), -1), reg_num, new_bit(1));
    reg(2) = bitset(bitshift(reg(2), -1), reg_num, new_bit(2));
end

end