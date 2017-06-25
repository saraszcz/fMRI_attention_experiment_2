%Hilda's experiment, modified as a slow event-related design
%making stim always contain color and motion
% uses DrawDots.mex which is a modification of the DOTS.mex package from
% Shadlen
% 6/21/07: ss starting to modify program to fit baseline experiment.
%newest version: 12/14/07. Implemented motion coherence changes. Changed program to fit with a 1.6 sec TR


filename=input('Input unique name for saving data:', 's');
%filename = 'test';

% if you want all the psych toolbox stuff to run as usual,
% set SHOWME to 1, else set it to 0 and then it will skip
% over all the PTB calls
showme = 1;

% gjd
check_resp = 0;

TR_length = 1.6;
long_exp_length=8; %length of standard baseline increase
long_exp_length_plusTR = long_exp_length + TR_length;
long_exp_length_minusTR = long_exp_length - TR_length;
short_exp_length = TR_length*2;
target_length = 8;
rest_length = 14.4;%time to let BOLD return to baseline (9 TRs = 14.4 sec)
cue_length=.6;%length of cue
time_till_cue = 13; % time during the rest period before the cue is presented. this should be based on the time of the rest_length.
begin_length = 14.4; %time at the beginning of the run (9 TRs = 14.4 sec)
end_length = 4.8; %time at the end of the run (3 TRs = 4.8 sec)
%time_till_beep = 8.5; %8.5 sec into the rest period, sound beep (this is also cue to next trial)
time_till_beep3 = 1;% 1 sec into the rest period, sound beep (this reorients subjects to attend back to fixation)

stim_length=.40; %length of each stim presentation
stim_per_block= target_length/stim_length; %20 for 8 s blocks, .40 stim
motion_coh= .5;
%stim_per_block=22;
%range for possible targets, on average, every 2.5 sec, need to change if change block length or stim length
% range1=[5 6 7 8];% target can occur only once in each of these groups??
% range2=[12 13 14 15];
% range3=[19 20 21 22];
%range4=[26 27 28 29];
targ_min = 3;%minimum amount of stimuli that can occur before next target
targ_max = 5;%maxmum amount of stimuli that can occur before next target % XX- may have to change this

stim=zeros(stim_per_block, 2);%list of color, motion dir for stimuli during block

fix_stim=.40; %length of time fixation cross dimmed, will occur on average every 2 s
response_time=1.6;%1 sec to respond to every event type, durin fixation task and att task
between_fix_dur = 2; % this is the (minimum? average?) length of time between two fixation cross dimmings
fix_rand_coef = 2; % making this larger increases the variance in the randomized durations between fixation dimmings
%total amount of time for each run:
total_time=358.4;

%%%create 2 beeps%%%%
%first number is beep frequency and second number is time that it is on.
%beep1 = MakeBeep (400,0.7);%make 400 Hz beep, played before the beginning of every new trial (at the end of every rest period EXCEPT the last rest period, following the end of the block)
%beep2 = MakeBeep (400,0.7);%make 400 Hz beep, played before the very first trial starts
beep3 = MakeBeep (1000,0.7);%make 800 Hz beep, played after the end of each visual stimulus and catch trial block (to signify reorient attention to fixation)
Snd('Open');
%Snd('Play', boop2); the is an example of what i later must put in the code

vis_stim = 1; % visual stimulation period (when targets will appear)
rest = 2; %rest period at the end of each trial
exp_short = 3;%short expectation period (1TR)
exp_long = 4;%regular, long expectation period (4 TRs)
exp_long_plusTR = 5;%long expectation period + 1 TR jitter (5 TRs)
exp_long_minusTR = 6;%long expectation period - 1 TR jitter (3 TRs)
exp_passive = 7;%expectation period before passive viewing
exp_catch =8;%expectation period before catch trials
vis_stim_passive = 9;
beginning_per = 10;
end_per = 11; 
%reorient_beep3 = 12;

epoch_order=      [10, 3,  1,  2,  8,  2,  6,  1,  2,  7,  9,  2,  5,  1,  2,  4,  1,  2, ...
 		               3,  1,  2,  8,  2,  5,  1,  2,  6,  1,  2,  4,  1,  2,  7,  9,  2, 11;                                                                 
			   	   10, 6,  1,  2,  7,  9,  2,  4,  1,  2,  5,  1,  2,  8,  2,  3,  1,  2, ...
		               5,  1,  2,  6,  1,  2,  3,  1,  2,  8,  2,  7,  9,  2,  4,  1,  2, 11;    
				   10, 4,  1,  2,  5,  1,  2,  3,  1,  2,  8,  2,  7,  9,  2,  6,  1,  2, ...
		               8,  2,  4,  1,  2,  6,  1,  2,  7,  9,  2,  5,  1,  2,  3,  1,  2, 11;   
				   10, 7,  9,  2,  3,  1,  2,  5,  1,  2,  6,  1,  2,  4,  1,  2,  8,  2, ...
		               4,  1,  2,  5,  1,  2,  7,  9,  2,  3,  1,  2,  6,  1,  2,  8,  2, 11;                                                                     
				   10, 8,  2,  4,  1,  2,  7,  9,  2,  3,  1,  2,  6,  1,  2,  5,  1,  2, ...
		               7,  9,  2,  3,  1,  2,  4,  1,  2,  5,  1,  2,  8,  2,  6,  1,  2, 11;    	   
				   10, 5,  1,  2,  6,  1,  2,  8,  2,  4,  1,  2,  3,  1,  2,  7,  9,  2, ...
		               6,  1,  2,  7,  9,  2,  8,  2,  4,  1,  2,  3,  1,  2,  5,  1,  2, 11;
				   10, 3,  1,  2,  8,  2,  5,  1,  2,  6,  1,  2,  4,  1,  2,  7,  9,  2, ...
		               3,  1,  2,  8,  2,  6,  1,  2,  7,  9,  2,  5,  1,  2,  4,  1,  2, 11;                                                              
				   10, 5,  1,  2,  6,  1,  2,  3,  1,  2,  8,  2,  7,  9,  2,  4,  1,  2, ...
				       6,  1,  2,  7,  9,  2,  4,  1,  2,  5,  1,  2,  8,  2,  3,  1,  2, 11;  
				   10, 8,  2,  4,  1,  2,  6,  1,  2,  7,  9,  2,  5,  1,  2,  3,  1,  2, ...
					   4,  1,  2,  5,  1,  2,  3,  1,  2,  8,  2,  7,  9,  2,  6,  1,  2, 11;    
				   10, 4,  1,  2,  5,  1,  2,  7,  9,  2,  3,  1,  2,  6,  1,  2,  8,  2, ...
		               7,  9,  2,  3,  1,  2,  5,  1,  2,  6,  1,  2,  4,  1,  2,  8,  2, 11];
				   			                                                                                              	                    
