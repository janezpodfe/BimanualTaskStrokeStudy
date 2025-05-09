global tg 
%global HMgui_handle 

tg = xpctarget.xpc('HM');
load(tg,'HM_to_Unity_2013a');

HMgui_handle = HM_UI;

%input_param = getparamid(tg, 'Damping', 'Value');
%setparam(tg, input_param, '4');

%global fileName;
%fileName = 'saveDataToFile';

%uiopen(fileName,1);


tg.start
%tg.stop
