% lvm_import
% DATA = LVM_IMPORT(FILENAME,VERBOSE)
% LVM_IMPORT returns the data from a .lvm text file created by LabView.

function data = lvm_import(filename,verbose)

% display header?
if nargin < 2, verbose = 1; end

%% Open the data file
% open and verify the file

% ask for filename if not provided already
if nargin < 1
    filename=input('  Enter the name of the .lvm file: ','s');
end

fid=fopen(filename);
if fid ~= -1, % then file exists
    fclose(fid);
else
    filename=strcat(filename,'.lvm');
    fid=fopen(filename);
    if fid ~= -1, % then file exists
        fclose(fid);
    else
        error(['File not found in current directory! (' pwd ')']);
    end
end
% open the validated file
fid=fopen(filename);

if verbose >= 1, fprintf(1,'\n lvm_import v1.3 Importing %s:\n\n',filename); end
if verbose >= 2, fprintf(1,' File Header:\n'); end

% % read the file
% process the file header
% first, is it really a LVM file?
linein=fgetl(fid);
if verbose >= 2, fprintf(1,'%s\n',linein); end
if ~strcmp(sscanf(linein,'%s'),'LabVIEWMeasurement')
    try
        data.Segment1.data = dlmread(filename,'\t');
        if verbose >= 1, fprintf(1,'This file appears to be an LVM file with no header.\n'); end
        if verbose >= 1, fprintf(1,'Data was copied, but no other information is available.\n'); end
        return
    catch fileEx
        error('This does not appear to be a text-format LVM file (no header).');
    end
end

%% Process file header
% The file header contains several fields with useful information
% default values
data.Decimal_Separator = '.';

% File header contains date, time, etc.
% Also the file delimiter and decimal separator (LVM v2.0)
while 1 
    % get a line from the file
    linein=fgetl(fid);
    % handle spurious carriage returns
    if isempty(linein), linein=fgetl(fid); k=k+1; end
    if verbose >= 2, fprintf(1,'%s\n',linein); end
    % what is the tag for this line?
    t_in = textscan(linein,'%s');
    if isempty(t_in{1})
        tag='notag';
    else
        tag = t_in{1}{1};
    end
    % exit when we reach the end of the header
    if strcmpi(tag,'***End_of_Header***')
        break
    end
    % get the value corresponding to the tag
    if ~strcmp(tag,'notag')
        v_in = textscan(linein,'%*s %s','delimiter','\t','whitespace','','MultipleDelimsAsOne', 1);
        val = v_in{1}{1};
    end
    
    switch tag
        case 'Date'
            data.date = val;
        case 'Time'
            data.time = val;
        case 'Operator'
            data.user = val;
        case 'Description'
            %d_in = textscan(linein,'%*s %s','delimiter','\t','whitespace','');
            data.Description = val;
        case 'Project'
            %d_in = textscan(linein,'%*s %s','delimiter','\t','whitespace','');
            data.Project = val;            
        case 'Separator'
            if strcmp(val,'Tab')
                separator_char='\t';
            elseif strcmp(val,'Comma')
                separator_char=',';
            end
        case 'X_Columns'
            data.x_columns = val;
        case 'Decimal_Separator'
            data.Decimal_Separator = val;

    end
end

if isfield(data,'time') && isfield(data,'date')
    dt = textscan(data.date,'%d','delimiter','/');
    tm = textscan(data.time,'%d','delimiter',':');
    if length(tm{1})==3
        data.clock=[dt{1}(1) dt{1}(2) dt{1}(3) tm{1}(1) tm{1}(2) tm{1}(3)];
    elseif length(tm{1})==2
        data.clock=[dt{1}(1) dt{1}(2) dt{1}(3) tm{1}(1) tm{1}(2) 0];
    else
        data.clock=[dt{1}(1) dt{1}(2) dt{1}(3) 0 0 0];
    end
end



%% Process segments
% process data segments in a loop until finished
segnum = 0;