nconds = max(max(epoch_order)); %find the largest number in epoch order and that will be the total number
%of conditions in this design

% 0 == no lateralization, 1 == peripheral stimulus to the left, 2 == peripheral stimulus to the right,          
% 10 == left cue, 20 == right cue                                                                                  
  			                                                                                                          
left_right_order= [10, 0,  1, 20,  0, 10,  0,  1,  0,  0,  2, 20,  0,  2, 10,  0,  1, 20, ... 
    			       0,  2, 10,  0, 10,  0,  1, 20,  0,  2, 20,  0,  2,  0,  0,  1,  0,  0;
				   20, 0,  2,  0,  0,  1, 20,  0,  2, 20,  0,  2, 10,  0, 10,  0,  1, 10, ... 
    			       0,  1, 10,  0,  1, 20,  0,  2, 20,  0,  0,  0,  2, 10,  0,  1,  0,  0;
				   10, 0,  1, 20,  0,  2, 20,  0,  2, 10,  0,  0,  0,  1, 20,  0,  2, 20, ... 
    			       0, 20,  0,  2, 10,  0,  1,  0,  0,  2, 10,  0,  1, 10,  0,  1,  0,  0;
					0, 0,  2, 10,  0,  1, 20,  0,  2, 10,  0,  1, 20,  0,  2, 10,  0, 10, ... 
    			       0,  1, 10,  0,  1,  0,  0,  1, 20,  0,  2, 20,  0,  2, 20,  0,  0,  0;   
				   20, 0, 10,  0,  1,  0,  0,  1, 20,  0,  2, 10,  0,  1, 20,  0,  2,  0, ... 
    			       0,  2, 10,  0,  1, 20,  0,  2, 10,  0,  1, 10,  0, 20,  0,  2,  0,  0;
				   10, 0,  1, 10,  0,  1, 20,  0, 20,  0,  2, 10,  0,  1,  0,  0,  2, 20, ... 
    			       0,  2,  0,  0,  1, 10,  0, 10,  0,  1, 20,  0,  2, 20,  0,  2,  0,  0;
				   20, 0,  2, 10,  0, 10,  0,  1, 20,  0,  2, 20,  0,  2,  0,  0,  1, 10, ... 
    			       0,  1, 20,  0, 10,  0,  1,  0,  0,  2, 20,  0,  2, 10,  0,  1,  0,  0;
				   20, 0,  2, 20,  0,  2, 20,  0,  2, 10,  0,  0,  0,  1, 10,  0,  1, 10, ... 
    			       0,  1,  0,  0,  2, 20,  0,  2, 10,  0,  1, 20,  0, 10,  0,  1,  0,  0;
				   20, 0, 10,  0,  1, 20,  0,  2,  0,  0,  1, 10,  0,  1, 20,  0,  2, 20, ... 
    			       0,  2, 20,  0,  2, 10,  0,  1, 10,  0,  0,  0,  2, 10,  0,  1,  0,  0;
				   10, 0,  1, 20,  0,  2,  0,  0,  2, 20,  0,  2, 10,  0,  1, 10,  0,  0, ... 
    			       0,  1, 10,  0,  1, 10,  0,  1, 20,  0,  2, 20,  0,  2, 20,  0,  0,  0];
					     		
% epoch_order=
%[beginning, exp_short, vis_stim, rest, exp_catch, rest, exp_long_minusTR, vis_stim, rest, exp_passive, vis_stim_passive, rest, exp_long_plusTR, vis_stim, rest, exp_long, vis_stim, rest, ...
% 			 exp_short, vis_stim, rest, exp_catch, rest, exp_long_plusTR, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_long, vis_stim, rest, exp_passive, vis_stim_passive, rest, end;
% beginning, exp_long_minusTR, vis_stim, rest, exp_passive, vis_stim_passive, rest, exp_long, vis_stim, rest, exp_long_plusTR, vis_stim, rest, exp_catch, rest, exp_short, vis_stim, rest, ...
% 			 exp_long_plusTR, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_short, vis_stim, rest, exp_catch, rest, exp_passive, vis_stim_passive, rest, exp_long, vis_stim, rest, end;
% beginning, exp_long, vis_stim, rest, exp_long_plusTR, vis_stim, rest, exp_short, vis_stim, rest, exp_catch, rest, exp_passive, vis_stim_passive, rest, exp_long_minusTR, vis_stim, rest, ...
% 			 exp_catch, rest, exp_long, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_passive, vis_stim_passive, rest, exp_long_plusTR, vis_stim, rest, exp_short, vis_stim, rest, end;
% beginning, exp_passive, vis_stim_passive, rest, exp_short, vis_stim, rest, exp_long_plusTR, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_long, vis_stim, rest, exp_catch, rest, ...
% 			 exp_long, vis_stim, rest, exp_long_plusTR, vis_stim, rest, exp_passive, vis_stim_passive, rest, exp_short, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_catch, rest, end;
% beginning, exp_catch, rest, exp_long, vis_stim, rest, exp_passive, vis_stim_passive, rest, exp_short, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_long_plusTR, vis_stim, rest, ...
% 			 exp_passive, vis_stim_passive, rest, exp_short, vis_stim, rest, exp_long, vis_stim, rest, exp_long_plusTR, vis_stim, rest, exp_catch, rest, exp_long_minusTR, vis_stim, rest, end;
% beginning, exp_long_plusTR, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_catch, rest, exp_long, vis_stim, rest, exp_short, vis_stim, rest, exp_passive, vis_stim_passive, rest, ...
% 			 exp_long_minusTR, vis_stim, rest, exp_passive, vis_stim_passive, rest, exp_catch, rest, exp_long, vis_stim, rest, exp_short, vis_stim, rest, exp_long_plusTR, vis_stim, rest, end;
% beginning, exp_short, vis_stim, rest, exp_catch, rest, exp_long_plusTR, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_long, vis_stim, rest, exp_passive, vis_stim_passive, rest,...
% 			 exp_short, vis_stim, rest, exp_catch, rest, exp_long_minusTR, vis_stim, rest, exp_passive, vis_stim_passive, rest, exp_long_plusTR, vis_stim, rest, exp_long, vis_stim, rest, end;
% beginning, exp_long_plusTR, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_short, vis_stim, rest, exp_catch, rest, exp_passive, vis_stim_passive, rest, exp_long, vis_stim, rest, ...
% 			 exp_long_minusTR, vis_stim, rest, exp_passive, vis_stim_passive, rest, exp_long, vis_stim, rest, exp_long_plusTR, vis_stim, rest, exp_catch, rest, exp_short, vis_stim, rest, end;
% beginning, exp_catch, rest, exp_long, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_passive, vis_stim_passive, rest, exp_long_plusTR, vis_stim, rest, exp_short, vis_stim, rest, ...
% 			 exp_long, vis_stim, rest, exp_long_plusTR, vis_stim, rest, exp_short, vis_stim, rest, exp_catch, rest, exp_passive, vis_stim_passive, rest, exp_long_minusTR, vis_stim, rest, end;
% beginning, exp_long, vis_stim, rest, exp_long_plusTR, vis_stim, rest, exp_passive, vis_stim_passive, rest, exp_short, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_catch, rest, ...
% 			 exp_passive, vis_stim_passive, rest, exp_short, vis_stim, rest, exp_long_plusTR, vis_stim, rest, exp_long_minusTR, vis_stim, rest, exp_long, vis_stim, rest, exp_catch, rest, end];
%			  
[temp_runs, temp_epochs]=size(epoch_order); % number of runs and number of blocks per run (34)

