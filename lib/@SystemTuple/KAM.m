function [S_hat] = KAM( varargin )
	%Description:
	%	Implementation of the Knowledge Abstraction and Minimization algorithm (Algorithm 2 from Majumdar, Ozay and Schmuck 2020)
	%	
	%Usage:
	%	[S_hat] = st.KAM( Hinv )
	%	[S_hat] = st.KAM( Hinv , 'MaximumIterations' , MaximumIterations )
	%	[S_hat] = st.KAM( ... , 'Debug' , tf )
	%
	%Inputs:
	%	Hinv: A st.numY x 1 array of PolyUnion or Polyhedra objects.
	%		  Defines the mapping from measurements to the set of states that correspond to it.
	%		  Recall that observarions are finite and should be represented by a number in the
	%		  range {1,...,st.numY}.
	%		  Therefore, Hinv{1} = PolyUnion( ... ) = H^{-1}(observation_1)
	%


	%% Input Processing %%

	st = varargin{1};
	Hinv = varargin{2};

	argidx = 3;
	while argidx <= nargin
		switch varargin{argidx}
			case 'MaximumIterations'
				MaximumIterations = varargin{argidx + 1};
				argidx = argidx + 2;
			case 'Debug'
				Debug = varargin{argidx+1};
				argidx = argidx + 2;
			otherwise
				error(['Unexpected input to KAM: ' varargin{argidx} ])
		end
	end

	if ~isa(Hinv(1),'PolyUnion')
		error(['This function is currently designed to support Hinv which are an array of PolyUnion objects. Received an array of ' class(Hinv) 'objects.'])
	end

	%% Constants

	if ~exist('Debug')
		Debug = false;
	end

	%% Algorithm %%

	%%%%%%%%%%%%%%%%%%%%
	%% Initialization %%
	%%%%%%%%%%%%%%%%%%%%

	Cover0 = Hinv;
	ExpGamma0 = [];

	ExpX0 = [];
	for cover_elt_idx = 1:length(Cover0)
		%Check if Cover0(cover_elt_idx) intersected with X0 is nonempty
		cover_elt = Cover0(cover_elt_idx);
		intersected = IntersectPolyUnion(cover_elt,st.X0);
		intersected.reduce();
		intersection_is_empty = (length(intersected.Set) == 0);

		if intersection_is_empty
			continue;
		end

		temp_tuple = ExpXElement( cover_elt_idx , Cover0(cover_elt_idx) , Cover0(cover_elt_idx) );

		%Add to ExpX0;
		ExpX0 = [ExpX0,temp_tuple];
	end

	ExpF0 = [];

	%%%%%%%%%%%%%%%
	%% Main Loop %%
	%%%%%%%%%%%%%%%

	ExpX = ExpX0;
	ExpF = ExpF0;
	CoverSequence{1} = Cover0;
	Cover = Cover0;
	ExpGamma = ExpGamma0;

	curr_iter = 0;
	loop_condition = true;

	while loop_condition
		ExpGamma_i = EXPX_to_EXP_Gamma( ExpX );
		maximal_subset_ExpX = get_expx_elts_with_maximal_cardv( ExpX );
		for maximal_elt_idx = 1:length(maximal_subset_ExpX)
			temp_maximal_elt = maximal_subset_ExpX(maximal_elt_idx);

			for u = 1:st.nu()
				for y = 1:st.numY
					v_prime = [ temp_maximal_elt.v , u , y ];
					c_prime = IntersectPolyUnion(st.F( temp_maximal_elt.c , u ), Hinv(y) );
					Q_prime = get_minimal_covering_subsets_for( c_prime , Cover0 );

					for q_prime_idx = 1:length(Q_prime)
						q_prime = Q_prime(q_prime_idx);
						temp_expx_elt = ExpXElement( v_prime , c_prime , q_prime );
						
						%Update ExpX
						ExpX = temp_expx_elt.union_with_set( ExpX );

						%Update EXPF
						temp_expf_elt = ExpFElement( temp_maximal_elt , u , temp_expx_elt );
						ExpF = temp_expf_elt.union_with_set( ExpF );
					end

				end
			end

			%possibly refine.
			if temp_maximal_elt.c <= temp_maximal_elt.q
				[ Cover , ExpF , ExpGamma , ExpX ] = temp_maximal_elt.refine( st , Cover , ExpF , ExpGamma , ExpX );
			end

		end

		%Update loop condition.
		curr_iter = curr_iter + 1;
		if exist('MaximumIterations')
			loop_condition = loop_condition && (curr_iter < MaximumIterations);
		end

		%Update CoverSequene
		CoverSequence{curr_iter+1} = Cover;
		loop_condition = loop_condition && ...
			(~PolyUnionarrays_equal( CoverSequence{curr_iter} , CoverSequence{curr_iter+1} ));

		%Debugging Info
		if Debug
			disp(['- Iteration #' num2str(curr_iter) ])
			disp(['  + length(Cover) = ' num2str(length(Cover)) ])
		end

	end

	S_hat = extract_ets( ExpX , ExpF , Hinv , st );


end 