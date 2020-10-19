function outbits = code_ca(xor_idx)
%code_ca - generate C/A signals
%
% Syntax: plot_orbit(reg_num, xor_idx)
%
% INPUT:
%   xor_idx  - index of G2i, default [reg_num-1, reg_num]
%
% OUTPUT:
%   outbits  - list of output bits
%
% EXAMPLE:
%   outbits = code_ca(4, [1, 2])
%

reg_num = 10; % register number of C/A code

if nargin < 1
    xor_idx = [reg_num-1, reg_num]; % G2i 
end

% check xor_idx
if length(xor_idx) ~= 2 || sum(xor_idx <= reg_num) ~= 2
    error("xor_idx input wrong.")
end

reg = [bitshift(1,reg_num) - 1, bitshift(1,reg_num) - 1]; % initialize to 0x3ff for both register (G1 and G2)
period = 2^reg_num - 1; % code period, default 1023

xor_idx1 = reg_num - [3, 10] + 1; % G1 heads index
xor_idx2 = reg_num - [2, 3, 6, 8, 9, 10] + 1; % G2 heads index
outbits = nan(1, period); % allocate output list

for i = 1:period
    head1 = seq_xor(bitget(reg(1),xor_idx1));
    head2 = seq_xor(bitget(reg(2),xor_idx2));
    new_bit = [head1, head2]; % new bit for [G1, G2]
    % output
    g2i = seq_xor(bitget(reg(2),xor_idx)); % G2i output
    outbits(i) = bitxor(bitand(reg(1), 1), g2i); % output bit
    % next tick
    reg(1) = bitset(bitshift(reg(1), -1), reg_num, new_bit(1));
    reg(2) = bitset(bitshift(reg(2), -1), reg_num, new_bit(2));
end

end

function bit = seq_xor(seq)
% sequential xor
bit = bitxor(seq(1),seq(2));
for i = 3:length(seq)
    bit = bitxor(bit,seq(i));
end
end