while 1
    segnum = segnum +1;
    fieldnm = ['Segment' num2str(segnum)];

    %% - Segment header
    if verbose >= 2, fprintf(1,'\nSegment %d Header:\n',segnum); end
    while 1
        % get a line from the file
        linein=fgetl(fid);
        % handle spurious carriage returns/blank lines
        %if isempty(linein), linein=fgetl(fid); end
        while (isempty(linein)) 
            if (feof(fid)), return; end; 
            linein=fgetl(fid); 
        end;
        % test for end of file
        if linein==-1, break; end
        
        % ignore "special segments"
        if strcmpi(linein,'***Start_Special***')
            if verbose >= 2, fprintf(1,'\n[Special Segment ignored]\n'); end

            while 1 % process lines until we find the end of the special segment 
                % get a line from the file
                linein=fgetl(fid);
                % handle spurious carriage returns
                if isempty(linein), linein=fgetl(fid); end
                % test for end of file
                if linein==-1, break; end
                if strcmpi(linein,'***End_Special***')
                    break
                end
            end
            % get the next line and proceed with file
            linein=fgetl(fid);
            % handle spurious carriage returns
            if isempty(linein), linein=fgetl(fid); k=k+1; end
            % test for end of file
            if linein==-1, break; end
        end
        
        
        if verbose >= 2, fprintf(1,'%s\n',linein); end
        
        
        % what is the tag for this line?
        t_in = textscan(linein,'%s');
        if isempty(t_in{1})
            tag='notag';
        else
            tag = t_in{1}{1};
        end
        % exit when we reach the end of the header
        if strcmpi(tag,'***End_of_Header***')
            break
        end    
        
        switch tag
            case 'Notes'
                d_in = linein;
                data.(fieldnm).Notes=d_in;
            case 'Test_Name'
                d_in = linein;
                data.(fieldnm).Test_Name = d_in;          
            case 'Channels'
                numchan = textscan(linein,'%*s %d');
                data.(fieldnm).num_channels = numchan{1};
            case 'Y_Unit_Label'
                Y_units = textscan(linein,'%s','delimiter',separator_char);
                data.(fieldnm).y_units=Y_units{1};
                data.(fieldnm).y_units(1)=[];
            case 'X_Dimension'
                X_Dim = textscan(linein,'%s','delimiter',separator_char);
                data.(fieldnm).x_units=X_Dim{1};
                data.(fieldnm).x_units(1)=[];            
            case 'X0'      
                [Xnought, val]=strtok(linein);                         
                if ~strcmp(data.Decimal_Separator,'.')
                    val = strrep(val,data.Decimal_Separator,'.');
                end
                data.(fieldnm).X0 = sscanf(val,'%e');
            case 'Delta_X' 
                [Delta_X, val]=strtok(linein);
                if ~strcmp(data.Decimal_Separator,'.')
                    val = strrep(val,data.Decimal_Separator,'.');
                end
                data.(fieldnm).delta_X = sscanf(val,'%e'); 
        end
        
    end % end reading segment header loop

    % test for end of file
    if linein==-1
        if verbose >= 2, fprintf(1,' [End of File; No Segment %d]\n\n',segnum); end
        segnum = segnum-1;
        break;
    end

    % after each segment header is the row of column labels
    linein=fgetl(fid);
    Y_labels = textscan(linein,'%s','delimiter',separator_char);       
    data.(fieldnm).column_labels=Y_labels{1};
    if verbose >1
        fprintf(1,' Data Columns:\n');
        for i=1:length(data.(fieldnm).column_labels)
            fprintf(1,'%s\t',data.(fieldnm).column_labels{i});
        end
        fprintf(1,'\n');
    end



    %% - Get data from this segment
    % How many columns have we?
    switch data.x_columns
        case 'No'
            numdatacols = data.(fieldnm).num_channels;
        case 'One'
            numdatacols = data.(fieldnm).num_channels;
        case 'Multi'
            numdatacols = data.(fieldnm).num_channels*2 - 1;
    end
    % create a format string
    fs = '%f';
    for i=1:numdatacols
        fs = [fs ' %f'];                                             
    end
    % add one more column for the comment field
    fs = [fs ' %s'];

    % read in the data. Result is a cell array of the columns
    % handle case of using commas for decimal point separators (v1.3)
    if ~strcmp(data.Decimal_Separator,'.')
        if verbose >= 1, fprintf(1,' Reformatting for decimal separator "%s" ...',data.Decimal_Separator); end
        fss = strrep(fs,'%f','%s');
        rawdata = textscan(fid,fss,'delimiter',separator_char);
        if length(rawdata{1}) > 1
            if verbose >= 1, fprintf(1,' success.\n\n'); end
        else
            if verbose >= 1, fprintf(1,' failed.\n\n'); end
            if verbose >= 1, fprintf(1,'\n No data found in file "%s".\n',filename); end
            data=[];
            return
        end
        % use . for decimals    
        for i=1:length(rawdata)
            for j=1:length(rawdata{i})
                rawdata{i}(j)=strrep(rawdata{i}(j),data.Decimal_Separator,'.');
            end
        end
        
    else
        rawdata = textscan(fid,fs,'delimiter',separator_char);
    end

    % either keep data columns in cells, or consolidate
    % consolidate into a simple array, ignore comments
    data.(fieldnm).data=rawdata{1};
    for i=2:numdatacols+1
        data.(fieldnm).data=[data.(fieldnm).data rawdata{i}];
    end
    
    % save first comment as The Comment for this segment
    data.(fieldnm).Comment = rawdata{numdatacols+2}{1};
    
    % If we have a "No X data" file, strip the first column (it is NaN)
    if strcmp(data.x_columns,'No')
        data.(fieldnm).data=data.(fieldnm).data(:,2:end);
    end
    
end

if verbose >= 1, fprintf(1,' Import complete. File has %s X-Column(s) and %d data Segments.\n',data.x_columns,segnum); end

% close the file
fclose(fid);
return


