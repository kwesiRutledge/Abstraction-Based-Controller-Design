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

			if length(obj.v) ~= length(comparison_elt.v)
				%If the external behaviors observed are of different lengths,
				%then these two behaviors/ExpXElements are at
				%different times and cannot be equal.
				tf = false;
				return;
			end	

			tf = all(obj.v == comparison_elt.v) && ...
				(obj.q == comparison_elt.q) && ...
				(obj.c == comparison_elt.c);

		end

		function tf = ne( obj , comparison_elt )
			%Description:
			%	Compares the two ExpXElement objects.
			%	False if and only if the q and c values are equal.

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

		function set_output = union_with_set( obj , ExpXElementList_in )
			%Description:
			%	Performs the set union of the element obj with the set defined
			%	by ExpXElementList_in.
			%


			%% Algorithm

			%If obj is not already in the list, then add it.
			if obj.find_in_list( ExpXElementList_in ) == -1
				set_output = [ExpXElementList_in,obj];
			else
				set_output = ExpXElementList_in;
			end

		end

		function post_Q = get_PostQ_u( obj , EXP_F_in , num_U )
			%Description:
			%	Computes each set PostQ_u for each u as defined in Algorithm 2's REFINE
			%	algorithm.
			%	It is the set of cover elements such that from the current ExpXElement
			%	one can reach the cover element q.
			%
			%Outputs
			%	post_Q - A cell array of arrays of Polyhedron() objects.
			%
			%Note to self:
			%	- It is possible that this function will create duplicate elements
			%	  in the output.

			%% Constants

			% post_Q = [];
			%type_of_q = class(obj.q);

			%% Algorithm

			switch class(obj.q) 
				case 'Polyhedron'
					for u = 1:num_U
						%u is given.				
						temp_post_Q_u = [];

						for expf_idx = 1:length(EXP_F_in)
							temp_expf_elt = EXP_F_in(expf_idx);

							if (temp_expf_elt.ExpXElt == obj) && (temp_expf_elt.u == u)
								temp_post_Q_u = [temp_post_Q_u, temp_expf_elt.ExpXEltPrime.q];
							end
						end

						%Append to array post_Q
						if isempty(temp_post_Q_u)
							post_Q{u} = temp_post_Q_u;
						else
							post_Q{u} = PolyUnion(temp_post_Q_u);
						end

					end
				case 'PolyUnion'
					for u = 1:num_U
						%u is given.				
						temp_post_Q_u = [];

						for expf_idx = 1:length(EXP_F_in)
							temp_expf_elt = EXP_F_in(expf_idx);

							if (temp_expf_elt.ExpXElt == obj) && (temp_expf_elt.u == u)
								temp_post_Q_u = [temp_post_Q_u, temp_expf_elt.ExpXEltPrime.q.Set];
							end
						end

						%Append to array post_Q
						if isempty(temp_post_Q_u)
							post_Q{u} = temp_post_Q_u;
						else
							temp_union = PolyUnion(temp_post_Q_u);
							temp_union.reduce();
							post_Q{u} = temp_union;
						end

					end
				otherwise
					error('Unexpected class of obj.q. Expecting Polyhedron or PolyUnion ')
			end
			

		end

	end

end