% function new_ECG_preproc
% 
% parametri da passare: H_Fs
%                       ECG
%================================== INI program of preprocessing ===============================================    
Freq=H_Fs;
if(Freq==500),fprintf('* * * * *frequency:500Hz   size(ECG)=%3.0f%6.0f\n',size(ECG));
else
    fprintf('Frequency:%6.0f\n',Freq);
    ECG=Interpolation(ECG',Freq,500);
    ECG=ECG';
   fprintf('freq:%6.0f  -> resampled at 500Hz   size ECG:%4.0f%8.0f\n', Freq,size(ECG))

end
   Hz=500;
%        tttemp=Interpolation(ECG',Freq,500);

%Prova_tools
%     Zero_Leads=sum((ECG),2)==0;
%     fprintf(' Zero_leads:');fprintf('%2.0f',Zero_Leads);fprintf('%1.0f',Zero_Leads); fprintf('\n');
%     Zero_Leads=sum(abs(ECG),2)==0;
%     fprintf(' Zero_leads:');fprintf('%2.0f',Zero_Leads);fprintf('%1.0f',Zero_Leads); fprintf('\n');
    ECG=ECG/1000;
    
%     Zero_Leads=sum(ECG,2)==0;
%     fprintf(' Zero_leads:');fprintf('%2.0f',Zero_Leads);fprintf('%1.0f',Zero_Leads); fprintf('\n');
    
     if(size(ECG,2)>4999)
         ECG_new=ECG(:,1:5000);
     else
         ECG_new=ECG; ECG_new(:,5000)=0;
     end
     fprintf('MIN:%10.4f MAX:%10.4f  ',min(ECG_new(:)),max(ECG_new(:)));
     ECG_col=ECG_new';    % ECG_col -> (samples, leads)
     fprintf('baseline_drift:');DRIFT=ECG_col*0;
    for ii_Lds=1:size(ECG_col,2)
         DRIFT(:,ii_Lds)=comp_bas_drift(ECG_col(:,ii_Lds));
         fprintf('%3.0f',ii_Lds);
    end
    ECG_col=ECG_col-DRIFT;
    fprintf('  size ECG_col:%6.0f%6.0f\n',size(ECG_col));
    
    
     a=1; b=[]; b(1:10)=1/10; 
   ECG_filtered=filter(b,a,ECG_col);  %fprintf('----- size ECG_filtered:%6.0f%6.0f\n',size(ECG_filtered));
     
     ECG=ECG_filtered';
     ECG=min(ECG,2);
     ECG=max(-2,ECG);
     
     fprintf(' ECG_filtered: %2.0f %6.0f  new_ECG:%4.0f%6.0f  min:%10.4f max:%10.4f\n',size(ECG_filtered),size(ECG),min(ECG(:)),max(ECG(:)));
     fprintf('SUM_ecg:');fprintf('%10.0f',sum(abs(ECG),2));fprintf('\n');

    I=ECG(1,:); II=ECG(2,:); III=ECG(3,:);
    aVR=ECG(4,:); aVL=ECG(5,:); aVF=ECG(6,:);
    V1=ECG(7,:); V2=ECG(8,:); V3=ECG(9,:);
    V4=ECG(10,:); V5=ECG(11,:); V6=ECG(12,:);

    
    
% % %    [A,a]=find(I>2); I(a)=2; [A,a]=find(II>2); II(a)=2;
% % %    [A,a]=find(III>2); III(a)=2;[A,a]=find(V1>2); V1(a)=2;
% % %    [A,a]=find(V2>2); V2(a)=2;[A,a]=find(V3>2); V3(a)=2;
% % %    [A,a]=find(V4>2); V4(a)=2; [A,a]=find(V5>2); V5(a)=2;
% % %    [A,a]=find(V6>2); V6(a)=2;
% % % 
% % %     [A,a]=find(I<-2); I(a)=-2; [A,a]=find(II<-2); II(a)=-2;
% % %     [A,a]=find(III<-2); III(a)=-2;[A,a]=find(V1<-2); V1(a)=-2;
% % %     [A,a]=find(V2<-2); V2(a)=-2;[A,a]=find(V3<-2); V3(a)=-2;
% % %     [A,a]=find(V4<-2); V4(a)=-2; [A,a]=find(V5<-2); V5(a)=-2;
% % %     [A,a]=find(V6<-2); V6(a)=-2;
% % % 
% % % 
%======================================================================
%		Preprocessing
%======================================================================n=7;					% 7*2 = 14 ms smoothing interval on each side
% % % T=1/Hz;					% [s] sampling period
% % % Fc=0.64;				% [Hz]
% % % a=1; b=[1 1 1 1 1 1 1 1 1 1]/10;
% % % n=7;
% % % 
% % %  X=I;        Y=filter(b,a,X);        % 50 Hz
% % %  X=Y;        [Y]=smooth(X,n);			% Smoothing
% % %  X=Y;		[Y]=drift_Ivo(X,Fc,T);	I=Y;	% Drift filtration
% % %  
% % %  X=II;       Y=filter(b,a,X);        % 50 Hz
% % %  X=Y;        [Y]=smooth(X,n);			% Smoothing
% % %  X=Y;		[Y]=drift_Ivo(X,Fc,T);	II=Y;	% Drift filtration
% % %  
% % %  X=V1;       Y=filter(b,a,X);        % 50 Hz
% % %  X=Y;        [Y]=smooth(X,n);			% Smoothing
% % %  X=Y;		[Y]=drift_Ivo(X,Fc,T);	V1=Y;	% Drift filtration
% % %  
% % %  X=V2;       Y=filter(b,a,X);        % 50 Hz
% % %  X=Y;        [Y]=smooth(X,n);			% Smoothing
% % %  X=Y;		[Y]=drift_Ivo(X,Fc,T);	V2=Y;	% Drift filtration
% % %  
% % %  X=V3;       Y=filter(b,a,X);        % 50 Hz
% % %  X=Y;        [Y]=smooth(X,n);			% Smoothing
% % %  X=Y;		[Y]=drift_Ivo(X,Fc,T);	V3=Y;	% Drift filtration
% % %  
% % %  X=V4;       Y=filter(b,a,X);        % 50 Hz
% % %  X=Y;        [Y]=smooth(X,n);			% Smoothing
% % %  X=Y;		[Y]=drift_Ivo(X,Fc,T);	V4=Y;	% Drift filtration
% % %  
% % %  X=V5;       Y=filter(b,a,X);        % 50 Hz
% % %  X=Y;        [Y]=smooth(X,n);			% Smoothing
% % %  X=Y;		[Y]=drift_Ivo(X,Fc,T);	V5=Y;	% Drift filtration
% % %  
% % %  X=V6;       Y=filter(b,a,X);        % 50 Hz
% % %  X=Y;        [Y]=smooth(X,n);			% Smoothing
% % %  X=Y;		[Y]=drift_Ivo(X,Fc,T);	V6=Y;	% Drift filtration
% % %  


 %===================================   END program of classification ==================
 
 
 
