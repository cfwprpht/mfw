#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#
 
# Priority: 2900
# Description: Change a specific file in CoreOS manually

# Option --change-filenames: Filenames to change (must start with 'CORE_OS_PACKAGE/')

# Type --change-filenames: textarea


namespace eval change_coreos_files {

	array set ::change_coreos_files::options {
        --change-filenames "CORE_OS_PACKAGE/path/to/file/to/change"
    }

    proc main {} {
        variable options
        foreach file [split $options(--change-filenames) "\n"] {
            if {[string equal -length 20 "CORE_OS_PACKAGE/path" ${file}] != 1} {
                if {[string equal -length 16 "CORE_OS_PACKAGE/" ${file}] == 1} {
                    ::modify_coreos_file ${file} ::change_coreos_files::change_file
                }
            }
        }
    }

    proc change_file {$self} {
        
        if {[package provide Tk] != "" } {
           tk_messageBox -default ok -message "Change the file or files you need in '.../Temp/PS3MFW-MFW/CORE_OS_PACKAGE' then press ok to continue" -icon warning
        } else {
           puts "Press \[RETURN\] or \[ENTER\] to continue"
           gets stdin
        }
    }
}
