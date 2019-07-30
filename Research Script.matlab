clear all
close all
sample_rate = 2000; %sampling rate
multV = 10000; %convert to mV(10000) or V(100)
ylbl = "Volts(V)";
ylm = 2; %y amplitude limit on axis
xlm = 5; %number of seconds displayed
H=dsp.AudioRecorder('BufferSizeSource','Property','BufferSize',100,'SamplesPerFrame',100,'SampleRate',sample_rate,'NumChannels',1);
A=animatedline;
B = animatedline('color', 'r');
%('MaximumNumPoints',1920000);
S=H.SamplesPerFrame;
m=0;
grid on;
xlabel("Time(sec)");
ylabel(ylbl)
%startTime = datetime('now');
%ax = axes(A);
%ax.Units = 'pixels';
%ax.Position = [75 75 325 280]);
stopbtn = uicontrol('style','pushbutton',...
              'string', 'Stop',...
              'callback', @StopButton, ...
              'position',[0 0 70 25], ...
              'UserData', 1);
pausebtn = uicontrol('style','pushbutton',...
              'string', 'Pause',...
              'callback', @PauseButton, ...
              'position',[75 0 70 25], ...
              'UserData', 1);
          avgpeaks = zeros(1, 10);
          maxdata = zeros(1, 100);
          maxdata(1) = 2;
i = 1;
j = 1;
avg = 0;
while get(stopbtn, 'UserData') == 1
  if get(pausebtn, 'UserData') == 1
   frame= -1 * step(H);
   frame = frame / 2 * multV;
   %data(i) = frame(i);
   peaks = findpeaks(frame);%,'Threshold', 0.25);
   %avg = mean(peaks);
   avgpeaks(j) = mean(peaks);
   avg = mean(avgpeaks);
   maxdata(i) = max(frame);
   if(i == 100)
        i = 0;
   end
    if(j == 10)
        i = 0;
    end
    i = i + 1;
   M=m:(m+(S-1));
   %t = datetime('now') - startTime;
   %x = datenum(t)*100000;
   t =  M/sample_rate;
   %if (abs(frame(1)) < (ylm/30)) %|| (abs(frame(2000) > ylm/3))
   %   frame = frame * 0;
   %end
   addpoints(A,t,frame)
   addpoints(B,t(1),avg)
   drawnow %limitrate
   m=m+S;
   x = t(1);
   axis([x-xlm x -1*max(maxdata)*1.1 max(maxdata)*1.1])
   %ylim([-100 100]);
   %set(gca, 'XLim', [M-m, m+S], 'YLim', [-100. 100]);
  end
   while get(pausebtn, 'UserData') == 0
      if get(stopbtn, 'UserData') == 0
        break;
      end
      pause(0.01);
   end
end
  function StopButton(object_handle, event)
        set(object_handle, 'UserData', 0);
  end
    function PauseButton(object_handle, event)
      if get(object_handle, 'UserData') == 1
        set(object_handle, 'String', 'Resume');
        set(object_handle, 'UserData', 0);
      else
        set(object_handle, 'String', 'Pause');
        set(object_handle, 'UserData', 1);
      end
    end