num_runs=temp_runs;%number of runs in scan session
num_blocks=temp_epochs;%number of epochs ("blocks") in each run
nstim = 1;

behav=[]; % trial num, resp, rt, block type, run number

%resp=50; %for space bar
resp=22; %first button in scanner.

% xdots = zeros(ndots,3);				% [x, y, color, size] for each dot to be drawn
% %xdots(1:2:2*p.ndots-1,3) = Bkcolor;		% dots to be erased
% xdots(:,3) = WHITE_INDEX;	% dots to be drawn
% xdots(:,4) = 3;							% sizes of dots
%
% edots = zeros(p.ndots,3);
% edots(:,3) = Bkcolor;		% dots to be erased
% edots(:,4) = 3;


% create color look-up table (CLUT). Sets dot colors

BLACK_INDEX		= 0;
RED_INDEX 		= 1;
GREEN_INDEX 	= 2;
BLUE_INDEX 		= 3;
BLUE2_INDEX     = 7;
BLUE3_INDEX		= 8;
BLUE4_INDEX		= 9;
YELLOW_INDEX	= 4;
WHITE_INDEX 	= 5;
PURPLE_INDEX 	= 6;
ORANGE_INDEX	= 10;
LIME_INDEX      = 11;
PINK_INDEX      = 12;
PEACH_INDEX     = 13;
PEACH2_INDEX    = 14;
CYAN_INDEX      = 15;
MAGENTA_INDEX   = 16;
PEACH3_INDEX    = 17;
GREEN2_INDEX    = 18;
GREEN3_INDEX    = 19;
GREEN4_INDEX    = 20;
BLUE5_INDEX     = 21;
ORANGE2_INDEX   = 22;
PINK2_INDEX     = 23;
ROSE_INDEX      = 24;
PEACH3_INDEX    = 25;
YELLOW2_INDEX   = 26;
LILAC_INDEX     = 27;
LILAC2_INDEX    = 28;
GRAY_INDEX		= 29;

clut = zeros(256, 3);
clut(BLACK_INDEX	+ 1, :) = [0 0 0];
clut(RED_INDEX		+ 1, :)	= [255 200 0];
clut(GREEN_INDEX	+ 1, :)	= [0 255 0];
clut(GREEN2_INDEX	+ 1, :)	= [50 150 150];
clut(GREEN3_INDEX	+ 1, :)	= [0 200 100];
clut(GREEN4_INDEX	+ 1, :)	= [100 255 50];
clut(BLUE_INDEX		+ 1, :)	= [0 0 255];
clut(BLUE2_INDEX	+ 1, :)	= [0 150 255];
clut(BLUE3_INDEX	+ 1, :)	= [0 200 255];
clut(BLUE4_INDEX	+ 1, :)	= [0 100 255];
clut(BLUE5_INDEX	+ 1, :)	= [100 100 255];
clut(YELLOW_INDEX	+ 1, :)	= [255 255 0];
clut(YELLOW2_INDEX	+ 1, :)	= [255 200 0];
clut(WHITE_INDEX	+ 1, :)	= [255 255 255];
% this one doesn't appear to be used (it gets overwritten below)
% clut(GRAY_INDEX		+ 1, :)	= [100 100 100];
clut(PURPLE_INDEX	+ 1, :)	= [150 0 255];
clut(ORANGE_INDEX	+ 1, :)	= [255 100 0];
clut(ORANGE2_INDEX	+ 1, :)	= [255 150 0];
clut(LIME_INDEX	    + 1, :)	= [100 255 0];
clut(PINK_INDEX	    + 1, :)	= [255 50 150];
clut(PINK2_INDEX    + 1, :)	= [255 0 100];
clut(ROSE_INDEX	    + 1, :)	= [255 100 125];
clut(PEACH_INDEX	+ 1, :)	= [255 175 0];
clut(PEACH2_INDEX   + 1, :)	= [200 175 0];
clut(PEACH3_INDEX   + 1, :)	= [255 150 150];
clut(CYAN_INDEX	    + 1, :)	= [0 255 255];
clut(MAGENTA_INDEX	+ 1, :)	= [255 0 255];
clut(LILAC_INDEX	+ 1, :)	= [200 100 255];
clut(LILAC2_INDEX	+ 1, :)	= [200 150 255];

Bkcolor	= BLACK_INDEX;	% background color

colors = [MAGENTA_INDEX, GREEN3_INDEX, BLUE_INDEX, YELLOW2_INDEX];
%directions, 1==up, 2=right, 3=down, 4=left

clut(WHITE_INDEX	+ 1, :)	= [160 160 160];%difference of 30

clut(GRAY_INDEX	+ 1, :)	= [130 130 130];
% use this one if you want a bright green gray. for debugging
%clut(GRAY_INDEX	+ 1, :)	= [50 150 150];


ndots=100;

dots=zeros(ndots*2, 3); % [x, y, color] for each dot to be drawn
dots(:, 4)=3;%dot size. adds a 4th column that corresponds to the size of each dot. so dots = [x, y, color, size]
dots(1:2:ndots*2-1, 3)=Bkcolor; % setting every other dot's color to black?

% ---------------
% open the screen
% ---------------

p.res = SCREEN(0,'Resolution');
p.res.pixelSize = 8;
if showme, [wp, rect] = SCREEN(0, 'OpenWindow', Bkcolor,[],p.res);	% open main screen
end
% rect
if showme
	SCREEN(wp, 'SetClut', clut);	% Set the CLUT (color look-up table) with the clut that was created up above
	HideCursor;	% Hide the mouse cursor
end
center = [rect(3) rect(4)]/2;	% center of screen (pixel coordinates)

% -----------------------------
% set the experiment parameters
% -----------------------------

