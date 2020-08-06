function idcs_out = find_in(list_in,target_elt)
	%Description:
	%	This function searches through the list/array list_in for the
	%	element target_elt.
	%
	%Requirements:
	%	The == operator must be defined for the objects in the list.

	%% Constants

	%% Algorithm
	idcs_out = [];
	for list_idx = 1:length(list_in)
		%Get pu_list_item
		list_item = list_in(list_idx);

		if list_item == target_elt
			idcs_out = [idcs_out,list_idx];
		end

	end

end