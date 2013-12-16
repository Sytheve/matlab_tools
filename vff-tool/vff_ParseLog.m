function fdata = vff_ParseLog(pfname)
% vff_ParseLog Parse a par file generated by vff macro.
%
%   log = vff_ParseLog(fileName) reads the vff par file
%   with the name fileName and returns the information in an array of
%   structures with fields:
%       imroot    : image root name
%       imnumber  : image number
%       imexptime : image exposure time
%       imcttime  : count time
%       ic_e_1    : ic e 1 counts
%       ic_e_2    : ic e 2 counts
%       ic_e_3    : ic e 3 counts
%       ic_e_4    : ic e 4 counts
%       ic_e_5    : ic e 5 counts
%       ic_e_6    : ic e 6 counts
%       ic_e_7    : ic e 7 counts
%       ic_e_8    : ic e 8 counts
%       ssd       : ssd
%       bp_e_us   : upstream beam position
%       bp_e_ds   : downstream beam position
%       LN2_temp  : LN2 temp
%       ic_b_1    : ic b 1 counts
%       SRcurrent : ring current
%       TempA     : TempA
%       ic_b_3    : ic b 3 counts
%       ic_b_5    : ic b 5 counts
%       federal   : federal gage output
%       usslit_x  : upstream slits x
%       usslit_y  : upstream slits y
%       usslit_b  : upstream slits bottom
%       usslit_t  : upstream slits top
%       usslit_ib : upstream slits in-board
%       usslit_ob : upstream slits out-board
%       dsslit_b  : downstream slits bottom
%       dsslit_t  : downstream slits top
%       dsslit_ib : downstream slits in-board
%       dsslit_ob : downstream slits out-board
%       aero_x    : aerotech stage x
%       aero_z    : aerotech stage z
%       aero_phi  : aerotech stage phi
%       lns1_y    : lens 1 y
%       lns1_th   : lens 1 th
%       lns1_chi  : lens 1 chi
%       lns2_y    : lens 2 y
%       lns2_th   : lens 2 th
%       lns2_chi  : lens 2 chi
%       ge_x      : GE x position
%       vff_eta   : vff_eta position
%       vff_r     : vff_r position

%%% CHECK IF FILE EXISTS
fid = fopen(pfname, 'r');
if(fid == -1)
    beep;
    error('Cannot open file:\n  %s\n', pfname);
end

%%% START READING IN DATA FROM FILE
lindata = textscan(fid, '%s %s %f %s %f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');

%%% PARSE DATA INTO STRUCTURE ARRAY
fdata.day   = lindata{1};
fdata.month = lindata{2};
fdata.date  = lindata{3};
fdata.time  = lindata{4};
fdata.year  = lindata{5};

fdata.imroot    = lindata{6};
fdata.imnumber  = lindata{7};
fdata.imexptime = lindata{8};
fdata.imcttime  = lindata{9};
fdata.ic_e_1    = lindata{10};
fdata.ic_e_2    = lindata{11};
fdata.ic_e_3    = lindata{12};
fdata.ic_e_4    = lindata{13};
fdata.ic_e_5    = lindata{14};
fdata.ic_e_6    = lindata{15};
fdata.ic_e_7    = lindata{16};
fdata.ic_e_8    = lindata{17};
fdata.ssd       = lindata{18};
fdata.bp_e_us   = lindata{19};
fdata.bp_e_ds   = lindata{20};
fdata.LN2_temp  = lindata{21};
fdata.ic_b_1	= lindata{22};
fdata.SRcurrent = lindata{23};
fdata.TempA     = lindata{24};
fdata.ic_b_3    = lindata{25};
fdata.ic_b_5    = lindata{26};
fdata.federal   = lindata{27};
fdata.usslit_x  = lindata{28};
fdata.usslit_y  = lindata{29};
fdata.usslit_b  = lindata{30};
fdata.usslit_t  = lindata{31};
fdata.usslit_ib = lindata{32};
fdata.usslit_ob = lindata{33};
fdata.dsslit_b  = lindata{34};
fdata.dsslit_t  = lindata{35};
fdata.dsslit_ib = lindata{36};
fdata.dsslit_ob = lindata{37};
fdata.aero_x    = lindata{38};
fdata.aero_z    = lindata{39};
fdata.aero_phi  = lindata{40};
fdata.lns1_y    = lindata{41};
fdata.lns1_th   = lindata{42};
fdata.lns1_chi  = lindata{43};
fdata.lns2_y    = lindata{44};
fdata.lns2_th   = lindata{45};
fdata.lns2_chi  = lindata{46};
fdata.ge_x      = lindata{47};
fdata.vff_eta   = lindata{48};
fdata.vff_r     = lindata{49};

fclose(fid);