function EXP_Gamma = EXPX_to_EXP_Gamma( EXPX_in )
	%Description:
	%	Converts the array (aka set) EXPX_in of ExpXElement objects into an
	%	array of elements

	%% Constants %%

	len_expx = length(EXPX_in);

	%% Algorithm %%

	EXP_Gamma = [];
	for expx_idx = 1:len_expx
		expx_elt = EXPX_in(expx_idx);

		%Convert element into its smaller form.
		expg_elt_candidate = ExpGammaElement( expx_elt );

		if ( expg_elt_candidate.find_in_list( EXP_Gamma ) == -1 )
			%If the candidate is not in EXP_Gamma, then add it!
			EXP_Gamma = [EXP_Gamma,expg_elt_candidate];
		end

	end

end