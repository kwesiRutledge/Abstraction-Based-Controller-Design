function [list_out] = change_tuples_in_list( list_in , expx_elt_in , s_in )
	%Description:
	%	Changes all instances of the ExpXElement expx_elt_in in the list list_in
	%	to instances of an ExpXElement ExpXElement( expx_elt_in.v , s_in , expx_elt_in.c )
	%
	%Usage:
	%	list_out = change_tuples_in_list( expx_elt_list_in , expx_elt_in , s_in )
	%	list_out = change_tuples_in_list( expf_elt_list_in , expx_elt_in , s_in )
	%
	%Notes to self:
	%	- Unclear how to change the ExpGammaElement type. Ask for clarification!

	%% Input Processing 
	list_class = class(list_in);

	if ~any( strcmp(list_class,{'ExpGammaElement','ExpFElement','ExpXElement'}) )
		error(['The input list''s class is not of the proper type! Detected class: ' list_class ])
	end

	%% Constants

	%% Algorithm
	list_out = list_in;

	for list_idx = 1:length(list_in)
		list_elt = list_in(list_idx);

		switch list_class
			case 'ExpGammaElement'
				%Slightly unsure of how to do this.
				temp_expg_elt = ExpGammaElement( expx_elt_in );
				if temp_expg_elt == list_elt
					%If the simplified tuple matches, then replace the
					%value of q.
					list_out(list_idx).q = s_in;
				end

			case 'ExpFElement'
				%Check to see if the list element list_elt contains
				%the target expx_elt_in in either its ExpXElt or ExpXEltPrime
				%properties.
				if expx_elt_in == list_elt.ExpXElt
					%If the tuple matches, then replace the value of q.
					list_out(list_idx).ExpXElt.q = s_in;
				end

				if expx_elt_in == list_elt.ExpXEltPrime
					%If the tuple matches, then replace the value of q with s?
					list_out(list_idx).ExpXEltPrime.q = s_in;
				end

			case 'ExpXElement'
				%Check to see if the element matches expx_elt_in
				if expx_elt_in == list_elt
					%If it does, then replace the q value.
					list_out(list_idx).q = s_in;
				end
			otherwise
				error('This class type is not supported by the algorithm!')
		end

	end

end