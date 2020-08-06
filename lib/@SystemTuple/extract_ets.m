function [st_hat] = extract_ets( st_in , ExpX_in , ExpF_in )
	%Description:
	%	Extracts the external trace system defined by ExpX_in and ExpF_in.
	%
	%Inputs:
	%
	%Usage:
	%	st_hat = st.extract_ets( ExpX , ExpF )

	%% Constants

	%%%%%%%%%%%%%%%
	%% Algorithm %%
	%%%%%%%%%%%%%%%

	switch class(ExpX_in(1).q)
		case 'PolyUnion'
			st_hat = extract_ets_PolyUnion( st_in , ExpX_in , ExpF_in );
		case 'Polyhedron'
			st_hat = extract_ets_Polyhedron( st_in , ExpX_in , ExpF_in );
		otherwise
			error(['Unexpected class of objects in ExpXElement() list: ' class(ExpX_in(1).q) ])
	end	

end

function [st_hat] = extract_ets_PolyUnion( st_in , ExpX_in , ExpF_in )
	%Description:
	%	Assumes that ExpX_in and ExpF_in are composed of elements with
	%	PolyUnion type objects inside.

	%Create state space Xhat
	Xhat = [];

	for expx_idx = 1:length(ExpX_in)
		expx_elt = ExpX_in(expx_idx);

		if find_PolyUnion_in(expx_elt.q,Xhat) == -1
			%If expx_elt.q is not already in the list Xhat,
			%then add it.
			Xhat = [Xhat,expx_elt.q];
		end
	end

	%Create the initial state set
	Xhat0 = [];
	for y_idx = 1:st_in.ny()
		Hinv_i = st_in.HInverse(y_idx);

		temp_intersection = IntersectPolyUnion(Hinv_i,st_in.X0);
		intersection_is_empty = (length(temp_intersection.Set) == 0);
		if ~intersection_is_empty
			%If intersection is not empty, then add it to the Xhat0 array.
			Xhat0 = [Xhat0,temp_intersection];
		end

	end

	%% Create the Transition Function.
	F_hat.state0 = [];
	F_hat.u0 = [];
	F_hat.state1 = [];

	for expf_idx = 1:length(ExpF_in)
		expf_elt = ExpF_in(expf_idx);

		%Extract the values for q,u, and q'
		q = find_PolyUnion_in(expf_elt.ExpXElt.q,Xhat);
		u = expf_elt.u;
		qprime = find_PolyUnion_in(expf_elt.ExpXEltPrime.q,Xhat);

		transition_already_exists = false;
		for trans_idx = 1:length(F_hat.state0)
			transition_already_exists = transition_already_exists || ...
				( ( F_hat.state0(trans_idx) == q ) && ( F_hat.u0(trans_idx) == u ) && ( F_hat.state1(trans_idx) == qprime )  );
		end

		%If the transition already exists in the transition function,
		if transition_already_exists
			%Then do not add it to the list.
			continue;
		end

		%If the transition does not already exist in the transition funciton,
		%then add it to the list.
		F_hat.state0 = [F_hat.state0;q];
		F_hat.u0 = [F_hat.u0;u];
		F_hat.state1 = [F_hat.state1;qprime];
	end 

	%% Create the new H function.
	HHatInverse = PolyUnion;
	for xhat_idx = 1:length(Xhat)
		xhat_elt = Xhat(xhat_idx);

		%Check which of the elements of Hinv contains the xhat elt.
		for Hinv_idx = 1:st_in.ny()
			if xhat_elt <= st_in.HInverse(Hinv_idx)
				%Then add the element st_in.HInverse(Hinv_idx) to the 
				%new vector HHatInverse.

				if xhat_idx > length(HHatInverse)
					HHatInverse(xhat_idx) = PolyUnion(st_in.HInverse(Hinv_idx));
				elseif isempty(HHatInverse(Hinv_idx).Dim)
					%The HHatInverse(xhat) element is not initialized.
					HHatInverse(xhat_idx) = PolyUnion(st_in.HInverse(Hinv_idx));
				else
					HHatInverse(xhat_idx).add( st_in.HInverse(Hinv_idx) );
				end
			end
		end
	end

	%% Create System

	st_hat = SystemTuple( Xhat , Xhat0 , HHatInverse , 'DiscreteDynamics' , F_hat.state0 , F_hat.u0 , F_hat.state1 );