p.mon_width  	= 39;	% horizontal dimension of viewable screen (in cm)
p.v_dist 		= 60;	% viewing distance (in cm)
p.norm_speed 	= 7;	% normal dot speed (deg/sec)
p.x_right 		= 10-1.25;	% right border of aperture (deg from center)
p.x_left 		= 5+1.25;	% left border of aperture (deg from center)
p.y_top			= 10-1.25;	% top border of aperture (deg from center)
p.y_bottom		= 5+1.25;	% bottom border of aperture (deg from center)


if showme
	p.frame_rate=SCREEN(wp,'FrameRate');	% frames per second
else
	% just a hack so that this will work without showme
	p.frame_rate = 60;
end

% -------------
% set up arrays
% -------------

pix_per_deg = pi * rect(3) / atan(p.mon_width/p.v_dist/2) / 360;	% pixels per degree
ds_to_pf = pix_per_deg / p.frame_rate;	% conversion factor from deg/sec to pixels/frame
pfs = p.norm_speed * ds_to_pf;	% normal dot speed (pixels/frame)

% -----------------------------------
% set up dot positions and velocities
% -----------------------------------

xmax = p.x_right * pix_per_deg;	% maximum x (pixels from center)
xmin = p.x_left * pix_per_deg; 	% minimum
ymax = -p.y_bottom * pix_per_deg;	% maximum y (pixels from center)
ymin = -p.y_top * pix_per_deg; 	% minimum

x = (rand(ndots,1) * (xmax-xmin) + xmin);	% dot positions in Cartesian pixel coordinates relative to center
y = (rand(ndots,1) * (ymax-ymin) + ymin);	% dot positions in Cartesian pixel coordinates relative to center


% --------------------
% start experiment now: draw fixation point and text and wait for key press to begin
% --------------------

fix_cord = [center-5 center+5];
if showme, SCREEN(wp,'TextSize',20);
end
if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);	% fixation cross
end
% screen(wp, 'fillrect', LILAC2_INDEX, [0 0 200 200 ])

%%%%%%%%%%%%%%%%%%%%%%%%start experiment%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trial_num=0;
for run=1:num_runs % this iterates over 10 (or # of runs)
	if showme
		txt = 'Ready for next run?';
		txtloc = [center(1) - max(size(txt)) * 7 / 2, center(2) + 40];
		[newX newY] = SCREEN(wp,'DrawText',txt,txtloc(1),txtloc(2),RED_INDEX);
		if run>1%if not before first run, display behavior
			Screen(wp,'DrawText', num2str(run_behav), rect(3)-45, rect(4)-20, RED_INDEX);	
			if run_behav > 95
				if motion_coh-.1>0
					motion_coh=motion_coh-.1;
				end
			elseif run_behav < 75
				if motion_coh+.1 < 1
					motion_coh=motion_coh+.1;
				end
			end
			
		end
	end
	
	
	FlushEvents('keydown');
	kbwait;
	FlushEvents('keydown');
	Screen(wp, 'FillRect', Bkcolor,[]);
	if showme 
		SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);	% fixation cross
	end
	waitsecs(2);
	
    txt = 'Wait for experiment to start';
    txtloc = [center(1) - length(txt) * 7 / 2, center(2) + 40]; % sets text location
    if showme
		[newX newY] = SCREEN(wp,'DrawText',txt,txtloc(1),txtloc(2),RED_INDEX);
	    FlushEvents('keydown');
    	kbwait;
    end
	
    % gjd
    if showme, SCREEN(wp,'WaitBlanking');
    end
    if showme, [newX newY] = SCREEN(wp,'DrawText',txt,txtloc(1),txtloc(2),Bkcolor);	% clear text. just turns text black
    end

    start_run_time = GetSecs;%start time for run
	% reset the expected timing accumulator for this run
	expected_accum_time = 0;

    epoch_num=0;% initializes block #

    fix_dimmed=0; %1 if fixation currently dimmed, 0 if not dimmed
    %targ_color=0; %initializes color as target blocks
    targ_motion=0; % initializes motion as target blocks
	%beep2_played = 0;
	
    while GetSecs < start_run_time + total_time %while still time in run. MAIN WHILE LOOP FOR EACH RUN

        epoch_num=epoch_num+1; %increment block number
        start_block_time=GetSecs;%start time for block
		
	    next_fix=between_fix_dur; % reset this, because it grows in each block

        cue_is_on = 0;
		
		% how much time has actually elapsed since the beginning of this run
		elapsed_accum_time = GetSecs - start_run_time;
	
		discrepancy = elapsed_accum_time - expected_accum_time;
		
		if discrepancy > 0.01
			% gjd crazy optional timing correction - 070716
			
			% if we're running behind time, this will make the block think
			% that it started slightly earlier than it did, compensating for the 
			% delay, and hopefully making sure that we never get far behind ourselves
			start_block_time = start_block_time - discrepancy;
		end
		
		% display how much time we expect to have passed so far
		%disp(sprintf('Elapsed = %.3f, expected = %.3f, discrepancy = %.3f', ...
			%elapsed_accum_time, expected_accum_time, discrepancy))
	
        %keep track of if collecting responses for fixation task (all epochs where subjects are NOT doing the peripheral task)
        if  ...
			epoch_order(run, epoch_num)==rest | ...
			epoch_order(run, epoch_num)==exp_passive | ...
			epoch_order(run, epoch_num)==vis_stim_passive | ...
			epoch_order(run, epoch_num)==beginning_per | ...
			epoch_order(run, epoch_num)==end_per 

            do_fix=1;
        else
            do_fix=0;
        end
	
			
		%%% play beep 3 (signals subject to reorient attention from periphery back to fixation).
% 		if epoch_order(run, epoch_num) == reorient_beep3
% 			% this is supposed to happen instantaneously. this line is just a reminder of that
% 			expected_accum_time = expected_accum_time + 0;
% 			
% 			Snd('Play', beep3);
% 			% disp 'reorient_beep';
% 			
% 		end
		%%%% end of beep 3
		
		%%% time at the beginning of the experiment %%%
        if epoch_order(run, epoch_num) == beginning_per %if the program is in the first epoch (beginning epoch)
			expected_accum_time = expected_accum_time + 14.4;
		
            %disp 'beginning block'
            %%%% fixation cross is being dimmed%%%%
            while GetSecs < start_block_time + begin_length %while there is still time at the very beginning of the run
                %make fixation cross dim
                if ~fix_dimmed & GetSecs > start_block_time + next_fix % if not dimmed and time for next fixation dimming
                    %dim fixation cross
                    if showme
						SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), GRAY_INDEX);%set fixation to dim
                    end
                    fix_dimmed=1;
                    fix_start=GetSecs;
					
					trial_num=trial_num+1;
					behav=[behav; trial_num, 0, 0, epoch_order(run, epoch_num), run];%first zero for if got resp, next one rt
					check_resp=1;%set flag for getting responses
					start_resp_time=GetSecs;
                end
		
                if fix_dimmed & GetSecs > fix_start+fix_stim % if fix dimmed and length of fix dim has passed (.44)
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);% turn it back to white
                    end
                    fix_dimmed=0;
                    next_fix = next_fix + fix_stim + between_fix_dur + rand * fix_rand_coef; % Varies fixation dimming between some minimum amount of time
					% (between fix dur) and some maxiumum amount of time (fix_rand_coef). In this case, it varies between 2 and 4 seconds
                end
				if check_resp %if collecting responses
					[keyIsDown, secs, keycode] = kbcheck; %check response
					if find(keycode(resp)) %resp not trigger
						behav(trial_num, 2)=1;%1 for hit response
						behav(trial_num, 3)=GetSecs -start_resp_time;%enter resp time. %%% where is start_resp_time first set?
						check_resp=0; %stop checking
					elseif GetSecs - start_resp_time > response_time %if time for subject to respond has passed, stop checking
						check_resp=0;
					end
				end	
				%add a beep 2 sec before the start of next exp_period
