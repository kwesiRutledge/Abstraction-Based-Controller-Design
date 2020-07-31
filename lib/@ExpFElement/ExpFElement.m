classdef ExpFElement
	%Description:
	%	This class represents elements of the set Exp_F from Algorithm 2 of the paper
	%	from Majumdar, Ozay and Schmuck.
	%
	%Properties:
	%	ExpXElt
	%	u
	%	ExpXEltPrime
	%
	%Methods
	%	- ExpFElement
	%	- eq ( or ==)
	%	- ne ( or ~=)
	%	- find_in_list
	%	- union_with_set

	properties
		ExpXElt;
		u;
		ExpXEltPrime;
	end

	methods
		function efe = ExpFElement( ExpXElt_in , u_in , ExpXEltPrime_in )
			%Description:

			%% Input Processing

			if ~isa(ExpXElt_in,'ExpXElement') 
				error('The first input must be of type ExpXElement!')
			end

			if ~isa(ExpXEltPrime_in,'ExpXElement')
				error('The third input must be of type ExpXElement!')
			end

			%% Algorithm
			efe.ExpXElt = ExpXElt_in;
			efe.u = u_in;
			efe.ExpXEltPrime = ExpXEltPrime_in;

		end

		function tf = eq( obj , comparison_elt )
			%Description:
			%	Compares the two ExpFElement objects.
			%	True if and only if the ExpXElt, u and ExpXEltPrime values are equal.
			%
			%Usage:
			%	tf = (obj == comparison_elt)
			%	tf = obj.eq(comparison_elt)
			%	tf = eq(obj,comparison_elt)

			%% Check Inputs
			if ~isa(comparison_elt,'ExpFElement')
				error('Both arguments being compared must be of class ExpXElement.')
			end

			%% Algorithm

			tf = all(obj.ExpXElt == comparison_elt.ExpXElt) && ...
				(obj.u == comparison_elt.u) && ...
				(obj.ExpXEltPrime == comparison_elt.ExpXEltPrime);

		end

		function tf = ne( obj , comparison_elt )
			%Description:
			%	Compares the two ExpXElement objects.
			%	False if and only if the ExpXElt, u and ExpXEltPrime values are equal.

			%% Check Inputs
			if ~isa(comparison_elt,'ExpFElement')
				error('Both arguments being compared must be of class ExpXElement.')
			end

			%% Algorithm

			tf = ~eq(obj,comparison_elt);

		end

		function elt_idx = find_in_list( obj, ExpFElementList_in)
			%Description:
			%	Finds the index of obj, if it exists in the list of ExpFElement
			%	objects called ExpFElementList_in.
			%	If obj does not exist in the list, then it returns -1.

			%% Constants

			list_length = length(ExpFElementList_in);

			%% Algorithm

			elt_idx = -1;

			for list_idx = 1:list_length
				%Take each element.
				temp_ex_elt = ExpFElementList_in(list_idx);

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

	end
end