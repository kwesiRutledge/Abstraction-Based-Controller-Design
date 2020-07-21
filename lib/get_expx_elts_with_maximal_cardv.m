function [expx_elts_out] = get_expx_elts_with_maximal_cardv( expx_in )
	%Description:
	%	Searches through the list of elements in expx_in and returns the subset
	%	of elements whose 'v' value has the maximal cardinality (or length).
	%
	%Notes to self:
	%	This function can probably be made more efficient by combining the two
	%	loops.

	%% Constants %%

	%%%%%%%%%%%%%%%
	%% Algorithm %%
	%%%%%%%%%%%%%%%

	%% Find the largest cardinality of v
	maximal_card_v = -1;
	for expx_idx = 1:length(expx_in)
		temp_expx_elt = expx_in( expx_idx );

		if length(temp_expx_elt.v) > maximal_card_v
			maximal_card_v = length(temp_expx_elt.v);
		end
	end

	%% Return all items with the cardinality of maximal_card_v
	expx_elts_out = [];

	for expx_idx = 1:length(expx_in)
		temp_expx_elt = expx_in( expx_idx );

		if length(temp_expx_elt.v) == maximal_card_v
			expx_elts_out = [ expx_elts_out , temp_expx_elt ];
		end
	end


end