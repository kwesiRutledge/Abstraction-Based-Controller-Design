function match_idx = find_PolyUnion_in(pu_in, pu_list_in)
	%Description:
	%	Finds the index of pu_in if it exists in pu_list_in.
	%	IF it doesn't exist, then return -1.

	%% Constants

	%% Algorithm
	match_idx = -1;
	for pu_list_idx = 1:length(pu_list_in)
		%Get pu_list_item
		pu_list_item = pu_list_in(pu_list_idx);

		if pu_list_item == pu_in
			match_idx = pu_list_idx;
		end

	end

end