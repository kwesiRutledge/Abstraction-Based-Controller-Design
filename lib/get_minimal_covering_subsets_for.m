function Q_prime = get_minimal_covering_subsets_for( set_in , cover_in )
	%Description:
	%	This function considers all of the elements in cover_in and finds those which
	%	- contain the set set_in, and
	%	- are minimal (which I guess means that it is not contained by another set in cover_in)
	%	Note that there are helper functions included in this file. Please refer to them to see how 
	%	the algorithm works for specific types of inputs.
	%
	%Assumptions:
	%	- cover_in is an array of Polyhedron() objects.
	%	- set_in is a Polyhedron() object.

	%% Input Processing

	set_class = class(set_in);
	cover_class = class(cover_in);

	if ~strcmp(set_class,cover_class)
		error(['Set class is "' set_class '" while the cover class is "' cover_class '".' ])
	end


	switch set_class
		case 'Polyhedron'
			Q_prime = get_minimal_covering_subsets_for_polyhedron( set_in , cover_in );
		case 'PolyUnion'
			%Assumes that both set_in and cover_in are given as PolyUnion objects.
			Q_prime = get_minimal_covering_subsets_for_polyunion( set_in , cover_in );
		otherwise
			error('This function is currently designed to be used with MPT3''s Polyhedron or PolyUnion objects.')
	end

end

function Q_prime = get_minimal_covering_subsets_for_polyhedron( set_in , cover_in )
	%Description:
	%	This function considers all of the elements in cover_in and finds those which
	%	- contain the set set_in, and
	%	- are minimal (which I guess means that it is not contained by another set in cover_in)
	%
	%Assumptions:
	%	- cover_in is an array of Polyhedron() objects.
	%	- set_in is a Polyhedron() object.


	%% Input Processing

	%Don't need to check input.

	%% Algorithm

	cover_elts_that_contain = [];
	cover_elt_idcs_that_contain = [];

	for cover_idx = 1:length(cover_in)
		cover_elt = cover_in(cover_idx);

		if set_in <= cover_elt 
			cover_elts_that_contain = [ cover_elts_that_contain , cover_elt ];
			cover_elt_idcs_that_contain = [ cover_elt_idcs_that_contain , cover_idx ];
		end

	end

	%disp(['length(cover_elts_that_contain) = ' num2str(length(cover_elts_that_contain))])

	%Check that each element in cover_elts is 'minimal'
	Q_prime = [];

	for Q_prime_candidate_idx1 = 1:length(cover_elts_that_contain)
		Q_prime_candidate1 = cover_elts_that_contain(Q_prime_candidate_idx1);

		%Check whether or not the candidate is contained by another set
		%in the set of candidates.
		candidate1_is_superset_of_another = false;
		for Q_prime_candidate_idx2 = 1:length(cover_elts_that_contain)
			%One Polyhedron always contains itself.
			if Q_prime_candidate_idx1 == Q_prime_candidate_idx2
				continue;
			end

			%Check to see if Q_prime_candidate1 contains Q_prime_candidate2
			Q_prime_candidate2 = cover_elts_that_contain(Q_prime_candidate_idx2);

			candidate1_is_superset_of_another = ...
				candidate1_is_superset_of_another || (Q_prime_candidate2 <= Q_prime_candidate1); %Q'2 contained by Q'1

			% if (Q_prime_candidate2 <= Q_prime_candidate1)
			% 	disp('Detected superset!')
			% end

		end

		%If candidate1 is truly minimal then add it to Q_prime
		if ~candidate1_is_superset_of_another
			%disp('Found another candidate!')
			Q_prime = [Q_prime,Q_prime_candidate1];
		end
	end
end

function Q_prime = get_minimal_covering_subsets_for_polyunion( set_in , cover_in )
	%Description:
	%	This function considers all of the elements in cover_in and finds those which
	%	- contain the set set_in, and
	%	- are minimal (which I guess means that it is not contained by another set in cover_in)
	%
	%Assumptions:
	%	- cover_in is an array of PolyUnion() objects.
	%	- set_in is a PolyUnion() object.


	%% Input Processing

	%Don't need to check input. We know that they are polyunions.

	%% Algorithm

	cover_elts_that_contain = [];
	cover_elt_idcs_that_contain = [];

	for cover_idx = 1:length(cover_in)
		cover_elt = cover_in(cover_idx);

		if PolyUnion_subseteq(set_in , cover_elt)
			cover_elts_that_contain = [ cover_elts_that_contain , cover_elt ];
			cover_elt_idcs_that_contain = [ cover_elt_idcs_that_contain , cover_idx ];
		end

	end

	%disp(['length(cover_elts_that_contain) = ' num2str(length(cover_elts_that_contain))])

	%Check that each element in cover_elts is 'minimal'
	Q_prime = [];

	for Q_prime_candidate_idx1 = 1:length(cover_elts_that_contain)
		Q_prime_candidate1 = cover_elts_that_contain(Q_prime_candidate_idx1);

		%Check whether or not the candidate is contained by another set
		%in the set of candidates.
		candidate1_is_superset_of_another = false;
		for Q_prime_candidate_idx2 = 1:length(cover_elts_that_contain)
			%One Polyhedron always contains itself.
			if Q_prime_candidate_idx1 == Q_prime_candidate_idx2
				continue;
			end

			%Check to see if Q_prime_candidate1 contains Q_prime_candidate2
			Q_prime_candidate2 = cover_elts_that_contain(Q_prime_candidate_idx2);

			candidate1_is_superset_of_another = ...
				candidate1_is_superset_of_another || PolyUnion_subseteq(Q_prime_candidate2 , Q_prime_candidate1); %Q'2 contained by Q'1

			% if (Q_prime_candidate2 <= Q_prime_candidate1)
			% 	disp('Detected superset!')
			% end

		end

		%If candidate1 is truly minimal then add it to Q_prime
		if ~candidate1_is_superset_of_another
			%disp('Found another candidate!')
			Q_prime = [Q_prime,Q_prime_candidate1];
		end
	end
end