% 				if GetSecs > start_block_time + time_till_beep & beep2_played==0
% 					Snd('Play', beep2);
% 					beep2_played = 1;
% 					%disp 'beginning of trial beep';
% 				end	
				if (GetSecs > start_block_time + time_till_cue) & ...
					(GetSecs < start_block_time + time_till_cue + cue_length) & ...
					(cue_is_on==0)
				
                    %draw cue. these are the two lateralized cue cases
					if left_right_order(run, epoch_num) == 10
                    	if showme
							SCREEN(wp,'DrawText','\',center(1)-20,center(2)-20,WHITE_INDEX);
                    	end
                    	cue_is_on = 1;
					end	
					if left_right_order(run, epoch_num) == 20
						if showme
							SCREEN(wp,'DrawText','/',center(1)+20,center(2)-20,WHITE_INDEX);
						end
						cue_is_on = 1;
					end
					% disp(sprintf('cue is on at %i',GetSecs))
                end
				
                if (GetSecs >= start_block_time + time_till_cue + cue_length) & (cue_is_on) %wait length of cue time
                  	if left_right_order(run, epoch_num) == 10
						% erase the left cue
                    	if showme
							SCREEN(wp,'FillRect',Bkcolor,[center(1)-30 center(2)-50 center(1)-5 center(2)-20]);
							%SCREEN(wp,'DrawText','\',center(1)-20,center(2)-20,Bkcolor);
                    	end
                    	cue_is_on = 0;
					end	
					if left_right_order(run, epoch_num) == 20
						% erase the right cue
						if showme
							SCREEN(wp,'FillRect',Bkcolor,[center(1)+20 center(2)-50 center(1)+50 center(2)-20]);
							%SCREEN(wp,'DrawText','/',center(1)+20,center(2)-20,Bkcolor);
						end
						cue_is_on = 0;
					end
					% disp(sprintf('cue is off at %i',GetSecs))
				end
            end % end of the while loop
            start_block_time=GetSecs; %reset start block time
		
            if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);
            end
		
        end % end of rest period at the very beginning of the run
		
		%%% time at the end of the experiment %%%
        if epoch_order(run, epoch_num) == end_per %if the program is in the last epoch (last block)
			
			expected_accum_time = expected_accum_time + 4.8;

            %disp 'end block'
            %%%% fixation cross is being dimmed%%%%
            while GetSecs < start_block_time + end_length %while there is still time at the very end of the run (only 2 TRs)
                %make fixation cross dim
                if ~fix_dimmed & GetSecs > start_block_time + next_fix % if not dimmed and time for next fixation dimming
                    %dim fixation cross
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), GRAY_INDEX);%set fixation to dim
                    end
                    fix_dimmed=1;
                    fix_start=GetSecs;
					% if collecting responses for fixation task.
					
					trial_num=trial_num+1;
					behav=[behav; trial_num, 0, 0, epoch_order(run, epoch_num), run];%first zero for if got resp, next one rt
					check_resp=1;%set flag for getting responses
					start_resp_time=GetSecs;
                end
		
                if fix_dimmed & GetSecs > fix_start+fix_stim % if fix dimmed and length of fix dim has passed (.44)
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);% turn it back to white
                    end
                    fix_dimmed=0;
                    next_fix = next_fix + fix_stim + between_fix_dur + rand * fix_rand_coef;% Varies fixation dimming between some minimum amount of time
					% (between fix dur) and some maxiumum amount of time (fix_rand_coef). In this case, it varies between 2 and 4 seconds
                end
				if check_resp %if collecting responses
					[keyIsDown, secs, keycode] = kbcheck; %check response
					if find(keycode(resp)) %resp not trigger
						behav(trial_num, 2)=1;%1 for hit response
						behav(trial_num, 3)=GetSecs -start_resp_time;%enter resp time. %%% where is start_resp_time first set?
						check_resp=0; %stop checking
					elseif GetSecs - start_resp_time > response_time %if time for subject to respond has passed, stop checking
						check_resp=0;
					end
				end
            end % end of while
            start_block_time=GetSecs; %reset start block time
		
            if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);
            end
		
        end % end of rest period at the end of the run
		
        %%% rest conditions before expectation (all long, short, and catch) blocks%%%
        if epoch_order(run, epoch_num) == rest & ...
			epoch_order(run, epoch_num + 1) ~= exp_passive & ...
			epoch_order(run, epoch_num + 1) ~= end_per
			
			expected_accum_time = expected_accum_time + 14.4;

			%if you have a rest period and the next block is not passive nor the end of the run, 
			%then present a cue. note that the cue that is presented during this rest block is the cue for next, upcoming trial.
            %disp 'rest block'
			%beep1_played = 0;
			beep3_played =0;
            %%%% fixation cross is being dimmed%%%%
            while GetSecs < start_block_time + rest_length %for the length of the rest time (14.4 sec)
				
				if epoch_order(run, epoch_num - 1) ~= vis_stim_passive ...
					& GetSecs > start_block_time + time_till_beep3 ...
					& beep3_played == 0
					
					Snd('Play', beep3);
					beep3_played = 1;
 					%disp 'reorient beep';
				end
				
                %make fixation cross dim
                if ~fix_dimmed & GetSecs > start_block_time + next_fix % if not dimmed and time for next fixation dimming
                    %dim fixation cross
                    if showme, 
						SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), GRAY_INDEX);%set fixation to dim
					end
					% disp 'inside rest dimming on'
                    fix_dimmed=1;
                    fix_start=GetSecs;
					% if collecting responses for fixation task.
					trial_num=trial_num+1;
					behav=[behav; trial_num, 0, 0, epoch_order(run, epoch_num), run];%first zero for if got resp, next one rt
					check_resp=1;%set flag for getting responses
					start_resp_time=GetSecs;
					
                end

                if fix_dimmed & GetSecs > fix_start+fix_stim % if fix dimmed and length of fix dim has passed (.44)
                    if showme, 
						SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);% turn it back to white
					end
					% disp 'inside rest dimming off'
                    fix_dimmed=0;
                    next_fix = next_fix + fix_stim + between_fix_dur + rand*fix_rand_coef;% Varies fixation dimming between some minimum amount of time
					% (between fix dur) and some maxiumum amount of time (fix_rand_coef). In this case, it varies between 2 and 4 seconds
                end
				if check_resp %if collecting responses
					[keyIsDown, secs, keycode] = kbcheck; %check response
					if find(keycode(resp)) %resp not trigger
						behav(trial_num, 2)=1;%1 for hit response
						behav(trial_num, 3)=GetSecs -start_resp_time;%enter resp time. %%% where is start_resp_time first set?
						check_resp=0; %stop checking
					elseif GetSecs - start_resp_time > response_time %if time for subject to respond has passed, stop checking
						check_resp=0;
					end
				end
				%add a beep 2 sec before the start of next exp_period
