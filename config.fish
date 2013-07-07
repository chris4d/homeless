#
# by chris4d
#
# This is a modified copy of the system-wide config.fish (share/config.fish),
# which messes up the sort order of PATH/MANPATH variables and fails to catch OSX-specific
# paths that are loaded in other shells by path_helper. This file is the user's personal
# config file, loaded last by fish, which gathers the missing paths and sets them
# in the user-defined order.

# locate in ~/.config/fish/, or whatever path you put in the main config.fish

# 
# For inclusion in trunk, needs a switch to ignore for !OSX
#

#
# this is the OSX path helper, it doesn't work in fish
#
# bash -c "/usr/libexec/path_helper -s"
#

###### set $PATH ######

# USER: set important paths here to put at the front of $PATH if you want to override system-wide settings
set --local user_paths /usr/local/bin /usr/local/sbin /usr/local/opt/ruby/bin

# populate a local variable with directories from /etc/paths
set --local etc_paths
if test -f /etc/paths
	for dir in (cat /etc/paths)
		if test -d $dir
			set etc_paths $etc_paths $dir
		end
	end
end

# populate a local variable with content of each file in /etc/paths.d/* (filesort order)
set --local etc_pathsd
if test -d /etc/paths.d
	for file in /etc/paths.d/*
		if test -d (cat $file)
			set etc_pathsd $etc_pathsd (cat $file)
		end
	end
end

# collect paths (more important ones in front)
set --local path_list $user_paths $PATH $etc_paths $etc_pathsd

# remove duplicates from the list
set --local path_sorted
for i in $path_list
	if not contains $i $path_sorted
		set path_sorted $path_sorted $i
	end
end

# finally, set the PATH variable
set PATH $path_sorted

###### set $MANPATH ######

# USER: set important manpaths here to put at the front of $MANPATH
set --local user_manpaths

# populate a local variable with directories from /etc/manpaths
set --local etc_manpaths
if test -f /etc/manpaths
	for dir in (cat /etc/manpaths)
		if test -d $dir
			set etc_manpaths $etc_manpaths $dir
		end
	end
end

# populate a local variable with content of each file in /etc/manpaths.d/* (filesort order)
set --local etc_manpathsd
if test -d /etc/manpaths.d
	for file in /etc/manpaths.d/*
		if test -d (cat $file)
			set etc_manpathsd $etc_manpathsd (cat $file)
		end
	end
end

# collect paths (more important ones in front)
set --local manpath_list $user_manpaths $MANPATH $etc_manpaths $etc_manpathsd

# remove duplicates from the list
set --local manpath_sorted
for i in $manpath_list
	if not contains $i $manpath_sorted
		set manpath_sorted $manpath_sorted $i
	end
end

# finally, set the MANPATH variable
set MANPATH $manpath_sorted

