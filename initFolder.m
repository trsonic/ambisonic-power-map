function initFolder(folderpath)
if isfolder(folderpath)
    rmdir(folderpath, 's')
end
mkdir(folderpath);
pause(0.25)
end