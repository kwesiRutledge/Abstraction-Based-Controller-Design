function [st_hat] = extract_ets( ExpX_in , ExpF_in , Hinv , st_in )
	%Description:
	%	Extracts the external trace system defined by ExpX_in and ExpF_in.
	%
	%Inputs:
	%	Hinv: A st_in.numY x 1 array of PolyUnion or Polyhedra objects.
	%		  Defines the mapping from measurements to the set of states that correspond to it.
	%		  Recall that observarions are finite and should be represented by a number in the
	%		  range {1,...,st_in.numY}.
	%		  Therefore, Hinv{1} = PolyUnion( ... ) = H^{-1}(observation_1)

	%% Constants

	%%%%%%%%%%%%%%%
	%% Algorithm %%
	%%%%%%%%%%%%%%%

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
	for y_idx = 1:st_in.numY
		Hinv_i = Hinv(y_idx);

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
	Hhat = [];
	for xhat_idx = 1:length(Xhat)
		xhat_elt = Xhat(xhat_idx);

		%Check which of the elements of Hinv contains the xhat elt.
		for Hinv_idx = 1:length(Hinv)
			if xhat_elt <= Hinv(Hinv_idx)
				Hhat = [Hhat,Hinv_idx];
				break;
			end
		end
	end

	%% Create System

	st_hat = SystemTuple( Xhat , Xhat0 , st_in.numY , Hhat , 'DiscreteDynamics' , F_hat.state0 , F_hat.u0 , F_hat.state1 );

end