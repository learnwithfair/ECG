%program to get QRS Peaks and Heart Rate from ECG signal
[filename,pathname]=uigetfile('*.*','Select the ECG Signal');
filewithpath=strcat(pathname,filename);
Fs=input('Enter Sampling Rate : ');
ecg=load(filename);%Reading ECG signal
ecgsig=(ecg.val)./200;%Normalize gain
t=1:length(ecgsig);%No of samples
tx=t./Fs;%Getting Time Vector
wt=modwt(ecgsig,4,'sym4');%4-level undecimated DWT using sym4
wtrec=zeros(size(wt));
wtrec(3:4,:)=wt(3:4,:);%Extracting only d3 and d4 coefficients

y=imodwt(wtrec,'sym4');%IDWT with only d3 annd d4
y=abs(y).^2;%Magnitude square
avg=mean(y);%Getting average of y^2 as threshold
%Finding Peaks
[Rpeaks,locs]=findpeaks(y,t,'MinpeakHeight',8*avg,'MinPeakDistance',50);
nohb=length(locs);%No of beats
timelimit=length(ecgsig)/Fs;
hbpermin=(nohb*60)/timelimit;%Getting BPM
disp(strcat('Heart Rate = ',num2str(hbpermin)))
subplot(211)
plot(tx,ecgsig);

xlim([0,timelimit]);
grid on;
xlabel('Seconds')
title('ECG Signal')

subplot(212)
plot(t,y)
grid on;
xlim([0,length(ecgsig)]);
hold on
plot(locs,Rpeaks,'ro')
xlabel('Samples')
title(strcat('R Peaks found and Heart Rate : ',num2str(hbpermin)))


