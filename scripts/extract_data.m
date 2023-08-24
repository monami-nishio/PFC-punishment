% For 2 tone task based on lever_ts6

function [behavior,history] = extract_data(filename,b_base,varargin)
% b_baseが1の時 sliding modeの時にBの最大成功率の20分間に合わせる(Aの成功率は無視)
%% Import LVM file
fprintf('Importing LVM file: %s ...',filename);
Raw = lvm_import(filename,0); % Reading lvm file %
fprintf(' done.\n')

%% Extract data from lvm file
behavior.rawlever      =  Raw.Segment1.data(:,1); 
behavior.lever      =  Raw.Segment1.data(:,1);              % Lever position, raw data %
behavior.lick       =  Raw.Segment1.data(:,2);              % Lick
behavior.reward     =  Raw.Segment1.data(:,3);              % Reward (pump shot)
behavior.gocue      =  Raw.Segment1.data(:,4);   
behavior.ToneA      =  Raw.Segment1.data(:,5);              % Tone-A (6Hz)
behavior.ToneB      =  Raw.Segment1.data(:,6);              % Tone-B (10Hz)
behavior.airpuff    =  Raw.Segment1.data(:,7);              

behavior.state      =  Raw.Segment1.data(:,end-1);          % Information of Lever position %
behavior.task_state =  Raw.Segment1.data(:,end);            % Information of Sound cuing task %
behavior.rate       =  str2double(filename(end-9:end-6));   % sampling rate%

%% Input arguments check
sample_rate = behavior.rate;
switch nargin
    case 2
        slide_dur = 10 * sample_rate * 60;   % 10 min
        Start = 10 * sample_rate;       % (frames)
        End = 10e24 * sample_rate;    % (frames)
        mode = 'slide';
        fprintf('========= Sliding time-window mode =========\n');
    case 3
        slide_dur = varargin{1} * sample_rate;  % (frames)
        Start = 10 * sample_rate;       % (frames)
        End = 10e24 * sample_rate;    % (frames)
        mode = 'slide';
        fprintf('========= Sliding time-window mode =========\n');
    case 4
        slide_dur = 0;
        Start = varargin{1};            % (frames)
        End = varargin{2};              % (frames)
        mode = 'fix';
        fprintf('========= Fixed time-window mode =========\n');
    case 5
        slide_dur = varargin{1}* sample_rate;
        Start = varargin{2}* sample_rate;            % (frames)
        End = varargin{3}* sample_rate;              % (frames)
        mode = 'slide-fix';
        fprintf('========= Fixed time-window & Sliding mode =========\n');
    otherwise
        error('False input arguments.');
end
behavior.mode = mode;   % Mode for calculating Success rates

%% Pre-proccessing for Lever, Tone-cues and licking
% Lever
fprintf('Pre-proccessing: Lever...');
behavior.lever = fastsmooth(behavior.lever,21,1,1);
maxLever = max(behavior.lever);
minLever = min(behavior.lever);
behavior.lever = (behavior.lever-minLever)/(maxLever-minLever);
if any(behavior.lever<0)
    pn_sign = -1;
else
    pn_sign = 1;
end                          % decide whether gain is positive or negative
behavior.lever = pn_sign * Raw.Segment1.data(:,1);% if gain is positive, then the sign is positive, and vice versa
behavior.lever = fastsmooth(behavior.lever,21,1,1);% denoise again
maxLever = max(behavior.lever);
minLever = min(behavior.lever);
behavior.lever = (behavior.lever-minLever)/(maxLever-minLever);

behavior.lever(behavior.lever > prctile(behavior.lever,99)) = prctile(behavior.lever,99);
behavior.lever(behavior.lever < prctile(behavior.lever,2))  = prctile(behavior.lever,2);

% lick
fprintf('Lick...');
mmin = min(behavior.lick); mmax = max(behavior.lick);
behavior.lick = (behavior.lick - mmin)/(mmax - mmin); % Lick data is normalized to 0-1.
if any(behavior.lick<0)
    pn_sign = -1;
else
    pn_sign = 1;
end
behavior.lick = pn_sign * Raw.Segment1.data(:,2); % polarity check and fix
mmin = min(behavior.lick); mmax = max(behavior.lick);
behavior.lick = (behavior.lick - mmin)/(mmax - mmin); % Lick data is re-normalized to 0-1.

% Tone-A
fprintf('Tone-A...');
mmin = min(behavior.ToneA);
mmax = max(behavior.ToneA);
behavior.ToneA = (behavior.ToneA - mmin)/(mmax - mmin); % cue data is normalized to 0-1.

