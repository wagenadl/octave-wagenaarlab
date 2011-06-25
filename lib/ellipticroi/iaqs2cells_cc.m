function iaqs2cells(ifnbase,ofn,shftfn,elfn)
% IAQS2CELLS(ifnbase,ofn,sftfn,elfn) loads a series of .iaq files, 
% and extracts the mean and sem of optical data from each of them.
% IFNBASE may contain a '.iaq'. If not, '-%03i.iaq' is appended automatically.

if isempty(shftfn)
  shf='';
else
  shf = load(shftfn);
end

elps = load(elfn);

if isempty(ofn)
  ofn = [ifnbase '-cells.mat'];
end

if isempty(strfind(ifnbase,'.iaq'))
  ifnbase = [ ifnbase '-%03i.iaq' ];
end

idx = [];
for k=1:999
  fn = sprintf(ifnbase,k);
  if exist(fn)
    fprintf(1,'IAQS2CELLS: Working on %s...\n',fn);
    fprintf(1,'  Loading... ');
    x2=load(fn,'-mat');
    fprintf(1,'Shifting... ');
    ods = useshift(x2,shf);
    fprintf(1,'Getting ROIs... ');
    [mn,st,nn] = meanellipticrois(ods,[elps.e1 elps.e2]);
    fprintf(1,'Done\n');
    
    V1_mV{k} = x2.ephys_data(:,1)*100;  % Electrode 1 voltage
    V2_mV{k} = x2.ephys_data(:,2)*1000; % Electrode 2 voltage
    I1_nA{k} = x2.ephys_data(:,3)*100;  % Electrode 1 current
    I2_nA{k} = x2.ephys_data(:,4)*10;   % Electrode 2 current
    ephys_tms{k} = x2.t_e;
    
    if length(x2.t_o) == size(mn,1)
      % Normal situation
      cc_mean{k} = mn(1:1:end,:);
      cc_sem{k} = st(1:1:end,:)./sqrt(nn(1:1:end,:));
      cc_tms{k} = x2.t_o(1:1:end);
    else
      % Single snapshot
      cc_mean{k} = mn(1:4,:);
      cc_sem{k} = st(1:4,:)./sqrt(nn(1:4,:));
      cc_tms{k} = [.2 .25]'; % Not so great, but oh well...
    end
    idx = [idx; k];
  end
  if strcmp(fn,ifnbase) % If there's no %i, do just one file!
    break;
  end
end

opt_npix = nn;

fprintf(1,'IAQS2CELLS: Saving %s...\n',ofn);

save(ofn,'elps','opt_npix','idx',...
    'V1_mV','V2_mV','I1_nA','I2_nA','ephys_tms',...
    'cc_mean','cc_sem','cc_tms');

    