% 				if GetSecs > start_block_time + time_till_beep & beep1_played==0
% 					Snd('Play', beep1);
% 					beep1_played = 1;
% 					%disp 'beginning of trial beep'
% 				end	
				
                % present the cue for 1s duration after 9.5 seconds of rest,
				% turning it off at 10.5s, which is 0.5s before the end of the 11s rest period
				%
				% gjd - added & cue_is_on == 0
				if (GetSecs > start_block_time + time_till_cue) & ...
					(GetSecs < start_block_time + time_till_cue + cue_length) & ...
					(cue_is_on==0)
				
                    %draw cue. these are the two lateralized cue cases
					if left_right_order(run, epoch_num) == 10
                    	if showme
							SCREEN(wp,'DrawText','\',center(1)-20,center(2)-20,WHITE_INDEX);
                    	end
                    	cue_is_on = 1;
					end	
					if left_right_order(run, epoch_num) == 20
						if showme
							SCREEN(wp,'DrawText','/',center(1)+20,center(2)-20,WHITE_INDEX);
						end
						cue_is_on = 1;
					end
					% disp(sprintf('cue is on at %i',GetSecs))
                end
			
                if (GetSecs >= start_block_time + time_till_cue + cue_length) & (cue_is_on) %wait length of cue time
                  	if left_right_order(run, epoch_num) == 10
						% erase the left cue
                    	if showme
							SCREEN(wp,'FillRect',Bkcolor,[center(1)-30 center(2)-50 center(1)-5 center(2)-20]);
							%SCREEN(wp,'DrawText','\',center(1)-20,center(2)-20,Bkcolor);
                    	end
                    	cue_is_on = 0;
					end	
					if left_right_order(run, epoch_num) == 20
						% erase the right cue
						if showme
							SCREEN(wp,'FillRect',Bkcolor,[center(1)+20 center(2)-50 center(1)+50 center(2)-20]);
							%SCREEN(wp,'DrawText','/',center(1)+20,center(2)-20,Bkcolor);
						end
						cue_is_on = 0;
					end
					% disp(sprintf('cue is off at %i',GetSecs))
				end
				% disp(sprintf('end of cue loop at %i',GetSecs))
            end%end of while loop
            start_block_time=GetSecs; %reset start block time

            if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);
            end

        end % end of rest period before expectation blocks (other than passive)


        %%% rest conditions before passive blocks%%% and rest condition before the last block
        if (epoch_order(run, epoch_num) == rest & ...
			epoch_order(run, epoch_num + 1) == exp_passive) | ...
			(epoch_order(run, epoch_num) == rest & epoch_order(run, epoch_num + 1) == end_per)

			expected_accum_time = expected_accum_time + 14.4;

			%if you have a rest period and the next block is passive or the end of the experiment, then do NOT present a cue.
            %disp 'rest_block_before_passive or rest_block_before_end_block'
			%beep1_played = 0;
			beep3_played = 0; 
            %%%% fixation cross is being dimmed.
            while GetSecs < start_block_time + rest_length %for the length of the rest time (11 sec)
				
				if epoch_order(run, epoch_num - 1) ~= vis_stim_passive ...
					& GetSecs > start_block_time + time_till_beep3 ...
					& beep3_played == 0
					
					Snd('Play', beep3);
					beep3_played = 1;
 					%disp 'reorient beep';
				end
				
                %make fixation cross dim
                if ~fix_dimmed & GetSecs > start_block_time + next_fix % if not dimmed and time for next fixation dimming
                    %dim fixation cross
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), GRAY_INDEX);%set fixation to dim
                    end
                    fix_dimmed=1;
                    fix_start=GetSecs;
					
					% if collecting responses for fixation task.
					trial_num=trial_num+1;
					behav=[behav; trial_num, 0, 0, epoch_order(run, epoch_num), run];%first zero for if got resp, next one rt
					check_resp=1;%set flag for getting responses
					start_resp_time=GetSecs;
                end
				
                if fix_dimmed & GetSecs > fix_start+fix_stim % if fix dimmed and length of fix dim has passed (.44)
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);% turn it back to white
                    end
                    fix_dimmed=0;
                    next_fix= next_fix + fix_stim + between_fix_dur + rand*fix_rand_coef;% Varies fixation dimming between some minimum amount of time
					% (between fix dur) and some maxiumum amount of time (fix_rand_coef). In this case, it varies between 2 and 4 seconds
                end
				if check_resp %if collecting responses
					[keyIsDown, secs, keycode] = kbcheck; %check response
					if find(keycode(resp)) %resp not trigger
						behav(trial_num, 2)=1;%1 for hit response
						behav(trial_num, 3)=GetSecs -start_resp_time;%enter resp time. %%% where is start_resp_time first set?
						check_resp=0; %stop checking
					elseif GetSecs - start_resp_time > response_time %if time for subject to respond has passed, stop checking
						check_resp=0;
					end
				end
				%add a beep 2 sec before the start of next exp_period