% Tone-B
fprintf('Tone-B...');
mmin = min(behavior.ToneB);
mmax = max(behavior.ToneB);
behavior.ToneB = (behavior.ToneB - mmin)/(mmax - mmin); % cue data is normalized to 0-1.

% Reward
fprintf('Reward...');
mmin = min(behavior.reward);
mmax = max(behavior.reward);
behavior.reward = (behavior.reward - mmin)/(mmax - mmin); % Reward data is normalized to 0-1.

fprintf(' done.\n');

%% Initialize
behavior.gocue_idx  = []; % find when the cue is presented.
behavior.ToneA_idx  = []; % find when the cue is presented.
behavior.ToneB_idx  = []; % find when the cue is presented.
behavior.pull_idx   = []; % find when the lever is pulled.
behavior.pull_fin_idx = [];
behavior.lick_idx   = []; % find when the cue is presented.
behavior.lick_fin_idx = [];
behavior.reward_idx = []; % find when a reward is presented.
behavior.airpuff_idx = []; % find when a airpuff is presented.
behavior.success_idx = []; % find when the mouse pulls the lever successfully.

%% Information about lever-pull start, cue and reward (Modified Hira-san's demo)
TaskStart = Start+1;  % 10.001 s
TaskEnd = End; %3600000;  % 60 min
thre = 0.4;
state_dur = 1000;

% 記録時間以上の値を引数に入れた場合の処理
if length(behavior.lever) < TaskEnd-5000
    TaskEnd = length(behavior.lever) - 5000;
end

% 全レバー引きを検出
fprintf('Detection: Lever...');
for f = TaskStart:TaskEnd
    if behavior.lever(f-1) < thre && behavior.lever(f) >= thre
        behavior.pull_idx = [behavior.pull_idx,f];
    end
end

% レバーの引き終わりを検出
fprintf('Detection: Lever Finish...');
for f = TaskStart:TaskEnd
    if behavior.lever(f-1) >= thre && behavior.lever(f) < thre
        behavior.pull_fin_idx = [behavior.pull_fin_idx,f];
    end
end

% Lickの検出
fprintf('Lick...');
for f = TaskStart:TaskEnd % discard initial and last 5 sec to avoid bug.
    if behavior.lick(f-1) < 0.8 && behavior.lick(f) >= 0.8 %0.1
        behavior.lick_idx = [behavior.lick_idx,f];
    end
end

fprintf('Lick Finish...');
for f = TaskStart:TaskEnd % discard initial and last 5 sec to avoid bug.
    if behavior.lick(f-1) >= 0.8 && behavior.lick(f) < 0.8
        behavior.lick_fin_idx = [behavior.lick_fin_idx,f];
    end
end

% GoCue呈示の検出
fprintf('GoCue...');
for f = TaskStart:TaskEnd
    if behavior.gocue(f-1) < 0.1 && behavior.gocue(f) >= 0.1
        behavior.gocue_idx = [behavior.gocue_idx,f];
    end
end

% ToneA呈示の検出
fprintf('Tone-A...');
for f = TaskStart:TaskEnd
    if behavior.ToneA(f-1) >= 0.1 && behavior.ToneA(f) < 0.1
        behavior.ToneA_idx = [behavior.ToneA_idx,f];
    end
end

% ToneB呈示の検出
fprintf('Tone-B...');
for f = TaskStart:TaskEnd
    if behavior.ToneB(f-1) >= 0.1 && behavior.ToneB(f) < 0.1
        behavior.ToneB_idx = [behavior.ToneB_idx,f];
    end
end

% ToneB=Airpuff/Omission確率の低い音になるよう入れ替え
if length(behavior.ToneA_idx)>length(behavior.ToneB_idx)
    ToneA_idx = behavior.ToneA_idx;
    behavior.ToneA_idx = behavior.ToneB_idx;
    behavior.ToneB_idx = ToneA_idx;
    ToneA = behavior.ToneA;
    behavior.ToneA = behavior.ToneB;
    behavior.ToneB = ToneA;
end

% 報酬呈示（ポンプ駆動）の検出
fprintf('Reward...');
for f = TaskStart:TaskEnd
    if behavior.reward(f-1) < 0.1 && behavior.reward(f) >= 0.1
        behavior.reward_idx = [behavior.reward_idx,f];
    end
end

% Airpuff呈示の検出
fprintf('Airpuff...');
for f = TaskStart:TaskEnd
    if behavior.airpuff(f-1) < 0.1 && behavior.airpuff(f) >= 0.1
        behavior.airpuff_idx = [behavior.airpuff_idx,f];
    end
end

del_idx = [];
for t=2:length(behavior.reward_idx)
    if behavior.reward_idx(t)<behavior.reward_idx(t-1)+500
        del_idx = [del_idx t];
    end
end
behavior.reward_idx(del_idx)=[];

% VI側で定義されたtask_state（タスク状態，waiting：4，response window時：5，タスク成功：3）の検出
fprintf('Success...');
for f = TaskStart:TaskEnd
    if behavior.task_state(f-1) == 5 && behavior.task_state(f) < 5
        p = find(behavior.task_state(f-state_dur:f)==5);
        if numel(p) < state_dur 
            behavior.success_idx = [behavior.success_idx,f];
        end
    end
end

fprintf(' done.\n');

%% Preparation for calculation
fprintf('Preparing for calculation: A...');
behavior.success_ToneA=[];
if ~isempty(behavior.reward_idx)
    behavior.allRTtoToneA = zeros(size(behavior.ToneA)); % obtain RT.
    for t = 1:length(behavior.success_idx)
        a_tone = intersect(behavior.ToneA_idx,behavior.success_idx(t)-state_dur:behavior.success_idx(t));  % sound duration(100 msec) + 1 sec allowwance - pull time(200 msec)
        if isempty(a_tone)
            continue
        end % sound duration(100 msec) + 1 sec allowwance - pull time(200 msec)   
        a_pull = intersect(behavior.pull_idx,a_tone-200:a_tone+state_dur);
        if ~isempty(a_pull)
            behavior.allRTtoToneA(a_tone) = a_pull(1)-a_tone(1);
            behavior.success_ToneA = [behavior.success_ToneA a_tone];
        end
    end
end

fprintf('B...');
behavior.success_ToneB=[];
if ~isempty(behavior.reward_idx)
    behavior.allRTtoToneB = zeros(size(behavior.ToneB)); % obtain RT.
    for t = 1:length(behavior.success_idx)
        b_tone = intersect(behavior.ToneB_idx,behavior.success_idx(t)-state_dur:behavior.success_idx(t));
        if isempty(b_tone)
            continue
        end % sound duration(100 msec) + 1 sec allowwance - pull time(200 msec)
        b_pull = intersect(behavior.pull_idx,b_tone-200:b_tone+state_dur);
        if ~isempty(b_pull)
            behavior.allRTtoToneB(b_tone) = b_pull(1)-b_tone(1);
            behavior.success_ToneB = [behavior.success_ToneB b_tone];
        end
    end
end

fprintf(' done.\n');

%% History of events
fprintf('History of events...');
% initialize
AllTone_idx = sort([behavior.ToneA_idx behavior.ToneB_idx]);
AllGocue_idx = sort([behavior.gocue_idx]);
if length(AllTone_idx) ~= length(AllGocue_idx)
    tone_length = length(AllTone_idx);
    gocue_length = length(AllGocue_idx);
end
history.trial_idx = AllGocue_idx;
history.success = zeros(size(AllGocue_idx));
history.Cue1 = zeros(size(AllGocue_idx));
history.Cue2 = zeros(size(AllGocue_idx));
history.reward = zeros(size(AllGocue_idx));
history.airpuff = zeros(size(AllGocue_idx));
history.RTtoTone = zeros(size(AllGocue_idx));
history.consumatoryLick = zeros(size(AllGocue_idx));
history.anticipatoryLick = zeros(size(AllGocue_idx));
% sorting events
% success
for i = 1:min(length(AllTone_idx),length(AllGocue_idx))
    if ~isempty(intersect(sort([behavior.success_ToneA behavior.success_ToneB]),AllTone_idx(i)))
        history.success(i) = 1;
    else
        history.success(i) = 0;
    end
end

% Cue1
cue1 = 0;
for i = 1:min(length(AllTone_idx),length(AllGocue_idx))
    if ~isempty(intersect(behavior.ToneA_idx,AllTone_idx(i)))
        history.Cue1(i) = 1;
        cue1=cue1+1;
    else
        history.Cue1(i) = 0;
    end
end

% Cue2
for i = 1:min(length(AllTone_idx),length(AllGocue_idx))
    if ~isempty(intersect(behavior.ToneB_idx,AllTone_idx(i)))
        history.Cue2(i) = 1;
        cue1=cue1+1;
    else
        history.Cue2(i) = 0;
    end
end

% Reward
for i = 1:length(AllGocue_idx)
    if ~isempty(intersect(behavior.reward_idx,AllGocue_idx(i):AllGocue_idx(i)+state_dur))
        history.reward(i) = 1;
    else
        history.reward(i) = 0;
    end
end

% Airpuff
for i = 1:length(AllGocue_idx)
    if ~isempty(intersect(behavior.airpuff_idx,AllGocue_idx(i):AllGocue_idx(i)+state_dur))
        history.airpuff(i) = 1;
    else
        history.airpuff(i) = 0;
    end
end

% Earlly Pull
for i = 1:min(length(AllTone_idx),length(AllGocue_idx))
    %disp([AllTone_idx(i) AllGocue_idx(i)])
    if ~isempty(intersect(behavior.pull_idx,AllTone_idx(i):AllGocue_idx(i)))
        history.earlypull(i) = 1;
    else
        history.earlypull(i) = 0;
    end
end

% Reaction Time
for t = 1:length(AllGocue_idx)
    pt = intersect(behavior.pull_idx,AllGocue_idx(t):AllGocue_idx(t)+state_dur);
    if isempty(pt)
        history.RTtoTone(t) = NaN;
    else
        history.RTtoTone(t) = pt(1) - AllGocue_idx(t);
    end
end

% Anticipatory Lick Num
for i = 1:min(length(AllTone_idx),length(AllGocue_idx))
    %disp([AllTone_idx(i) AllGocue_idx(i)])
    pt = intersect(behavior.lick_idx,AllTone_idx(i):AllGocue_idx(i));
    if isempty(pt)
        history.anticipatoryLick(i) = NaN;
    else
        history.anticipatoryLick(i) = length(pt);
    end
end

% Consumatory Lick Num
for t = 1:length(AllGocue_idx)
    pt = intersect(behavior.lick_idx, AllGocue_idx(t):AllGocue_idx(t)+state_dur);
    if isempty(pt)
        history.consumatoryLick(t) = NaN;
    else
        history.consumatoryLick(t) = length(pt);
    end
end

fprintf(' done.\n');

%% Calculating success rate %
fprintf('Calculating Success rate: ');
switch mode
    case 'fix'
        fprintf('fix mode...');
        behavior.successNumA = numel(behavior.success_ToneA);
        behavior.successNumB = numel(behavior.success_ToneB);
        behavior.successRateA = numel(behavior.success_ToneA) / numel(behavior.ToneA_idx) * 100;
        behavior.successRateB = numel(behavior.success_ToneB) / numel(behavior.ToneB_idx) * 100;
        if isnan(behavior.successRateA)
            behavior.successRateA = 0;
        elseif isnan(behavior.successRateB)
            behavior.successRateB = 0;
        end
    otherwise
        fprintf('Sliding mode...');
        behavior.successNumA = numel(behavior.success_ToneA);
        behavior.successNumB = numel(behavior.success_ToneB);
        if strcmp(mode,'slide-fix')
            S = TaskStart; E = TaskEnd;
        else
            S = 1; E = length(behavior.lever);
        end
        N_toneA = behavior.ToneA_idx; N_toneB = behavior.ToneB_idx;
        S_toneA = behavior.success_ToneA; S_toneB = behavior.success_ToneB;
        temp_SRa = 0; temp_SRb = 0;
        num_Sa = 0; num_Sb = 0;
        SRa_t = S; SRb_t = S;
        for t = S:sample_rate:E-slide_dur
            temp_Sa = intersect(S_toneA(S_toneA>t),S_toneA(S_toneA<t+slide_dur)); % Success ToneA in sliding window
            temp_N = intersect(N_toneA(N_toneA>t),N_toneA(N_toneA<t+slide_dur)); % All ToneA in sliding window
            if numel(temp_Sa) / numel(temp_N) > temp_SRa
                SRa_t = t;
                num_Sa = temp_Sa;
            else
                SRa_t = SRa_t;
                num_Sa = num_Sa;
            end
            temp_SRa = max(numel(temp_Sa) / numel(temp_N), temp_SRa);
                        
            temp_Sb = intersect(S_toneB(S_toneB>t),S_toneB(S_toneB<t+slide_dur)); % Success ToneB in sliding window
            temp_N = intersect(N_toneB(N_toneB>t),N_toneB(N_toneB<t+slide_dur)); % All ToneB in sliding window
            if numel(temp_Sb) / numel(temp_N) > temp_SRb
                SRb_t = t;
                num_Sb = temp_Sb;
            else
                SRb_t = SRb_t;
                num_Sb = num_Sb;
            end
            temp_SRb = max(numel(temp_Sb) / numel(temp_N), temp_SRb);
            %             pause;
        end
        if b_base == 1
            % adjusting window to that in which SRb was maximum
            num_Sa = intersect(S_toneA(S_toneA>SRb_t),S_toneA(S_toneA<SRb_t+slide_dur)); % Success ToneA in sliding window highest SR in ToneB
            temp_N = intersect(N_toneA(N_toneA>SRb_t),N_toneA(N_toneA<SRb_t+slide_dur));  % All ToneA in sliding window
            temp_SRa = numel(num_Sa) / numel(temp_N);
            SRa_t = SRb_t;
        end
        behavior.successNumA = numel(num_Sa);
        behavior.successNumB = numel(num_Sb);
        behavior.successRateA = temp_SRa * 100;
        behavior.successRateB = temp_SRb * 100;
        
        al_s = sum(AllGocue_idx < SRb_t);
        al_e = sum(AllGocue_idx < SRb_t+slide_dur);
        behavior.analyzed_idx = zeros(size(AllGocue_idx));
        behavior.analyzed_idx(al_s+1:al_e) = 1;
        history.analyzed = behavior.analyzed_idx;
end

fprintf(' done.\n');

%% Lever-pull  
fprintf('Calculating: Lever-pull Duration...');
% pull duration 
if behavior.pull_idx(1) > behavior.pull_fin_idx(1)
    behavior.pull_fin_idx(1) = [];
end
behavior.allPullDuration = zeros(size(behavior.lever));
for t = 1:length(behavior.pull_fin_idx)
    behavior.allPullDuration(behavior.pull_idx(t)) = behavior.pull_fin_idx(t) - behavior.pull_idx(t);
end

%% Lick duration
fprintf(' Lick Duration...');
if behavior.lick_idx(1) > behavior.lick_fin_idx(1)
    behavior.lick_fin_idx(1) = [];
end
behavior.allLickDuration = zeros(size(behavior.lick));
for t = 1:length(behavior.lick_fin_idx)
    behavior.allLickDuration(behavior.lick_idx(t)) = behavior.lick_fin_idx(t) - behavior.lick_idx(t);
end

fprintf(' done.\n');

%% Lever Trajectory

% for history
history.LeverPullDuration = zeros(size(AllGocue_idx));
state_dur=200;
for t = 1:length(AllGocue_idx)
    pt = intersect(behavior.pull_idx,AllGocue_idx(t):AllGocue_idx(t)+state_dur);
    if ~isempty(pt)
        history.LeverPullDuration(t) = sum(behavior.allPullDuration(pt));
    else
        history.LeverPullDuration(t) = NaN;
    end
end

history.LickDuration = zeros(size(AllGocue_idx));
for t = 1:length(AllGocue_idx)
    lt = intersect(behavior.lick_idx,AllGocue_idx(t):AllGocue_idx(t)+state_dur);
    if ~isempty(lt)
        history.LickDuration(t) = sum(behavior.allLickDuration(lt));
    else
        history.LickDuration(t) = NaN;
    end
end
fprintf(' done.\n');

%% Lever Pull Speed
fprintf('Lever Pull Speed...')
behavior.allPullSpeed = zeros(size(behavior.lever));
for t = 1:length(behavior.pull_fin_idx)
    [lv_max,idx] = max(behavior.lever(behavior.pull_idx(t):behavior.pull_fin_idx(t)));
    behavior.allPullSpeed(behavior.pull_idx(t)) = (lv_max - behavior.lever(behavior.pull_idx(t))) / idx;
end
behavior.successPullSpeed = zeros(size(behavior.lever));
for t = 1:length(behavior.success_idx)
    s = intersect(AllGocue_idx,behavior.success_idx(t)-state_dur:behavior.success_idx(t));
    ss = intersect(behavior.pull_idx,s:s+state_dur);
    if ~isempty(ss)
        behavior.successPullSpeed(s) = behavior.allPullSpeed(ss(1));
    end
end

history.PullSpeed = zeros(size(AllGocue_idx));
for t = 1:length(AllGocue_idx)
    pt = intersect(behavior.pull_idx,AllGocue_idx(t):AllGocue_idx(t)+state_dur);
    if isempty(pt)
        history.PullSpeed(t) = NaN;
    else
        history.PullSpeed(t) = behavior.allPullSpeed(pt(1));
    end
end

fprintf(' done.\n\n');
end