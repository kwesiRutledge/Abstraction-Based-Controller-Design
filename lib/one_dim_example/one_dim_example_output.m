function [output_val] = one_dim_example_output( state_val_in )
	%Description:
	%	Receives the state value (enforced to be a value between -2 and 2)

	%% Constants %%

	%% Input Processing %%
	if (abs(state_val_in) > 2)
		error(['The value of the state x must satisfy |x|<= 2. Received ' num2str(state_val_in) '.' ])
	end

	%% Algorithm %%
	if state_val_in < -1
		output_val = 1;
	elseif abs(state_val_in) <= 1
		output_val = 2;
	elseif state_val_in > 1
		output_val = 3;
	else
		output_val = NaN;
		error(['Unexpected state given to one_dim_example_output (state = ' num2str(state_val_in) ').'] )
	end

end