% 				if GetSecs > start_block_time + time_till_beep & beep1_played==0
% 					Snd('Play', beep1);
% 					beep1_played = 1;
% 					%disp 'beginning of trial beep';
% 				end	
            end
            start_block_time=GetSecs; %reset start block time
			
            if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);
            end
			
        end % end of rest period before passive blocks
		
        %%%% expectation periods before passive viewing blocks or before catch trials%%%
        if epoch_order(run, epoch_num) == exp_passive | epoch_order(run, epoch_num) == exp_catch
			
			expected_accum_time = expected_accum_time + 8;
			
            %%%% fixation cross is being dimmed%%%
            %disp 'exp_catch or exp_passive'
            while GetSecs < start_block_time + long_exp_length %for the length of the long expectation period time (8.8 sec)
                %make fixation cross dim
                if ~fix_dimmed & GetSecs > start_block_time + next_fix % if not dimmed and time for next fixation dimming
                    %dim fixation cross
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), GRAY_INDEX);%set fixation to dim
                    end
                    fix_dimmed=1;
                    fix_start=GetSecs;
					if epoch_order(run, epoch_num) == exp_passive
						trial_num=trial_num+1;
						behav=[behav; trial_num, 0, 0, epoch_order(run, epoch_num), run];%first zero for if got resp, next one rt
						check_resp=1;%set flag for getting responses
						start_resp_time=GetSecs;
					end	
                end
				
                if fix_dimmed & GetSecs > fix_start+fix_stim % if fix dimmed and length of fix dim has passed (.44)
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);% turn it back to white
                    end
                    fix_dimmed=0;
                    next_fix = next_fix + fix_stim + between_fix_dur + rand*fix_rand_coef;% Varies fixation dimming between some minimum amount of time
					% (between fix dur) and some maxiumum amount of time (fix_rand_coef). In this case, it varies between 2 and 4 seconds
                end
				if check_resp & epoch_order(run, epoch_num) == exp_passive%if collecting responses during the exp_passive block
					[keyIsDown, secs, keycode] = kbcheck; %check response
					if find(keycode(resp)) %resp not trigger
						behav(trial_num, 2)=1;%1 for hit response
						behav(trial_num, 3)=GetSecs -start_resp_time;%enter resp time. %%% where is start_resp_time first set?
						check_resp=0; %stop checking
					elseif GetSecs - start_resp_time > response_time %if time for subject to respond has passed, stop checking
						check_resp=0;
					end
				end
            end
            start_block_time=GetSecs; %reset start block time.
			
            if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);
            end
			
        end % end of expectation periods before passive viewing or catch trials
		
        %%%% short expectation period%%%
        if epoch_order(run, epoch_num) == exp_short
			
			expected_accum_time = expected_accum_time + 3.2;
			
            %disp 'exp_short'
            %%%% fixation cross is being dimmed%%%
            while GetSecs < start_block_time + short_exp_length %for the length of the short expectation period time (2.2 sec)
                %make fixation cross dim
                if ~fix_dimmed & GetSecs > start_block_time + next_fix % if not dimmed and time for next fixation dimming
                    %dim fixation cross
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), GRAY_INDEX);%set fixation to dim
                    end
                    fix_dimmed=1;
                    fix_start=GetSecs;
                end

                if fix_dimmed & GetSecs > fix_start+fix_stim % if fix dimmed and length of fix dim has passed (.44)
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);% turn it back to white
                    end
                    fix_dimmed=0;
                    next_fix = next_fix + fix_stim + between_fix_dur + rand*fix_rand_coef;% Varies fixation dimming between some minimum amount of time
					% (between fix dur) and some maxiumum amount of time (fix_rand_coef). In this case, it varies between 2 and 4 seconds
                end
            end
            start_block_time=GetSecs; %reset start block time.
            if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);
            end

        end % end of the short expectation period

        %%%% long (standard) expectation period%%%
        if epoch_order(run, epoch_num) == exp_long
			
			expected_accum_time = expected_accum_time + 8;
			
            %disp 'exp_long'
            %%%% fixation cross is being dimmed%%%
            while GetSecs < start_block_time + long_exp_length %for the length of the long (standard) expectation period time (8.8 sec)
                %make fixation cross dim
                if ~fix_dimmed & GetSecs > start_block_time + next_fix % if not dimmed and time for next fixation dimming
                    %dim fixation cross
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), GRAY_INDEX);%set fixation to dim
                    end
                    fix_dimmed=1;
                    fix_start=GetSecs;
                end
				
                if fix_dimmed & GetSecs > fix_start+fix_stim % if fix dimmed and length of fix dim has passed (.44)
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);% turn it back to white
                    end
                    fix_dimmed=0;
                    next_fix = next_fix + fix_stim + between_fix_dur + rand*fix_rand_coef;% Varies fixation dimming between some minimum amount of time
					% (between fix dur) and some maxiumum amount of time (fix_rand_coef). In this case, it varies between 2 and 4 seconds
                end
            end
            start_block_time=GetSecs; %reset start block time.
            if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);
            end
			
        end % end of the long (standard) expectation period
		
        %%%% long plus one TR expectation period%%%
        if epoch_order(run, epoch_num) == exp_long_plusTR
			
			expected_accum_time = expected_accum_time + 9.6;
			
            %disp 'exp_long_plusTR'
            %%%% fixation cross is being dimmed%%%
            while GetSecs < start_block_time + long_exp_length_plusTR %for the length of the long + TR expectation period time (11 sec)
                %make fixation cross dim
                if ~fix_dimmed & GetSecs > start_block_time + next_fix % if not dimmed and time for next fixation dimming
                    %dim fixation cross
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), GRAY_INDEX);%set fixation to dim
                    end
                    fix_dimmed=1;
                    fix_start=GetSecs;
                end
				
                if fix_dimmed & GetSecs > fix_start+fix_stim % if fix dimmed and length of fix dim has passed (.44)
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);% turn it back to white
                    end
                    fix_dimmed=0;
                    next_fix = next_fix + fix_stim + between_fix_dur + rand*fix_rand_coef;% Varies fixation dimming between some minimum amount of time
					% (between fix dur) and some maxiumum amount of time (fix_rand_coef). In this case, it varies between 2 and 4 seconds
                end
            end
            start_block_time=GetSecs; %reset start block time.
            if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);
            end
			
        end % end of the long + one TR expectation period
		
        %%%% long minus one TR expectation period%%%
        if epoch_order(run, epoch_num) == exp_long_minusTR
			
			expected_accum_time = expected_accum_time + 6.4;
			
            %disp 'exp_long_minusTR'
            %%%% fixation cross is being dimmed%%%
            while GetSecs < start_block_time + long_exp_length_minusTR %for the length of the long minus TR expectation period time (6.6 sec)
                %make fixation cross dim
                if ~fix_dimmed & GetSecs > start_block_time + next_fix % if not dimmed and time for next fixation dimming
                    %dim fixation cross
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), GRAY_INDEX);%set fixation to dim
                    end
                    fix_dimmed=1;
                    fix_start=GetSecs;
                end
				
                if fix_dimmed & GetSecs > fix_start+fix_stim % if fix dimmed and length of fix dim has passed (.44)
                    if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);% turn it back to white
                    end
                    fix_dimmed=0;
                    next_fix = next_fix + fix_stim + between_fix_dur + rand*fix_rand_coef;% Varies fixation dimming between some minimum amount of time
					% (between fix dur) and some maxiumum amount of time (fix_rand_coef). In this case, it varies between 2 and 4 seconds
                end
            end
            start_block_time=GetSecs; %reset start block time.
            if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);
            end
			
        end % end of the long minus one TR expectation period
		
   		% this is where hilda had the fix_dimmed code		
		
        if epoch_order(run, epoch_num) == vis_stim | epoch_order(run, epoch_num) == vis_stim_passive % if the block is a (peripheral) visual stimulation block
		
			expected_accum_time = expected_accum_time + 8;
			
			%disp('vis_stim or vis_stim_passive')
			
			start_block_time=GetSecs; %reset start block time.
			
			% display dots in top left
			if left_right_order(run, epoch_num)==1
				% this is a slightly cumbersome way of horizontally reflecting the x points
				% in the center (since they're set up for the top right by default)
				curxmin = -xmax;
				curxmax = curxmin + (xmax - xmin);
			end
			% display dots in top right
			if left_right_order(run, epoch_num)==2
				% xmin and xmax are set up above for top right, so we don't need to 
				% modify them at all
				curxmin = xmin;
				curxmax = xmax;
			end
			
			% we're not messing with ymin or ymax at all, since all the action in this 
			% experiment is happening in the upper quadrants
		
			% uncomment these if you'd like to see the two dot-squares displayed,
			% so you can get out your tape measure
			% Screen(wp,'FillRect',WHITE_INDEX,[xmin+center(1) ymin+center(2) xmax+center(1)+3 ymax+center(2)+3]);			
			% Screen(wp,'FillRect',WHITE_INDEX,[xmin+center(1) ymin+center(2) xmax+center(1)+3 ymax+center(2)+3]);
				
          [behav, trial_num] = do_vis_stim5(wp, start_block_time, target_length, ...
                       					ndots, center, curxmin, curxmax, ymin, ymax, vis_stim_passive, ...
                       					stim_per_block, targ_min, targ_max, colors, pfs, stim_length, ...
                       					fix_dimmed, do_fix, between_fix_dur, next_fix, fix_rand_coef, ...
										p.frame_rate, fix_cord, fix_stim, ...
                       					WHITE_INDEX, GRAY_INDEX, epoch_order, run, epoch_num, ...
                       					showme, trial_num, behav, response_time, Bkcolor, resp, motion_coh);
										
		%disp ('saving')
		%save
                    
	   end % end of if statement for the visual stimulus (for 8 sec).
			   
        if fix_dimmed%make sure fix not dimmed before start block
            if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);
            end
        end
        fix_dimmed=0;
		
		
        %once done with whole visual presentation block, you want to erase dots
        %erase dots
        dots(1:2:2*ndots-1, 1:2)=dots(2:2:2*ndots, 1:2);
        if showme, DrawDots(wp, dots(1:2:2*ndots-1, :), center);
        end
		
        if showme, SCREEN(wp,'DrawText','+', fix_cord(1),fix_cord(2), WHITE_INDEX);
        end
		
    end%end of MAIN WHILE LOOP THAT DRIVES EACH RUN (for total time of run)

    run % states what run the program is on
    total_run_time=GetSecs-start_run_time
	
