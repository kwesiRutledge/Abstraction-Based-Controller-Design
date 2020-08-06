function [y_out] = hscc_output( x )
	%Description:
	%	Returns the output of the hscc example based on where the continuous state is.
	%	Returns empty set if the point is not in the partition.

	%% Input Processing

	%% Constants

	regions = [ Polyhedron('lb',[0,0],'ub',[1,1]) , Polyhedron('lb',[1,0],'ub',[2,1]) , ...
		 		Polyhedron('lb',[2,0],'ub',[3,1]) , Polyhedron('lb',[0,1],'ub',[1,2]) , ...
		 		Polyhedron('lb',[1,1],'ub',[2,2]) , Polyhedron('lb',[2,1],'ub',[3,2]) , ...
		 		Polyhedron('lb',[0,2],'ub',[1,3]) , Polyhedron('lb',[1,2],'ub',[2,3]) , ...
		 		Polyhedron('lb',[2,2],'ub',[3,3]) ];

	%% Algorithm

	y_out = [];
	for output_idx = 1:length(regions)

		if regions(output_idx).contains(x)
			y_out = [y_out,output_idx];
		end

	end

end