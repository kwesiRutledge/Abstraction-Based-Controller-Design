function tf = PolyUnionarrays_equal( pu_array1 , pu_array2 )
	%Description:
	%	Verifies if every element in pu_array1 is in pu_array2 and vice versa.


	%% Algorithm

	%Check that pua1 is a subset of pua2
	pua1_subset_of_pua2 = true;
	for pua1_idx = 1:length(pu_array1)
		pua1_elt = pu_array1(pua1_idx);

		pua1_elt_in_pua2 = false;
		for pua2_idx = 1:length(pu_array2)
			pua1_elt_in_pua2 = pua1_elt_in_pua2 || ...
				( pua1_elt == pu_array2(pua2_idx) );

			if pua1_elt_in_pua2
				%IF we have found that pua1_elt is in pu_array2,
				%then skip the rest of this loop.
				break;
			end
		end

		pua1_subset_of_pua2 = pua1_subset_of_pua2 && pua1_elt_in_pua2;
	end

	%Check that pua2 is a subset of pua1
	pua2_subset_of_pua1 = true;
	for pua2_idx = 1:length(pu_array2)
		pua2_elt = pu_array2(pua2_idx);

		pua2_elt_in_pua1 = false;
		for pua1_idx = 1:length(pu_array1)
			pua2_elt_in_pua1 = pua2_elt_in_pua1 || ...
				( pua2_elt == pu_array2(pua1_idx) );

			if pua2_elt_in_pua1
				%IF we have found that pua1_elt is in pu_array2,
				%then skip the rest of this loop.
				break;
			end
		end

		pua2_subset_of_pua1 = pua2_subset_of_pua1 && pua2_elt_in_pua1;
	end

	tf = pua1_subset_of_pua2 && pua2_subset_of_pua1;

end