% 	behav=[behav; trial_num, 0, 0, epoch_order(run, epoch_num), run]
	temp=[];
    temp=behav(:, 5)==run & behav(:,4)==1; %all rows of run just completed,
    temp=find(temp);%get indexes of rows
    [Ltemp, Ctemp]=size(temp); %how many trials 
    
    num_corr=0;
    if Ltemp>0 % if have some trials
        for k=1:Ltemp
        	if behav(temp(k), 2)==1 %got correct
            	num_corr=num_corr+1;
			end        
		end
		if Ltemp > 0
			run_behav=(num_corr/Ltemp)*100;
		else
			run_behav=0;
		end
    end

end%END OF FOR LOOP for EACH RUN. ONE RUN IS DONE WHEN THE PROGRAM GETS HERE

avg_data=[];
final_avg_behav=[];

%trials_per_epoch=4;
ntrial=1;
while ntrial < trial_num % while the number of trials has not been exceeded
    ttrial=ntrial;
    backin=1;
    while ttrial<trial_num & behav(ttrial+1, 4)==behav(ttrial, 4)%how many of the next rows are from the 
		%same block
        ttrial=ttrial+1;
    end
	
    rt=0;
    temp=behav(ntrial:ttrial, 2)==1;%figure out the indices of the trials from the current block 
	% that are correct.
    temp=find(temp);
    Ltemp=length(temp); %count how many right
    ntrial;
    ttrial;
    condition=behav(ntrial, 4);%set condition to be the fourth column of behav. figures out which blcok
	%is which
    num_corr=Ltemp/(ttrial-ntrial +1);%find the proportion within the block that are correct
    if Ltemp > 0 %if got some right
        for k=1:Ltemp%for the number of possible correct answers in an epoch
            rt=rt+ behav((ntrial-1+temp(k)), 3);%calculate cumulative sum of RTs
        end
        avg_data=[avg_data; condition, num_corr, rt/Ltemp];%avg_data is a matrix that contains
		% condition in column 1, number of correct in column 2, and average RT for that given condition in
		%column 3
    else %didn't get any right
        avg_data=[avg_data; condition, num_corr, -1];%marking epochs where there was none correct as -1
    end
    ntrial=ntrial+ttrial-ntrial+1;%????? ntrial = ttrial +1??
end

for cond=1:nconds %nconds = the total number of conditions in the design
    temp=avg_data(:, 1)==cond; %find all of the trials that match a given condition
    temp=find(temp);%find the indices of those trials
    Ltemp=length(temp); %how many epochs of given condition
    rt=0;
    num_corr=0;
    if Ltemp>0 % if have some epochs
        for k=1:Ltemp
            if avg_data(temp(k),3) ~=-1 %if there were some correct trials in the given epoch
                rt=rt+ avg_data(temp(k), 3); % average over all of the trials in that particular condition
            end
            num_corr=num_corr+ avg_data(temp(k), 2);%getting number correct
        end
        final_avg_behav=[final_avg_behav; cond, num_corr/Ltemp, rt/Ltemp];
    end
end

final_avg_behav

filename_all = [filename '.mat'];
filename_behav_text = [filename '_behav.txt'];
filename_final_avg_behav_text = [filename '_final_avg.txt'];

save(filename_all);%saves everything in the workspace to a .mat file
save(filename_behav_text, '-ascii', 'behav');%saves behav data into ascii file
save(filename_final_avg_behav_text, '-ascii', 'final_avg_behav');%saves final_avg_behav into an ascii file

if showme, SCREEN('CloseAll');
end


ShowCursor;


