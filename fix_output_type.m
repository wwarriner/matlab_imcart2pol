function im_out = fix_output_type(im_in, im_out, logical_threshold)
%{
Gives im_out the same type as im_in.
If logical, applies threshold.
%}

t = string(class(im_in));
if t == "logical"
    im_out = im_out > logical_threshold;
else
    im_out = cast(im_out, t);
end

end

