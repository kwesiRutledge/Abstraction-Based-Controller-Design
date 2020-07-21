classdef ExpXElement
	%Description:
	%	Represents the tuples that are elements of the EXP_X array.

	properties
		v;
		q;
		c;
	end

	methods
		function elt = ExpXElement( v_in , q_in , c_in )
			%Description:
			%	Constructor which accepts the values of:
			%	- v
			%	- q
			%	- c
			%	to define the element (v,q,c).

			%% Constants %%

			%% Algorithm %%

			elt.v = v_in;
			elt.q = q_in;
			elt.c = c_in;

		end

		function tf = eq( obj , comparison_elt )
			%Description:
			%	Compares the two ExpXElement objects.
			%	True if and only if the v, q and c values are equal.
			%
			%Usage:
			%	tf = (obj == comparison_elt)
			%	tf = obj.eq(comparison_elt)
			%	tf = eq(obj,comparison_elt)

			%% Check Inputs
			if ~isa(comparison_elt,'ExpXElement')
				error('Both arguments being compared must be of class ExpXElement.')
			end

			%% Algorithm

			tf = all(obj.v == comparison_elt.v) && ...
				(obj.q == comparison_elt.q) && ...
				(obj.c == comparison_elt.c);

		end

		function tf = ne( obj , comparison_elt )
			%Description:
			%	Compares the two ExpXElement objects.
			%	True if and only if the q and c values are equal.

			%% Check Inputs
			if ~isa(comparison_elt,'ExpXElement')
				error('Both arguments being compared must be of class ExpXElement.')
			end

			%% Algorithm

			tf = ~eq(obj,comparison_elt);

		end

		function elt_idx = find_in_list( obj , ExpXElementList_in )
			%Description:
			%	Returns the index of current object if there is an exact
			%	match in the list ExpXElementList_in.
			%	If there is not a match in the list, then this returns -1.
			%

			%% Constants

			list_length = length(ExpXElementList_in);

			%% Algorithm

			elt_idx = -1;

			for list_idx = 1:list_length
				%Take each element.
				temp_ex_elt = ExpXElementList_in(list_idx);

				%Compare it with the object.
				if obj == temp_ex_elt
					elt_idx = list_idx;
				end
			end


		end

	end

end