function searchlight_metadata = readSearchlightMetadata(fname)
    fid = fopen(fname, 'r');
    metaStr_searchlight = fread(fid, '*char');  
    fclose(fid);   
    searchlight_metadata =jsondecode(reshape(metaStr_searchlight, 1, []));
end