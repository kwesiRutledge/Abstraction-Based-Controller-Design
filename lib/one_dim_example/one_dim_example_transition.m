function [next_states] = one_dim_example_transition(x,u)
	%Description:
	%	For the simple one dimensional example:
	%	- increments the state x by 1 if the input is 1 and
	%	- decrements the state x by 1 if the input is 2.
	%	Implement a simple dynamics map for the two inputs available to the one dimensional example.
	%

	%% Input Processing %%
	x_is_a_scalar_number = isscalar(x) && isnumeric(x);

	if x_is_a_scalar_number
		if (abs(x) > 2)
			error(['The value of the state x must satisfy |x|<= 2. Received ' num2str(x) '.' ])
		end
	elseif isa(x,'Polyhedron')
		if x.Dim ~= 1
			error('Expected one-dimensional polyhedron as input.')
		end
	else
		error('Unexpected input type')
	end

	%% Algorithm %%

	%For scalars
	if x_is_a_scalar_number
		switch u
			case 1
				next_states = Polyhedron('lb',x+1,'ub',x+1);
			case 2
				next_states = Polyhedron('lb',x-1,'ub',x-1);
			otherwise
				error(['There should only be two inputs for the system. Received u =' num2str(u) '.' ])
		end
	end

	if isa(x,'Polyhedron')
		switch u
			case 1
				next_states = x + 1;
			case 2
				next_states = x - 1;
			otherwise
				error(['Unexpected input: ' num2str(u) ])
		end
	end


end