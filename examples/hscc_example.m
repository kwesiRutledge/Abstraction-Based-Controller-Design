%hscc_example.m
%Description:
%

disp('hscc_example.m')
disp(' ')

%% Setup 

path_to_repo_top = '../';
addpath(genpath([path_to_repo_top 'lib/' ]))

pcis_enabled = check_for_pcis();
gurobi_enabled = check_for_gurobi();

mptopt('lpsolver','GUROBI');

if ~pcis_enabled
	error('PCIS and Polyhedron are not currently included in the path. Make sure to include them before running this example.')
end

%% Constants

dom = Polyhedron('lb',[0,0],'ub',[3,3]);

% X = PolyUnion(dom);
X = dom;
X0 = Polyhedron('lb',[0,0],'ub',[1,1]);

DynList = [ Dyn(eye(dom.Dim),ones(dom.Dim,1)*(1/3),	zeros(dom.Dim,1),dom*Polyhedron('lb',0,'ub',0)) , ...
			Dyn(eye(dom.Dim),[(1/3);0],				zeros(dom.Dim,1),dom*Polyhedron('lb',0,'ub',0)), ...
			Dyn(eye(dom.Dim),[0;(1/3)],				zeros(dom.Dim,1),dom*Polyhedron('lb',0,'ub',0)) ];

H = @one_dim_example_output;
Hinv = [ PolyUnion(Polyhedron('lb',[0,0],'ub',[1,1])) , ...
		 PolyUnion(Polyhedron('lb',[1,0],'ub',[2,1])) , ...
		 PolyUnion(Polyhedron('lb',[2,0],'ub',[3,1])) , ...
		 PolyUnion(Polyhedron('lb',[0,1],'ub',[1,2])) , ...
		 PolyUnion(Polyhedron('lb',[1,1],'ub',[2,2])) , ...
		 PolyUnion(Polyhedron('lb',[2,1],'ub',[3,2])) , ...
		 PolyUnion(Polyhedron('lb',[0,2],'ub',[1,3])) , ...
		 PolyUnion(Polyhedron('lb',[1,2],'ub',[2,3])) , ...
		 PolyUnion(Polyhedron('lb',[2,2],'ub',[3,3])) ];

Y_labels{1} = 'A';
Y_labels{2} = 'B';
Y_labels{3} = 'C';
Y_labels{4} = 'D';
Y_labels{5} = 'E';
Y_labels{6} = 'F';
Y_labels{7} = 'G';
Y_labels{8} = 'H';
Y_labels{9} = 'I';

num_y = length(Y_labels);

st_hscc = SystemTuple(X,X0,Hinv,'LinearDynamics',DynList,'YLabels',Y_labels);

max_iter = 1;

disp('Defined Constants')
disp(['- max_iter = ' num2str(max_iter) ])
disp(['- length(Hinv) = ' num2str(length(Hinv)) ])
disp(['- length(DynList) = ' num2str(length(DynList)) ])
disp(' ')

%%%%%%%%%%%%%%%%%
%% Algorithm 0 %%
%%%%%%%%%%%%%%%%%

disp('Using the KAM Function to create external trace system.')

fcn_start = tic;
ets_out_fcn = st_hscc.KAM( 'MaximumIterations' , max_iter , 'Debug' , true , 'CheckCoverConvergence' , false )
function_time = toc(fcn_start);

disp('- Completed KAM function.')
disp(['  + Elapsed time: ' num2str(function_time) ])