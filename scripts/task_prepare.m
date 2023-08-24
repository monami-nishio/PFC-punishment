root_path = '';
task_folders = dir(append(root_path, '/*'));
task_folders = task_folders(~ismember({task_folders.name}, {'.', '..'}));
task_folders = task_folders([task_folders.isdir]);
for iTask = 1:length(task_folders)
    region_folders = dir(append(task_folders(iTask).folder, '/', task_folders(iTask).name, '/*'));
    region_folders = region_folders(~ismember({region_folders.name}, {'.', '..'}));
    region_folders = region_folders([region_folders.isdir]);
    for iRegion = 1:length(region_folders)
        cond_folders = dir(append(region_folders(iRegion).folder, '/', region_folders(iRegion).name, '/')); 
        cond_folders = cond_folders(~ismember({cond_folders.name}, {'.', '..'}));
        cond_folders = cond_folders([cond_folders.isdir]);
        for iCond = 1:length(cond_folders)
            mouse_folders=dir(append(cond_folders(iCond).folder, '/', cond_folders(iCond).name, '/*'));
            mouse_folders = mouse_folders(~ismember({mouse_folders.name}, {'.', '..'}));
            mouse_folders = mouse_folders([mouse_folders.isdir]);
            meta = cell(length(mouse_folders),2);
            meta_history = cell(length(mouse_folders),2);
            for iMouse = 1:length(mouse_folders)
                lvm_files=dir(append(mouse_folders(iMouse).folder, '/', mouse_folders(iMouse).name, '/*1000Hz.lvm')); 
                clear task history
                if isempty(lvm_files)
                    continue
                end
                for iFile=1:length(lvm_files)
                    file_path = append(lvm_files(iFile).folder,'/', lvm_files(iFile).name);
                    [task.behavior(iFile),history(iFile)] = extract_data(file_path,1,1200);
                end
                meta{iMouse,1} = mouse_folders(iMouse).name;
                meta{iMouse,2} = task;
                meta_history{iMouse,1} = mouse_folders(iMouse).name;
                meta_history{iMouse,2} = history;
            end
            save(append(cond_folders(iCond).folder, '/', cond_folders(iCond).name, '_meta'), '-v7.3')
            save(append(cond_folders(iCond).folder, '/', cond_folders(iCond).name, '_history'), '-v7.3')
        end
    end
end

