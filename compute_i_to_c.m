function [r_i_to_c, t_i_to_c] = compute_i_to_c(r_max_c, t_max_c)

r_i_to_c = 1 ./ r_max_c;
t_i_to_c = 2 .* pi ./ t_max_c;

end

