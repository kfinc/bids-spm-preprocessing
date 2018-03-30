function [path] = create_path (dir, sub, sess, type)
    path =  strcat(dir, sub, '/', sess, '/', type);
end