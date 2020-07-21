classdef ExpGammaElement
	%Description:
	%	A 2-tuple of elements where the first item is the subset of the state space and the second item is also a subset of the state space.

	properties
		q;
		c;
	end

	methods
		function elt = ExpGammaElement( varargin )
			%Description:
			%
			%Usage:
			%	elt_out = ExpGammaElement( q_in , c_in )
			%	elt_out = ExpGammaElement( exp_x_elt_in )

			%% Input Processing %%
			if isa(varargin{1},'ExpXElement')
				input_type = 'ExpXElement';
			elseif isnumeric(varargin{1})
				input_type = 'Numeric';
			else
				error('Unexpected input type to ExpGammaElement()!')
			end

			%% Algorithm %%

			switch input_type
				case 'ExpXElement'
					exp_x_elt_in = varargin{1};

					elt.q = exp_x_elt_in.q;
					elt.c = exp_x_elt_in.c;
				case 'Numeric'
					q_in = varargin{1};
					c_in = varargin{2};

					elt.q = q_in;
					elt.c = c_in;
				otherwise
					error('Unrecognized input type.')
			end
		end

		function tf = eq( obj , comparison_elt )
			%Description:
			%	Compares the two ExpGammaElement objects.
			%	True if and only if the q and c values are equal.
			%
			%Usage:
			%	tf = (obj == comparison_elt)
			%	tf = obj.eq(comparison_elt)
			%	tf = eq(obj,comparison_elt)

			%% Check Inputs
			if ~isa(comparison_elt,'ExpGammaElement')
				error('Both arguments being compared must be of class ExpGammaElement.')
			end

			%% Algorithm

			tf = (obj.q == comparison_elt.q) && (obj.c == comparison_elt.c);

		end

		function tf = ne( obj , comparison_elt )
			%Description:
			%	Compares the two ExpGammaElement objects.
			%	True if and only if the q and c values are equal.

			%% Check Inputs
			if ~isa(comparison_elt,'ExpGammaElement')
				error('Both arguments being compared must be of class ExpGammaElement.')
			end

			%% Algorithm

			tf = ~eq(obj,comparison_elt);

		end

		function elt_idx = find_in_list( obj , ExpGammaElementList_in )
			%Description:
			%	Returns the index of current object if there is an exact
			%	match in the list ExpGammaElementList_in.
			%	If there is not a match in the list, then this returns -1.
			%

			%% Constants

			list_length = length(ExpGammaElementList_in);

			%% Algorithm

			elt_idx = -1;

			for list_idx = 1:list_length
				%Take each element.
				temp_eg_elt = ExpGammaElementList_in(list_idx);

				%Compare it with the object.
				if obj == temp_eg_elt
					elt_idx = list_idx;
				end
			end


		end

	end

end