function [ Cover_out , EXP_F_out , EXP_Gamma_out , EXP_X_out ] = ...
	refine( obj , System_in , Cover_in , EXP_F_in , EXP_Gamma_in , EXP_X_in )
	%Description:
	%	Refines the sets Cover_in , EXP_Gamma_in , EXP_F_in , EXP_X_in
	%	using the current EXP_X element.

	%% Input Processing

	switch class(Cover_in(1))
		case 'PolyUnion'
			[ Cover_out , EXP_F_out , EXP_Gamma_out , EXP_X_out ] = ...
				refine_PolyUnion( obj , System_in , Cover_in , EXP_F_in , EXP_Gamma_in , EXP_X_in );
		case 'Polyhedron'
			[ Cover_out , EXP_F_out , EXP_Gamma_out , EXP_X_out ] = ...
				refine_Polyhedron( obj , System_in , Cover_in , EXP_F_in , EXP_Gamma_in , EXP_X_in );
		otherwise
			error(['Cover is made up of unexpected objects of type ' class(Cover_in(1)) ])
	end

end 

function [ Cover_out , EXP_F_out , EXP_Gamma_out , EXP_X_out ] = ...
	refine_Polyhedron( obj , System_in , Cover_in , EXP_F_in , EXP_Gamma_in , EXP_X_in )
	%Description:
	%	Refines the sets Cover_in , EXP_Gamma_in , EXP_F_in , EXP_X_in
	%	using the current EXP_X element.

	%% Input Processing


	%% Constants

	%% Initialize Sets
	Cover_out = Cover_in;
	EXP_Gamma_out = EXP_Gamma_in;
	EXP_F_out = EXP_F_in;
	EXP_X_out = EXP_X_in;

	%% Algorithm

	post_Q = obj.get_PostQ_u( EXP_F_in , System_in.nu() );

	s = System_in.pre_input_dependent( post_Q );

	%Some debugging info
	if length(s) > 1
		warning('The handling of s is incorrect in refine_Polyhedron!')
	end

	if s.isEmptySet
		warning('s is empty!')
	end

	s = s.intersect(obj.q);

	%Check if s <= q

	if  s < obj.q 
		%If s is a proper subset of q

		%Update the cover
		Cover_out = [Cover_out,s];

		%Go through all elements of EXP_X_in
		for expx_idx = 1:length(EXP_X_in)
			expx_elt = EXP_X_in(expx_idx);

			%Only investigate elements that match in the q dimension
			if obj.q ~= expx_elt.q
				continue;
			end

			% disp(['expx_idx = ' num2str(expx_idx)])

			%For the expx_elt's whose q value matches obj.q,
			%check the c value.
			if expx_elt.c < s 
				EXP_Gamma_out = change_tuples_in_list( EXP_Gamma_out , expx_elt , s );
				EXP_F_out = change_tuples_in_list( EXP_F_out , expx_elt , s );
				EXP_X_out = change_tuples_in_list( EXP_X_out , expx_elt , s );
			end

		end

		%Iterate through all elements of EXP_F
		for expf_idx = 1:length(EXP_F_out)
			expf_elt = EXP_F_out(expf_idx);

			source_expx = expf_elt.ExpXElt;

			if ( expf_elt.ExpXEltPrime.q == s ) && (source_expx.c < source_expx.q)
				[ Cover_out , EXP_F_out ,  EXP_Gamma_out , EXP_X_out ] = source_expx.refine( ...
					System_in , Cover_out , EXP_F_out ,  EXP_Gamma_out , EXP_X_out );
			end

		end

	end

end 

function [ Cover_out , EXP_F_out , EXP_Gamma_out , EXP_X_out ] = ...
	refine_PolyUnion( obj , System_in , Cover_in , EXP_F_in , EXP_Gamma_in , EXP_X_in )
	%Description:
	%	Refines the sets Cover_in , EXP_Gamma_in , EXP_F_in , EXP_X_in
	%	using the current EXP_X element.

	%% Input Processing


	%% Constants

	%% Initialize Sets
	Cover_out = Cover_in;
	EXP_Gamma_out = EXP_Gamma_in;
	EXP_F_out = EXP_F_in;
	EXP_X_out = EXP_X_in;

	%% Algorithm

	post_Q = obj.get_PostQ_u( EXP_F_in , System_in.nu() );

	s = System_in.pre_input_dependent( post_Q );
	s = IntersectPolyUnion( s , obj.q );
		
	%disp(class(s))

	%Check if s <= q

	% disp(class(s))
	% disp(class(obj.q))

	if PolyUnion_strictsubset( s , obj.q )
		%If s is a proper subset of q

		%Update the cover
		Cover_out = [Cover_out,s];

		%Go through all elements of EXP_X_in
		for expx_idx = 1:length(EXP_X_in)
			expx_elt = EXP_X_in(expx_idx);

			%Only investigate elements that match in the q dimension
			if obj.q ~= expx_elt.q
				continue;
			end

			% disp(['expx_idx = ' num2str(expx_idx)])

			%For the expx_elt's whose q value matches obj.q,
			%check the c value.
			if PolyUnion_strictsubset( expx_elt.c , s )
				EXP_Gamma_out = change_tuples_in_list( EXP_Gamma_out , expx_elt , s );
				EXP_F_out = change_tuples_in_list( EXP_F_out , expx_elt , s );
				EXP_X_out = change_tuples_in_list( EXP_X_out , expx_elt , s );
			end

		end

		%Iterate through all elements of EXP_F
		for expf_idx = 1:length(EXP_F_out)
			expf_elt = EXP_F_out(expf_idx);

			source_expx = expf_elt.ExpXElt;

			if ( expf_elt.ExpXEltPrime.q == s ) && PolyUnion_strictsubset(source_expx.c , source_expx.q)
				[ Cover_out , EXP_F_out ,  EXP_Gamma_out , EXP_X_out ] = source_expx.refine( ...
					System_in , Cover_out , EXP_F_out ,  EXP_Gamma_out , EXP_X_out );
			end

		end

	end

end 