end

function [st_hat] = extract_ets_Polyhedron( st_in , ExpX_in , ExpF_in )
	%Description:
	%	Assumes that ExpX_in and ExpF_in are composed of elements with
	%	Polyhedron class objects inside.
	%
	%Note to self:
	%	Not sure how to implement HInverse in this case without using PolyUnion
	%	in general.

	%Create state space Xhat
	Xhat = [];

	for expx_idx = 1:length(ExpX_in)
		expx_elt = ExpX_in(expx_idx);

		if isempty(find_in(Xhat,expx_elt.q))
			%If expx_elt.q is not already in the list Xhat,
			%then add it.
			Xhat = [Xhat,expx_elt.q];
		end
	end

	%Create the initial state set
	Xhat0 = [];
	for y_idx = 1:st_in.ny()
		Hinv_i = st_in.HInverse(y_idx);

		temp_intersection = Hinv_i.intersect(st_in.X0);
		if ~temp_intersection.isEmptySet
			%If intersection is not empty, then add it to the Xhat0 array.
			Xhat0 = [Xhat0,temp_intersection];
		end

	end

	%% Create the Transition Function.
	F_hat.state0 = [];
	F_hat.u0 = [];
	F_hat.state1 = [];

	for expf_idx = 1:length(ExpF_in)
		expf_elt = ExpF_in(expf_idx);

		%Extract the values for q,u, and q'
		q = find_PolyUnion_in(expf_elt.ExpXElt.q,Xhat);
		u = expf_elt.u;
		qprime = find_PolyUnion_in(expf_elt.ExpXEltPrime.q,Xhat);

		transition_already_exists = false;
		for trans_idx = 1:length(F_hat.state0)
			transition_already_exists = transition_already_exists || ...
				( ( F_hat.state0(trans_idx) == q ) && ( F_hat.u0(trans_idx) == u ) && ( F_hat.state1(trans_idx) == qprime )  );
		end

		%If the transition already exists in the transition function,
		if transition_already_exists
			%Then do not add it to the list.
			continue;
		end

		%If the transition does not already exist in the transition funciton,
		%then add it to the list.
		F_hat.state0 = [F_hat.state0;q];
		F_hat.u0 = [F_hat.u0;u];
		F_hat.state1 = [F_hat.state1;qprime];
	end 

	%% Create the new H function.
	HHatInverse = PolyUnion;
	for xhat_idx = 1:length(Xhat)
		%disp(xhat_idx)
		xhat_elt = Xhat(xhat_idx);

		%Check which of the elements of Hinv contains the xhat elt.
		for Hinv_idx = 1:st_in.ny()
			% disp(['- Hinv_idx = ' num2str(Hinv_idx) ])
			% disp(['- xhat_elt <= st_in.HInverse(Hinv_idx) = ' num2str( xhat_elt <= st_in.HInverse(Hinv_idx) ) ])

			if xhat_elt <= st_in.HInverse(Hinv_idx)
				%Then add the element st_in.HInverse(Hinv_idx) to the 
				%new vector HHatInverse.
				if Hinv_idx > length(HHatInverse)
					HHatInverse(Hinv_idx) = PolyUnion(Xhat(xhat_idx));
					%disp('a')
				elseif isempty(HHatInverse(Hinv_idx).Dim)
					%The HHatInverse(xhat) element is not initialized.
					HHatInverse(Hinv_idx) = PolyUnion(Xhat(xhat_idx));
					%disp('b')
				else
					HHatInverse(Hinv_idx).add( Xhat(xhat_idx) );
					%disp('c')
				end
			end
		end
	end

	%% Create System

	st_hat = SystemTuple( Xhat , Xhat0 , HHatInverse , 'DiscreteDynamics' , F_hat.state0 , F_hat.u0 , F_hat.state1 );

end