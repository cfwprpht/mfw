#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
# Copyright (C) glevand (geoffrey.levand@mail.ru)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#

# Priority: 200
# Description: Patch CoreOS

# Option --patch-lv0-coreos-ecdsa-check: Patch LV0 to disable CoreOS ECDSA check in LV0 (needed for 4.xx CFW)
# Option --patch-spkg-ecdsa-check: Patch FW PKG Verifier to disable ECDSA check for spkg files (needed for 4.xx CFW)
# Option --patch-appldr-fself-340: Patch Appldr to allow Fself (3.40-3.55) set debug true (Experimental!)
# Option --patch-appldr-fself-330: Patch Appldr to allow Fself (3.10-3.30) set debug true (Experimental!)
# Option --add-356keys-to-appldr341: Patch Appldr to add the 3.56 keys to appldr 3.41
# Option --add-360keys-to-appldr355: Patch Appldr to add the 3.60 keys to appldr 3.55
# Option --patch-profile-gameos-bootmem-size: Patch Profile (SPP) - Increase boot memory size of GameOS (Needed for OtherOS++)
# Option --patch-pup-search-in-game-disc: Patch Recovery Menu - Disable searching for update packages in GAME disc
# Option --patch-gameos-hdd-region-size: Patch Recovery Menu - Create GameOS HDD region smaller than default
# Option --patch-lv2-peek-poke-355: Patch LV2 to add Peek&Poke system calls 3.55
# Option --patch-lv2-lv1-peek-poke-355: Patch LV2 to add LV1 Peek&Poke system calls 3.55 (LV1 peek/poke patch necessary)
# Option --patch-lv2-lv1-call-355: Patch LV2 to add LV1 Call system call 3.55
# Option --patch-lv2-payload-hermes-355: Patch LV2 to implement hermes payload with SC8 and /app_home/ redirection 3.55
# Option --patch-lv2-SC36-355: Patch LV2 to implement SysCall36 3.55
# Option --patch-lv2-peek-poke-4x: Patch LV2 to add Peek&Poke system calls 4.xx
# Option --patch-lv2-lv1-peek-poke-4x: Patch LV2 to add LV1 Peek&Poke system calls 4.xx (LV1 peek/poke patch necessary)
# Option --patch-lv2-npdrm-ecdsa-check: Jailbait - Patch LV2 to disable NPDRM ECDSA check 4.xx
# Option --patch-lv2-payload-hermes-4x: Patch LV2 to implement hermes payload SC8 /app_home/ redirection & embended app mount 4.xx
# Option --patch-lv2-SC36-4x: Patch LV2 to implement SysCall36 4.xx

# Type --patch-lv0-coreos-ecdsa-check: boolean
# Type --patch-spkg-ecdsa-check: boolean
# Type --patch-appldr-340: boolean
# Type --patch-appldr-330: boolean
# Type --add-356keys-to-appldr341 boolean
# Type --add-360keys-to-appldr355 boolean
# Type --patch-profile-gameos-bootmem-size: boolean
# Type --patch-pup-search-in-game-disc: boolean
# Type --patch-gameos-hdd-region-size: combobox {{ -do nothing-} {1/eighth of drive} {1/quarter of drive} {1/half of drive} {22GB} {10GB} {20GB} {30GB} {40GB} {50GB} {60GB} {70GB} {80GB} {90GB} {100GB} {110GB} {120GB} {130GB} {140GB} {150GB} {160GB} {170GB} {180GB} {190GB} {200GB} {210GB} {220GB} {230GB} {240GB} {250GB} {260GB} {270GB} {280GB} {290GB} {300GB} {310GB} {320GB} {330GB} {340GB} {350GB} {360GB} {370GB} {380GB} {390GB} {400GB} {410GB} {420GB} {430GB} {440GB} {450GB} {460GB} {470GB} {480GB} {490GB} {500GB} {510GB} {520GB} {530GB} {540GB} {550GB} {560GB} {570GB} {580GB} {590GB} {600GB} {610GB} {620GB} {630GB} {640GB} {650GB} {660GB} {670GB} {680GB} {690GB} {700GB} {710GB} {720GB} {730GB} {740GB} {750GB} {760GB} {770GB} {780GB} {790GB} {800GB} {810GB} {820GB} {830GB} {840GB} {850GB} {860GB} {870GB} {880GB} {890GB} {900GB} {910GB} {920GB} {930GB} {940GB} {950GB} {960GB} {970GB} {980GB} {990GB} {1000GB}}
# Type --patch-lv2-peek-poke-355: boolean
# Type --patch-lv2-lv1-peek-poke-355: boolean
# Type --patch-lv2-lv1-call-355: boolean
# Type --patch-lv2-payload-hermes-355: boolean
# Type --patch-lv2-SC36-355: boolean
# Type --patch-lv2-peek-poke-4x: boolean
# Type --patch-lv2-lv1-peek-poke-4x: boolean
# Type --patch-lv2-npdrm-ecdsa-check: boolean
# Type --patch-lv2-payload-hermes-4x: boolean
# Type --patch-lv2-SC36-4x: boolean

namespace eval ::patch_cos {

	# just create empty globals for the binary search/replace/offset strings
	set ::patch_cos::search ""
	set ::patch_cos::replace ""
	set ::patch_cos::offset 0
	
    array set ::patch_cos::options {        
        --patch-lv0-coreos-ecdsa-check true
        --patch-spkg-ecdsa-check true
        --patch-appldr-fself-340 false
        --patch-appldr-fself-330 false
        --add-356keys-to-appldr341 false
        --add-360keys-to-appldr355 false
        --patch-profile-gameos-bootmem-size false
        --patch-pup-search-in-game-disc true
        --patch-gameos-hdd-region-size ""
        --patch-lv2-peek-poke-355 false
        --patch-lv2-lv1-peek-poke-355 false
        --patch-lv2-lv1-call-355 false
        --patch-lv2-payload-hermes-355 false
        --patch-lv2-SC36-355 false
        --patch-lv2-peek-poke-4x true
        --patch-lv2-lv1-peek-poke-4x true
        --patch-lv2-npdrm-ecdsa-check true
        --patch-lv2-payload-hermes-4x true
        --patch-lv2-SC36-4x true
    }

    proc main { } {
	
        set embd [file join dev_flash vsh etc layout_factor_table_272.txt]
        
		# begin by calling the new base function to unpackage
		# the "CORE_OS" pkg, and extract all the files, the 
		# callback function will begin the patching routine(s).
        ::patch_coreos_files ::patch_cos::Do_CoreOS_Patches
        
		# if no options were selected to add the "*Install Pkg Files" elsewhere, 
		# install this package into dev_flash
        if {$::patch_cos::options(--patch-lv2-payload-hermes-4x)} {
            if {[string equal $::customize_firmware::options(--customize-embended-app) "None" == 1] && !$::patch_xmb::options(--add-install-pkg) && !$::patch_xmb::options(--add-pkg-mgr) && !$::patch_xmb::options(--add-hb-seg) && !$::patch_xmb::options(--add-emu-seg) && !$::patch_xmb::options(--patch-package-files) && !$::patch_xmb::options(--patch-app-home) } {
                log "Copy standalone '*Install Package Files' app into dev_flash"
                ::modify_devflash_file $embd ::copy_ps3_game ${::CUSTOM_PS3_GAME}
            }        
        }
    }		
	
	# --------------------------Do_CoreOS_Patches-------------------------------------------
	# this proc is for applying any patches to CORE_OS files, it is
	# expected that the "::patch_coreos_files" routine was already
	# called to extract all CORE_OS files, and return the "path"
	# of the unpackaged files
    proc Do_CoreOS_Patches {path} {
	
		# call the function to do any LV0 selected patches
		::patch_cos::Do_LV0_Patches $path
		
		# call the function to do any LV1 selected patches
		::patch_cos::Do_LV1_Patches $path
		
		# call the function to do any LV2 selected patches
		::patch_cos::Do_LV2_Patches $path
	
		# call the function to do any other OS-file selected patches
		::patch_cos::Do_Misc_OS_Patches $path
					
	}
	### ------------------------------------- END:    Do_CoreOS_Patches{} --------------------------------------------- ###	
	

	# --------------------------  BEGIN:  Do_LV0_Patches   ------------------------------------------------------------ ### 
	#
	# This proc is for applying any patches to the "LV0" self file
	#
	#
	proc Do_LV0_Patches {path} {
		
		log "Applying LV0 patches...."
		
		# if "lv0-ecdsa" patch is enabled, patch in "lv0.elf"
        if {$::patch_cos::options(--patch-lv0-coreos-ecdsa-check)} {
			log "Patching Lv0 to disable CoreOS ECDSA check"
			
			set ::patch_cos::search  "\xE8\x61\x00\x70\x80\x81\x00\x7C\x48\x00\x09\xB1\xEB"
            set ::patch_cos::replace "\x60\x00\x00\x00"
			set ::patch_cos::offset 8			
			set self "lv0"
			set file [file join $path $self]
			set ::SELF $self
			# base function to decrypt the "self" to "elf" for patching
            ::modify_self_file $file ::patch_cos::patch_elf
			
			# pop a msg box to alert user to "padd" the rebuilt "LV0" since it will be slightly
			# smaller than the original (needs "00" padding to end of file)
			#tk_messageBox -default ok -message "Please add the 00 padding to the '$self' file now!, then press ok to continue" -icon warning
        }	
		# if "--patch-spkg-ecdsa-check" is enabled, patch in "spu_pkg_rvk_verifier.self"
		if {$::patch_cos::options(--patch-spkg-ecdsa-check)} {
            log "Patching SPKG ECDSA verifier to disable ECDSA check"  
			
            set ::patch_cos::search     "\x40\x80\x0A\x05\x34\x02\xC0\x80\x1C\x28\x00\x81\x3F\xE0\x02\x83"
            append ::patch_cos::search  "\x34\xFF\xC0\xD0\x34\xFF\x80\xD1\x34\xFF\x40\xD2\x35\x00\x00\x00"
            set ::patch_cos::replace    "\x40\x80\x00\x03"
			set ::patch_cos::offset 12
			set self "spu_pkg_rvk_verifier.self"
			set file [file join $path $self]
			set ::SELF $self
			# base function to decrypt the "self" to "elf" for patching
            ::modify_self_file $file ::patch_cos::patch_elf
			
			# pop a msg box to alert user to "padd" the rebuilt "LV0" since it will be slightly
			# smaller than the original (needs "00" padding to end of file)
			#tk_messageBox -default ok -message "Please add the 00 padding to the '$self' file now!, then press ok to continue" -icon warning
        }
		# ---------   apply any "appldr" specific patches  -------------------
		if {$::patch_cos::options(--patch-appldr-fself-340) || $::patch_cos::options(--patch-appldr-fself-330) || $::patch_cos::options(--add-356keys-to-appldr341) || $::patch_cos::options(--add-360keys-to-appldr355)} {
		
			# pop a msg box to alert user to manually extract "appldr" from LV0, since currently
			# this script does not extract the loaders from LV0 automatically
			tk_messageBox -default ok -message "You need to MANUALLY EXTRACT appldr from LV0 before continuing...., press ok when ready to continue" -icon warning
			
			# patch appldr for "fself 3.40"
			if {$::patch_cos::options(--patch-appldr-fself-340)} {
				log "Patching Appldr to allow Fself (3.40-3.55)"
			 
				set ::patch_cos::search  "\x40\x80\x0e\x0c\x20\x00\x57\x83\x32\x00\x04\x80\x32\x80\x80"
				set ::patch_cos::replace "\x40\x80\x0e\x0c\x20\x00\x57\x83\x32\x11\x73\x00\x32\x80\x80"
				set ::patch_cos::offset 7          
				set self "appldr"
				set file [file join $path $self]
				set ::SELF $self
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf
			}
			# patch appldr for "fself 3.30"
			if {$::patch_cos::options(--patch-appldr-fself-330)} {
				log "Patching Appldr to allow Fself (3.10-3.30)"
			  
				set ::patch_cos::search  "\x40\x80\x0e\x0d\x20\x00\x69\x09\x32\x00\x04\x80\x32\x80\x80"
				set ::patch_cos::replace "\x40\x80\x0e\x0c\x20\x00\x57\x83\x32\x11\x73\x00\x32\x80\x80"
				set ::patch_cos::offset 7          
				set self "appldr"
				set file [file join $path $self]
				set ::SELF $self
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf
			}
			# patch appldr to add "3.56 keys" to "appldr 3.41"
			if {$::patch_cos::options(--add-356keys-to-appldr341)} {
			
				log "Patching Application loader 3.41 to add 3.56 keys"
				log "patching revision check"
				set ::patch_cos::search    "\x5D\x01\x83\x14"
				set ::patch_cos::replace   "\x5D\x03\x83\x14"
				set ::patch_cos::offset 0
				set self "appldr"
				set file [file join $path $self]
				set ::SELF $self
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf 							
				
				log "patching 2nd keypair addr"
				set ::patch_cos::search    "\x43\x5D\x28\x06"
				set ::patch_cos::replace   "\x43\x5b\xD8\x06"
				set ::patch_cos::offset 0
				set self "appldr"
				set file [file join $path $self]
				set ::SELF $self
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf				
				
				# patch in "356" key data
				set ::patch_cos::search     "\x00\x00\x00\x00\x00\x95\xF5\x00\x19\xE7\xA6\x8E\x34\x1F\xA7\x2E"
				set ::patch_cos::replace    "\x95\xF5\x00\x19\xE7\xA6\x8E\x34\x1F\xA7\x2E\xFD\xF4\xD6\x0E\xD3"
				append ::patch_cos::replace "\x76\xE2\x5C\xF4\x6B\xB4\x8D\xFD\xD1\xF0\x80\x25\x9D\xC9\x3F\x04"
				append ::patch_cos::replace "\x4A\x09\x55\xD9\x46\xDB\x70\xD6\x91\xA6\x40\xBB\x7F\xAE\xCC\x4C"
				append ::patch_cos::replace "\x6F\x8D\xF8\xEB\xD0\xA1\xD1\xDB\x08\xB3\x0D\xD3\xA9\x51\xE3\xF1"
				append ::patch_cos::replace "\xF2\x7E\x34\x03\x0B\x42\xC7\x29\xC5\x55\x55\x23\x2D\x61\xB8\x34"
				append ::patch_cos::replace "\xB8\xBD\xFF\xB0\x7E\x54\xB3\x43\x00\x00\x00\x21\x00\x00\x00\x00"
				append ::patch_cos::replace "\x79\x48\x18\x39\xC4\x06\xA6\x32\xBD\xB4\xAC\x09\x3D\x73\xD9\x9A"
				append ::patch_cos::replace "\xE1\x58\x7F\x24\xCE\x7E\x69\x19\x2C\x1C\xD0\x01\x02\x74\xA8\xAB"
				append ::patch_cos::replace "\x6F\x0F\x25\xE1\xC8\xC4\xB7\xAE\x70\xDF\x96\x8B\x04\x52\x1D\xDA"
				append ::patch_cos::replace "\x94\xD1\xB7\x37\x8B\xAF\xF5\xDF\xED\x26\x92\x40\xA7\xA3\x64\xED"
				append ::patch_cos::replace "\x68\x44\x67\x41\x62\x2E\x50\xBC\x60\x79\xB6\xE6\x06\xA2\xF8\xE0"
				append ::patch_cos::replace "\xA4\xC5\x6E\x5C\xFF\x83\x65\x26\x00\x00\x00\x11\x00\x00\x00\x00"
				append ::patch_cos::replace "\x4F\x89\xBE\x98\xDD\xD4\x3C\xAD\x34\x3F\x5B\xA6\xB1\xA1\x33\xB0"
				append ::patch_cos::replace "\xA9\x71\x56\x6F\x77\x04\x84\xAA\xC2\x0B\x5D\xD1\xDC\x9F\xA0\x6A"
				append ::patch_cos::replace "\x90\xC1\x27\xA9\xB4\x3B\xA9\xD8\xE8\x9F\xE6\x52\x9E\x25\x20\x6F"
				append ::patch_cos::replace "\x8C\xA6\x90\x5F\x46\x14\x8D\x7D\x8D\x84\xD2\xAF\xCE\xAE\x61\xB4"
				append ::patch_cos::replace "\x1E\x67\x50\xFC\x22\xEA\x43\x5D\xFA\x61\xFC\xE6\xF4\xF8\x60\xEE"
				append ::patch_cos::replace "\x4F\x54\xD9\x19\x6C\xA5\x29\x0E\x00\x00\x00\x13\x00\x00\x00\x00"
				append ::patch_cos::replace "\xC1\xE6\xA3\x51\xFC\xED\x6A\x06\x36\xBF\xCB\x68\x01\xA0\x94\x2D"
				append ::patch_cos::replace "\xB7\xC2\x8B\xDF\xC5\xE0\xA0\x53\xA3\xF5\x2F\x52\xFC\xE9\x75\x4E"
				append ::patch_cos::replace "\xE0\x90\x81\x63\xF4\x57\x57\x64\x40\x46\x6A\xCA\xA4\x43\xAE\x7C"
				append ::patch_cos::replace "\x50\x02\x2D\x5D\x37\xC9\x79\x05\xF8\x98\xE7\x8E\x7A\xA1\x4A\x0B"
				append ::patch_cos::replace "\x5C\xAA\xD5\xCE\x81\x90\xAE\x56\x29\xA1\x0D\x6F\x0C\xF4\x17\x35"
				append ::patch_cos::replace "\x97\xB3\x7A\x95\xA7\x54\x5C\x92\x00\x00\x00\x0B\x00\x00\x00\x00"
				append ::patch_cos::replace "\x83\x8F\x58\x60\xCF\x97\xCD\xAD\x75\xB3\x99\xCA\x44\xF4\xC2\x14"
				append ::patch_cos::replace "\xCD\xF9\x51\xAC\x79\x52\x98\xD7\x1D\xF3\xC3\xB7\xE9\x3A\xAE\xDA"
				append ::patch_cos::replace "\x7F\xDB\xB2\xE9\x24\xD1\x82\xBB\x0D\x69\x84\x4A\xDC\x4E\xCA\x5B"
				append ::patch_cos::replace "\x1F\x14\x0E\x8E\xF8\x87\xDA\xB5\x2F\x07\x9A\x06\xE6\x91\x5A\x64"
				append ::patch_cos::replace "\x60\xB7\x5C\xD2\x56\x83\x4A\x43\xFA\x7A\xF9\x0C\x23\x06\x7A\xF4"
				append ::patch_cos::replace "\x12\xED\xAF\xE2\xC1\x77\x8D\x69\x00\x00\x00\x14\x00\x00\x00\x00"
				append ::patch_cos::replace "\xC1\x09\xAB\x56\x59\x3D\xE5\xBE\x8B\xA1\x90\x57\x8E\x7D\x81\x09"
				append ::patch_cos::replace "\x34\x6E\x86\xA1\x10\x88\xB4\x2C\x72\x7E\x2B\x79\x3F\xD6\x4B\xDC"
				append ::patch_cos::replace "\x15\xD3\xF1\x91\x29\x5C\x94\xB0\x9B\x71\xEB\xDE\x08\x8A\x18\x7A"
				append ::patch_cos::replace "\xB6\xBB\x0A\x84\xC6\x49\xA9\x0D\x97\xEB\xA5\x5B\x55\x53\x66\xF5"
				append ::patch_cos::replace "\x23\x81\xBB\x38\xA8\x4C\x8B\xB7\x1D\xA5\xA5\xA0\x94\x90\x43\xC6"
				append ::patch_cos::replace "\xDB\x24\x90\x29\xA4\x31\x56\xF7\x00\x00\x00\x15\x00\x00\x00\x00"
				append ::patch_cos::replace "\x6D\xFD\x7A\xFB\x47\x0D\x2B\x2C\x95\x5A\xB2\x22\x64\xB1\xFF\x3C"
				append ::patch_cos::replace "\x67\xF1\x80\x98\x3B\x26\xC0\x16\x15\xDE\x9F\x2E\xCC\xBE\x7F\x41"
				append ::patch_cos::replace "\x24\xBD\x1C\x19\xD2\xA8\x28\x6B\x8A\xCE\x39\xE4\xA3\x78\x01\xC2"
				append ::patch_cos::replace "\x71\xF4\x6A\xC3\x3F\xF8\x9D\xF5\x89\xA1\x00\xA7\xFB\x64\xCE\xAC"
				append ::patch_cos::replace "\x24\x4C\x9A\x0C\xBB\xC1\xFD\xCE\x80\xFB\x4B\xF8\xA0\xD2\xE6\x62"
				append ::patch_cos::replace "\x93\x30\x9C\xB8\xEE\x8C\xFA\x95\x00\x00\x00\x2C\x00\x00\x00\x00"
				append ::patch_cos::replace "\x94\x5B\x99\xC0\xE6\x9C\xAF\x05\x58\xC5\x88\xB9\x5F\xF4\x1B\x23"
				append ::patch_cos::replace "\x26\x60\xEC\xB0\x17\x74\x1F\x32\x18\xC1\x2F\x9D\xFD\xEE\xDE\x55"
				append ::patch_cos::replace "\x1D\x5E\xFB\xE7\xC5\xD3\x4A\xD6\x0F\x9F\xBC\x46\xA5\x97\x7F\xCE"
				append ::patch_cos::replace "\xAB\x28\x4C\xA5\x49\xB2\xDE\x9A\xA5\xC9\x03\xB7\x56\x52\xF7\x8D"
				append ::patch_cos::replace "\x19\x2F\x8F\x4A\x8F\x3C\xD9\x92\x09\x41\x5C\x0A\x84\xC5\xC9\xFD"
				append ::patch_cos::replace "\x6B\xF3\x09\x5C\x1C\x18\xFF\xCD\x00\x00\x00\x15\x00\x00\x00\x00"
				append ::patch_cos::replace "\x2C\x9E\x89\x69\xEC\x44\xDF\xB6\xA8\x77\x1D\xC7\xF7\xFD\xFB\xCC"
				append ::patch_cos::replace "\xAF\x32\x9E\xC3\xEC\x07\x09\x00\xCA\xBB\x23\x74\x2A\x9A\x6E\x13"
				append ::patch_cos::replace "\x5A\x4C\xEF\xD5\xA9\xC3\xC0\x93\xD0\xB9\x35\x23\x76\xD1\x94\x05"
				append ::patch_cos::replace "\x6E\x82\xF6\xB5\x4A\x0E\x9D\xEB\xE4\xA8\xB3\x04\x3E\xE3\xB2\x4C"
				append ::patch_cos::replace "\xD9\xBB\xB6\x2B\x44\x16\xB0\x48\x25\x82\xE4\x19\xA2\x55\x2E\x29"
				append ::patch_cos::replace "\xAB\x4B\xEA\x0A\x4D\x7F\xA2\xD5\x00\x00\x00\x16\x00\x00\x00\x00"
				append ::patch_cos::replace "\xF6\x9E\x4A\x29\x34\xF1\x14\xD8\x9F\x38\x6C\xE7\x66\x38\x83\x66"
				append ::patch_cos::replace "\xCD\xD2\x10\xF1\xD8\x91\x3E\x3B\x97\x32\x57\xF1\x20\x1D\x63\x2B"
				append ::patch_cos::replace "\xF4\xD5\x35\x06\x93\x01\xEE\x88\x8C\xC2\xA8\x52\xDB\x65\x44\x61"
				append ::patch_cos::replace "\x1D\x7B\x97\x4D\x10\xE6\x1C\x2E\xD0\x87\xA0\x98\x15\x35\x90\x46"
				append ::patch_cos::replace "\x77\xEC\x07\xE9\x62\x60\xF8\x95\x65\xFF\x7E\xBD\xA4\xEE\x03\x5C"
				append ::patch_cos::replace "\x2A\xA9\xBC\xBD\xD5\x89\x3F\x99\x00\x00\x00\x2D\x00\x00\x00\x00"
				append ::patch_cos::replace "\x29\x80\x53\x02\xE7\xC9\x2F\x20\x40\x09\x16\x1C\xA9\x3F\x77\x6A"
				append ::patch_cos::replace "\x07\x21\x41\xA8\xC4\x6A\x10\x8E\x57\x1C\x46\xD4\x73\xA1\x76\xA3"
				append ::patch_cos::replace "\x5D\x1F\xAB\x84\x41\x07\x67\x6A\xBC\xDF\xC2\x5E\xAE\xBC\xB6\x33"
				append ::patch_cos::replace "\x09\x30\x1B\x64\x36\xC8\x5B\x53\xCB\x15\x85\x30\x0A\x3F\x1A\xF9"
				append ::patch_cos::replace "\xFB\x14\xDB\x7C\x30\x08\x8C\x46\x42\xAD\x66\xD5\xC1\x48\xB8\x99"
				append ::patch_cos::replace "\x5B\xB1\xA6\x98\xA8\xC7\x18\x27\x00\x00\x00\x25\x00\x00\x00\x00"
				append ::patch_cos::replace "\xA4\xC9\x74\x02\xCC\x8A\x71\xBC\x77\x48\x66\x1F\xE9\xCE\x7D\xF4"
				append ::patch_cos::replace "\x4D\xCE\x95\xD0\xD5\x89\x38\xA5\x9F\x47\xB9\xE9\xDB\xA7\xBF\xC3"
				append ::patch_cos::replace "\xE4\x79\x2F\x2B\x9D\xB3\x0C\xB8\xD1\x59\x60\x77\xA1\x3F\xB3\xB5"
				append ::patch_cos::replace "\x27\x33\xC8\x89\xD2\x89\x55\x0F\xE0\x0E\xAA\x5A\x47\xA3\x4C\xEF"
				append ::patch_cos::replace "\x0C\x1A\xF1\x87\x61\x0E\xB0\x7B\xA3\x5D\x2C\x09\xBB\x73\xC8\x0B"
				append ::patch_cos::replace "\x24\x4E\xB4\x14\x77\x00\xD1\xBF\x00\x00\x00\x26\x00\x00\x00\x00"
				append ::patch_cos::replace "\x98\x14\xEF\xFF\x67\xB7\x07\x4D\x1B\x26\x3B\xF8\x5B\xDC\x85\x76"
				append ::patch_cos::replace "\xCE\x9D\xEC\x91\x41\x23\x97\x1B\x16\x94\x72\xA1\xBC\x23\x87\xFA"
				append ::patch_cos::replace "\xD4\x3B\x1F\xA8\xBE\x15\x71\x4B\x30\x78\xC2\x39\x08\xBB\x2B\xCA"
				append ::patch_cos::replace "\x7D\x19\x86\xC6\xBE\xE6\xCE\x1E\x0C\x58\x93\xBD\x2D\xF2\x03\x88"
				append ::patch_cos::replace "\x1F\x40\xD5\x05\x67\x61\xCC\x3F\x1F\x2E\x9D\x9A\x37\x86\x17\xA2"
				append ::patch_cos::replace "\xDE\x40\xBA\x5F\x09\x84\x4C\xEB\x00\x00\x00\x3D\x00\x00\x00\x00"
				append ::patch_cos::replace "\x03\xB4\xC4\x21\xE0\xC0\xDE\x70\x8C\x0F\x0B\x71\xC2\x4E\x3E\xE0"
				append ::patch_cos::replace "\x43\x06\xAE\x73\x83\xD8\xC5\x62\x13\x94\xCC\xB9\x9F\xF7\xA1\x94"
				append ::patch_cos::replace "\x5A\xDB\x9E\xAF\xE8\x97\xB5\x4C\xB1\x06\x0D\x68\x85\xBE\x22\xCF"
				append ::patch_cos::replace "\x71\x50\x2A\xDB\x57\x83\x58\x3A\xB8\x8B\x2D\x5F\x23\xF4\x19\xAF"
				append ::patch_cos::replace "\x01\xC8\xB1\xE7\x2F\xCA\x1E\x69\x4A\xD4\x9F\xE3\x26\x6F\x1F\x9C"
				append ::patch_cos::replace "\x61\xEF\xC6\xF2\x9B\x35\x11\x42\x00\x00\x00\x12\x00\x00\x00\x00"
				
				set ::patch_cos::offset 5
				set self "appldr"
				set file [file join $path $self]
				set ::SELF $self
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf						
			}	
			# patch 360 keys to appldr_355
			if {$::patch_cos::options(--add-360keys-to-appldr355)} {
			
				log "Patching Application loader 3.55 to add 3.60 keys"				
				##  set the filename here, and prepend the "path"
				##  (this may need adjusted, as the default "path" is what is returned
				##   when "unpackaging" the CORE_OS.pkg)
				set self "appldr"
				set file [file join $path $self]
				set ::SELF $self				
				
				log "patching ecdsa signature check 0x09EF8 @ 3.55"
				set ::patch_cos::search    "\x12\x05\x91\x09\x24\xFF\xC0\xD0"
				set ::patch_cos::replace   "\x48\x20\xC1\x83\x35\x00\x00\x00"
				set ::patch_cos::offset 0				
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf		
										 
				log "patching various checks (crapdicrap) 0x02DD0 @ 3.55"
				set ::patch_cos::search    "\x33\x7F\x8E\x00\x04\x00\x01\xD0\x21\x00\x19\x83"
				set ::patch_cos::replace   "\x00\x20\x00\x00\x48\x34\x28\x50\x48\x20\xC1\x83"
				set ::patch_cos::offset 0				
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf						
							  
				log "patching key revision check 0x013AC @ 3.55"
				set ::patch_cos::search    "\x5D\x03\x03\x15"
				set ::patch_cos::replace   "\x5D\x04\x03\x15"
				set ::patch_cos::offset 0				
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf			  				
				
				log "patching 2nd keytable addr r6 0x01440 @ 3.55"
				set ::patch_cos::search    "\x43\x64\x00\x06"
				set ::patch_cos::replace   "\x43\x61\x90\x06"
				set ::patch_cos::offset 0				
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf			 				
				
				log "extend first keytable 0x19820 @ 3.55"
				set ::patch_cos::search    "\x00\x00\x00\x00\x00\x95\xF5\x00\x19\xE7\xA6\x8E\x34\x1F\xA7\x2E"			 
				set ::patch_cos::replace    "\x95\xF5\x00\x19\xE7\xA6\x8E\x34\x1F\xA7\x2E\xFD\xF4\xD6\x0E\xD3"
				append ::patch_cos::replace "\x76\xE2\x5C\xF4\x6B\xB4\x8D\xFD\xD1\xF0\x80\x25\x9D\xC9\x3F\x04"
				append ::patch_cos::replace "\x4A\x09\x55\xD9\x46\xDB\x70\xD6\x91\xA6\x40\xBB\x7F\xAE\xCC\x4C"
				append ::patch_cos::replace "\x6F\x8D\xF8\xEB\xD0\xA1\xD1\xDB\x08\xB3\x0D\xD3\xA9\x51\xE3\xF1"
				append ::patch_cos::replace "\xF2\x7E\x34\x03\x0B\x42\xC7\x29\xC5\x55\x55\x23\x2D\x61\xB8\x34"
				append ::patch_cos::replace "\xB8\xBD\xFF\xB0\x7E\x54\xB3\x43\x00\x00\x00\x21\x00\x00\x00\x00"
			 
				append ::patch_cos::replace "\x79\x48\x18\x39\xC4\x06\xA6\x32\xBD\xB4\xAC\x09\x3D\x73\xD9\x9A"
				append ::patch_cos::replace "\xE1\x58\x7F\x24\xCE\x7E\x69\x19\x2C\x1C\xD0\x01\x02\x74\xA8\xAB"
				append ::patch_cos::replace "\x6F\x0F\x25\xE1\xC8\xC4\xB7\xAE\x70\xDF\x96\x8B\x04\x52\x1D\xDA"
				append ::patch_cos::replace "\x94\xD1\xB7\x37\x8B\xAF\xF5\xDF\xED\x26\x92\x40\xA7\xA3\x64\xED"
				append ::patch_cos::replace "\x68\x44\x67\x41\x62\x2E\x50\xBC\x60\x79\xB6\xE6\x06\xA2\xF8\xE0"
				append ::patch_cos::replace "\xA4\xC5\x6E\x5C\xFF\x83\x65\x26\x00\x00\x00\x11\x00\x00\x00\x00"
			 
				append ::patch_cos::replace "\x4F\x89\xBE\x98\xDD\xD4\x3C\xAD\x34\x3F\x5B\xA6\xB1\xA1\x33\xB0"
				append ::patch_cos::replace "\xA9\x71\x56\x6F\x77\x04\x84\xAA\xC2\x0B\x5D\xD1\xDC\x9F\xA0\x6A"
				append ::patch_cos::replace "\x90\xC1\x27\xA9\xB4\x3B\xA9\xD8\xE8\x9F\xE6\x52\x9E\x25\x20\x6F"
				append ::patch_cos::replace "\x8C\xA6\x90\x5F\x46\x14\x8D\x7D\x8D\x84\xD2\xAF\xCE\xAE\x61\xB4"
				append ::patch_cos::replace "\x1E\x67\x50\xFC\x22\xEA\x43\x5D\xFA\x61\xFC\xE6\xF4\xF8\x60\xEE"
				append ::patch_cos::replace "\x4F\x54\xD9\x19\x6C\xA5\x29\x0E\x00\x00\x00\x13\x00\x00\x00\x00"
			 
				append ::patch_cos::replace "\xC1\xE6\xA3\x51\xFC\xED\x6A\x06\x36\xBF\xCB\x68\x01\xA0\x94\x2D"
				append ::patch_cos::replace "\xB7\xC2\x8B\xDF\xC5\xE0\xA0\x53\xA3\xF5\x2F\x52\xFC\xE9\x75\x4E"
				append ::patch_cos::replace "\xE0\x90\x81\x63\xF4\x57\x57\x64\x40\x46\x6A\xCA\xA4\x43\xAE\x7C"
				append ::patch_cos::replace "\x50\x02\x2D\x5D\x37\xC9\x79\x05\xF8\x98\xE7\x8E\x7A\xA1\x4A\x0B"
				append ::patch_cos::replace "\x5C\xAA\xD5\xCE\x81\x90\xAE\x56\x29\xA1\x0D\x6F\x0C\xF4\x17\x35"
				append ::patch_cos::replace "\x97\xB3\x7A\x95\xA7\x54\x5C\x92\x00\x00\x00\x0B\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x83\x8F\x58\x60\xCF\x97\xCD\xAD\x75\xB3\x99\xCA\x44\xF4\xC2\x14"
				append ::patch_cos::replace "\xCD\xF9\x51\xAC\x79\x52\x98\xD7\x1D\xF3\xC3\xB7\xE9\x3A\xAE\xDA"
				append ::patch_cos::replace "\x7F\xDB\xB2\xE9\x24\xD1\x82\xBB\x0D\x69\x84\x4A\xDC\x4E\xCA\x5B"
				append ::patch_cos::replace "\x1F\x14\x0E\x8E\xF8\x87\xDA\xB5\x2F\x07\x9A\x06\xE6\x91\x5A\x64"
				append ::patch_cos::replace "\x60\xB7\x5C\xD2\x56\x83\x4A\x43\xFA\x7A\xF9\x0C\x23\x06\x7A\xF4"
				append ::patch_cos::replace "\x12\xED\xAF\xE2\xC1\x77\x8D\x69\x00\x00\x00\x14\x00\x00\x00\x00"
			 
				append ::patch_cos::replace "\xC1\x09\xAB\x56\x59\x3D\xE5\xBE\x8B\xA1\x90\x57\x8E\x7D\x81\x09"
				append ::patch_cos::replace "\x34\x6E\x86\xA1\x10\x88\xB4\x2C\x72\x7E\x2B\x79\x3F\xD6\x4B\xDC"
				append ::patch_cos::replace "\x15\xD3\xF1\x91\x29\x5C\x94\xB0\x9B\x71\xEB\xDE\x08\x8A\x18\x7A"
				append ::patch_cos::replace "\xB6\xBB\x0A\x84\xC6\x49\xA9\x0D\x97\xEB\xA5\x5B\x55\x53\x66\xF5"
				append ::patch_cos::replace "\x23\x81\xBB\x38\xA8\x4C\x8B\xB7\x1D\xA5\xA5\xA0\x94\x90\x43\xC6"
				append ::patch_cos::replace "\xDB\x24\x90\x29\xA4\x31\x56\xF7\x00\x00\x00\x15\x00\x00\x00\x00"
			 
				append ::patch_cos::replace "\x6D\xFD\x7A\xFB\x47\x0D\x2B\x2C\x95\x5A\xB2\x22\x64\xB1\xFF\x3C"
				append ::patch_cos::replace "\x67\xF1\x80\x98\x3B\x26\xC0\x16\x15\xDE\x9F\x2E\xCC\xBE\x7F\x41"
				append ::patch_cos::replace "\x24\xBD\x1C\x19\xD2\xA8\x28\x6B\x8A\xCE\x39\xE4\xA3\x78\x01\xC2"
				append ::patch_cos::replace "\x71\xF4\x6A\xC3\x3F\xF8\x9D\xF5\x89\xA1\x00\xA7\xFB\x64\xCE\xAC"
				append ::patch_cos::replace "\x24\x4C\x9A\x0C\xBB\xC1\xFD\xCE\x80\xFB\x4B\xF8\xA0\xD2\xE6\x62"
				append ::patch_cos::replace "\x93\x30\x9C\xB8\xEE\x8C\xFA\x95\x00\x00\x00\x2C\x00\x00\x00\x00"
			 
				append ::patch_cos::replace "\x94\x5B\x99\xC0\xE6\x9C\xAF\x05\x58\xC5\x88\xB9\x5F\xF4\x1B\x23"
				append ::patch_cos::replace "\x26\x60\xEC\xB0\x17\x74\x1F\x32\x18\xC1\x2F\x9D\xFD\xEE\xDE\x55"
				append ::patch_cos::replace "\x1D\x5E\xFB\xE7\xC5\xD3\x4A\xD6\x0F\x9F\xBC\x46\xA5\x97\x7F\xCE"
				append ::patch_cos::replace "\xAB\x28\x4C\xA5\x49\xB2\xDE\x9A\xA5\xC9\x03\xB7\x56\x52\xF7\x8D"
				append ::patch_cos::replace "\x19\x2F\x8F\x4A\x8F\x3C\xD9\x92\x09\x41\x5C\x0A\x84\xC5\xC9\xFD"
				append ::patch_cos::replace "\x6B\xF3\x09\x5C\x1C\x18\xFF\xCD\x00\x00\x00\x15\x00\x00\x00\x00"
			 
				append ::patch_cos::replace "\x2C\x9E\x89\x69\xEC\x44\xDF\xB6\xA8\x77\x1D\xC7\xF7\xFD\xFB\xCC"
				append ::patch_cos::replace "\xAF\x32\x9E\xC3\xEC\x07\x09\x00\xCA\xBB\x23\x74\x2A\x9A\x6E\x13"
				append ::patch_cos::replace "\x5A\x4C\xEF\xD5\xA9\xC3\xC0\x93\xD0\xB9\x35\x23\x76\xD1\x94\x05"
				append ::patch_cos::replace "\x6E\x82\xF6\xB5\x4A\x0E\x9D\xEB\xE4\xA8\xB3\x04\x3E\xE3\xB2\x4C"
				append ::patch_cos::replace "\xD9\xBB\xB6\x2B\x44\x16\xB0\x48\x25\x82\xE4\x19\xA2\x55\x2E\x29"
				append ::patch_cos::replace "\xAB\x4B\xEA\x0A\x4D\x7F\xA2\xD5\x00\x00\x00\x16\x00\x00\x00\x00"
			  
				append ::patch_cos::replace "\xF6\x9E\x4A\x29\x34\xF1\x14\xD8\x9F\x38\x6C\xE7\x66\x38\x83\x66"
				append ::patch_cos::replace "\xCD\xD2\x10\xF1\xD8\x91\x3E\x3B\x97\x32\x57\xF1\x20\x1D\x63\x2B"
				append ::patch_cos::replace "\xF4\xD5\x35\x06\x93\x01\xEE\x88\x8C\xC2\xA8\x52\xDB\x65\x44\x61"
				append ::patch_cos::replace "\x1D\x7B\x97\x4D\x10\xE6\x1C\x2E\xD0\x87\xA0\x98\x15\x35\x90\x46"
				append ::patch_cos::replace "\x77\xEC\x07\xE9\x62\x60\xF8\x95\x65\xFF\x7E\xBD\xA4\xEE\x03\x5C"
				append ::patch_cos::replace "\x2A\xA9\xBC\xBD\xD5\x89\x3F\x99\x00\x00\x00\x2D\x00\x00\x00\x00"
			 
				append ::patch_cos::replace "\x29\x80\x53\x02\xE7\xC9\x2F\x20\x40\x09\x16\x1C\xA9\x3F\x77\x6A"
				append ::patch_cos::replace "\x07\x21\x41\xA8\xC4\x6A\x10\x8E\x57\x1C\x46\xD4\x73\xA1\x76\xA3"
				append ::patch_cos::replace "\x5D\x1F\xAB\x84\x41\x07\x67\x6A\xBC\xDF\xC2\x5E\xAE\xBC\xB6\x33"
				append ::patch_cos::replace "\x09\x30\x1B\x64\x36\xC8\x5B\x53\xCB\x15\x85\x30\x0A\x3F\x1A\xF9"
				append ::patch_cos::replace "\xFB\x14\xDB\x7C\x30\x08\x8C\x46\x42\xAD\x66\xD5\xC1\x48\xB8\x99"
				append ::patch_cos::replace "\x5B\xB1\xA6\x98\xA8\xC7\x18\x27\x00\x00\x00\x25\x00\x00\x00\x00"
			  
				append ::patch_cos::replace "\xA4\xC9\x74\x02\xCC\x8A\x71\xBC\x77\x48\x66\x1F\xE9\xCE\x7D\xF4"
				append ::patch_cos::replace "\x4D\xCE\x95\xD0\xD5\x89\x38\xA5\x9F\x47\xB9\xE9\xDB\xA7\xBF\xC3"
				append ::patch_cos::replace "\xE4\x79\x2F\x2B\x9D\xB3\x0C\xB8\xD1\x59\x60\x77\xA1\x3F\xB3\xB5"
				append ::patch_cos::replace "\x27\x33\xC8\x89\xD2\x89\x55\x0F\xE0\x0E\xAA\x5A\x47\xA3\x4C\xEF"
				append ::patch_cos::replace "\x0C\x1A\xF1\x87\x61\x0E\xB0\x7B\xA3\x5D\x2C\x09\xBB\x73\xC8\x0B"
				append ::patch_cos::replace "\x24\x4E\xB4\x14\x77\x00\xD1\xBF\x00\x00\x00\x26\x00\x00\x00\x00"
			 
				append ::patch_cos::replace "\x98\x14\xEF\xFF\x67\xB7\x07\x4D\x1B\x26\x3B\xF8\x5B\xDC\x85\x76"
				append ::patch_cos::replace "\xCE\x9D\xEC\x91\x41\x23\x97\x1B\x16\x94\x72\xA1\xBC\x23\x87\xFA"
				append ::patch_cos::replace "\xD4\x3B\x1F\xA8\xBE\x15\x71\x4B\x30\x78\xC2\x39\x08\xBB\x2B\xCA"
				append ::patch_cos::replace "\x7D\x19\x86\xC6\xBE\xE6\xCE\x1E\x0C\x58\x93\xBD\x2D\xF2\x03\x88"
				append ::patch_cos::replace "\x1F\x40\xD5\x05\x67\x61\xCC\x3F\x1F\x2E\x9D\x9A\x37\x86\x17\xA2"
				append ::patch_cos::replace "\xDE\x40\xBA\x5F\x09\x84\x4C\xEB\x00\x00\x00\x3D\x00\x00\x00\x00"
			 
				append ::patch_cos::replace "\x03\xB4\xC4\x21\xE0\xC0\xDE\x70\x8C\x0F\x0B\x71\xC2\x4E\x3E\xE0"
				append ::patch_cos::replace "\x43\x06\xAE\x73\x83\xD8\xC5\x62\x13\x94\xCC\xB9\x9F\xF7\xA1\x94"
				append ::patch_cos::replace "\x5A\xDB\x9E\xAF\xE8\x97\xB5\x4C\xB1\x06\x0D\x68\x85\xBE\x22\xCF"
				append ::patch_cos::replace "\x71\x50\x2A\xDB\x57\x83\x58\x3A\xB8\x8B\x2D\x5F\x23\xF4\x19\xAF"
				append ::patch_cos::replace "\x01\xC8\xB1\xE7\x2F\xCA\x1E\x69\x4A\xD4\x9F\xE3\x26\x6F\x1F\x9C"
				append ::patch_cos::replace "\x61\xEF\xC6\xF2\x9B\x35\x11\x42\x00\x00\x00\x12\x00\x00\x00\x00"
			 
				append ::patch_cos::replace "\x39\xA8\x70\x17\x3C\x22\x6E\xB8\xA3\xEE\xE9\xCA\x6F\xB6\x75\xE8"
				append ::patch_cos::replace "\x20\x39\xB2\xD0\xCC\xB2\x26\x53\xBF\xCE\x4D\xB0\x13\xBA\xEA\x03"
				append ::patch_cos::replace "\x90\x26\x6C\x98\xCB\xAA\x06\xC1\xBF\x14\x5F\xF7\x60\xEA\x1B\x45"
				append ::patch_cos::replace "\x84\xDE\x56\x92\x80\x98\x48\xE5\xAC\xBE\x25\xBE\x54\x8F\x69\x81"
				append ::patch_cos::replace "\xE3\xDB\x14\x73\x5A\x5D\xDE\x1A\x0F\xD1\xF4\x75\x86\x65\x32\xB8"
				append ::patch_cos::replace "\x62\xB1\xAB\x6A\x00\x4B\x72\x55\x00\x00\x00\x27\x00\x00\x00\x00"
			  
				append ::patch_cos::replace "\xFD\x52\xDF\xA7\xC6\xEE\xF5\x67\x96\x28\xD1\x2E\x26\x7A\xA8\x63"
				append ::patch_cos::replace "\xB9\x36\x5E\x6D\xB9\x54\x70\x94\x9C\xFD\x23\x5B\x3F\xCA\x0F\x3B"
				append ::patch_cos::replace "\x64\xF5\x02\x96\xCF\x8C\xF4\x9C\xD7\xC6\x43\x57\x28\x87\xDA\x0B"
				append ::patch_cos::replace "\x06\x96\xD6\xCC\xBD\x7C\xF5\x85\xEF\x5E\x00\xD5\x47\x50\x3C\x18"
				append ::patch_cos::replace "\x5D\x74\x21\x58\x1B\xAD\x19\x6E\x08\x17\x23\xCD\x0A\x97\xFA\x40"
				append ::patch_cos::replace "\xB2\xC0\xCD\x24\x92\xB0\xB5\xA1\x00\x00\x00\x3A\x00\x00\x00\x00"
			   
				append ::patch_cos::replace "\xA5\xE5\x1A\xD8\xF3\x2F\xFB\xDE\x80\x89\x72\xAC\xEE\x46\x39\x7F"
				append ::patch_cos::replace "\x2D\x3F\xE6\xBC\x82\x3C\x82\x18\xEF\x87\x5E\xE3\xA9\xB0\x58\x4F"
				append ::patch_cos::replace "\x7A\x20\x3D\x51\x12\xF7\x99\x97\x9D\xF0\xE1\xB8\xB5\xB5\x2A\xA4"
				append ::patch_cos::replace "\x50\x59\x7B\x7F\x68\x0D\xD8\x9F\x65\x94\xD9\xBD\xC0\xCB\xEE\x03"
				append ::patch_cos::replace "\x66\x6A\xB5\x36\x47\xD0\x48\x7F\x7F\x45\x2F\xE2\xDD\x02\x69\x46"
				append ::patch_cos::replace "\x31\xEA\x75\x55\x48\xC9\xE9\x34\x00\x00\x00\x25\x00\x00\x00\x00"
				
				set ::patch_cos::offset 5				
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf					 				
			 
				log "patching NPDRM key revision check 0x00B40 @ 3.55"
				set ::patch_cos::search    "\x5D\x03\x02\x02"
				set ::patch_cos::replace   "\x5D\x04\x02\x02"
				set ::patch_cos::offset 0				
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf				 				
			  
				log "patching NPDRM forbidden key revision table size 0x00B50 @ 3.55"
				set ::patch_cos::search    "\x1C\x02\x02\x87"
				set ::patch_cos::replace   "\x1C\x03\x02\x87"
				set ::patch_cos::offset 0				
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf				 				
			 
				log "patching NPDRM forbidden key revision table 0x19720 @ 3.55"
				set ::patch_cos::search    "\x00\x02\x00\x05\x00\x08\x00\x0B\x00\x00\x00\x00\x00\x00\x00\x00"
				set ::patch_cos::replace   "\x00\x02\x00\x05\x00\x08\x00\x0B\x00\x0E\x00\x11\x00\x00\x00\x00"
				set ::patch_cos::offset 0				
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf				   				
			   
				log "patching 2nd keytable addr r11 0x01518 @ 3.55"
				set ::patch_cos::search    "\x43\x69\x10\x0B"
				set ::patch_cos::replace   "\x43\x66\xA0\x0B"
				set ::patch_cos::offset 0				
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf					 				
			 
				log "extend first NPDRM keytable 0x1A240 @ 3.55"
				set ::patch_cos::search    "\x23\x00\x00\x00\x00\x8E\x73\x72\x30\xC8\x0E\x66\xAD\x01\x62\xED"
				
				set ::patch_cos::replace "\x8E\x73\x72\x30\xC8\x0E\x66\xAD\x01\x62\xED\xDD\x32\xF1\xF7\x74"
				append ::patch_cos::replace "\xEE\x5E\x4E\x18\x74\x49\xF1\x90\x79\x43\x7A\x50\x8F\xCF\x9C\x86"
				append ::patch_cos::replace "\x7A\xAE\xCC\x60\xAD\x12\xAE\xD9\x0C\x34\x8D\x8C\x11\xD2\xBE\xD5"
				append ::patch_cos::replace "\x05\xBF\x09\xCB\x6F\xD7\x80\x50\xC7\x8D\xE6\x9C\xC3\x16\xFF\x27"
				append ::patch_cos::replace "\xC9\xF1\xED\x66\xA4\x5B\xFC\xE0\xA1\xE5\xA6\x74\x9B\x19\xBD\x54"
				append ::patch_cos::replace "\x6B\xBB\x46\x02\xCF\x37\x34\x40\x00\x00\x00\x0A\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\xF9\xED\xD0\x30\x1F\x77\x0F\xAB\xBA\x88\x63\xD9\x89\x7F\x0F\xEA"
				append ::patch_cos::replace "\x65\x51\xB0\x94\x31\xF6\x13\x12\x65\x4E\x28\xF4\x35\x33\xEA\x6B"
				append ::patch_cos::replace "\xA5\x51\xCC\xB4\xA4\x2C\x37\xA7\x34\xA2\xB4\xF9\x65\x7D\x55\x40"
				append ::patch_cos::replace "\xB0\x5F\x9D\xA5\xF9\x12\x1E\xE4\x03\x14\x67\xE7\x4C\x50\x5C\x29"
				append ::patch_cos::replace "\xA8\xE2\x9D\x10\x22\x37\x9E\xDF\xF0\x50\x0B\x9A\xE4\x80\xB5\xDA"
				append ::patch_cos::replace "\xB4\x57\x8A\x4C\x61\xC5\xD6\xBF\x00\x00\x00\x11\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x1B\x71\x5B\x0C\x3E\x8D\xC4\xC1\xA5\x77\x2E\xBA\x9C\x5D\x34\xF7"
				append ::patch_cos::replace "\xCC\xFE\x5B\x82\x02\x5D\x45\x3F\x31\x67\x56\x64\x97\x23\x96\x64"
				append ::patch_cos::replace "\xE3\x1E\x20\x6F\xBB\x8A\xEA\x27\xFA\xB0\xD9\xA2\xFF\xB6\xB6\x2F"
				append ::patch_cos::replace "\x3F\x51\xE5\x9F\xC7\x4D\x66\x18\xD3\x44\x31\xFA\x67\x98\x7F\xA1"
				append ::patch_cos::replace "\x1A\xBB\xFA\xCC\x71\x11\x81\x14\x73\xCD\x99\x88\xFE\x91\xC4\x3F"
				append ::patch_cos::replace "\xC7\x46\x05\xE7\xB8\xCB\x73\x2D\x00\x00\x00\x08\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\xBB\x4D\xBF\x66\xB7\x44\xA3\x39\x34\x17\x2D\x9F\x83\x79\xA7\xA5"
				append ::patch_cos::replace "\xEA\x74\xCB\x0F\x55\x9B\xB9\x5D\x0E\x7A\xEC\xE9\x17\x02\xB7\x06"
				append ::patch_cos::replace "\xAD\xF7\xB2\x07\xA1\x5A\xC6\x01\x11\x0E\x61\xDD\xFC\x21\x0A\xF6"
				append ::patch_cos::replace "\x9C\x32\x74\x71\xBA\xFF\x1F\x87\x7A\xE4\xFE\x29\xF4\x50\x1A\xF5"
				append ::patch_cos::replace "\xAD\x6A\x2C\x45\x9F\x86\x22\x69\x7F\x58\x3E\xFC\xA2\xCA\x30\xAB"
				append ::patch_cos::replace "\xB5\xCD\x45\xD1\x13\x1C\xAB\x30\x00\x00\x00\x16\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x8B\x4C\x52\x84\x97\x65\xD2\xB5\xFA\x3D\x56\x28\xAF\xB1\x76\x44"
				append ::patch_cos::replace "\xD5\x2B\x9F\xFE\xE2\x35\xB4\xC0\xDB\x72\xA6\x28\x67\xEA\xA0\x20"
				append ::patch_cos::replace "\x05\x71\x9D\xF1\xB1\xD0\x30\x6C\x03\x91\x0A\xDD\xCE\x4A\xF8\x87"
				append ::patch_cos::replace "\x2A\x5D\x6C\x69\x08\xCA\x98\xFC\x47\x40\xD8\x34\xC6\x40\x0E\x6D"
				append ::patch_cos::replace "\x6A\xD7\x4C\xF0\xA7\x12\xCF\x1E\x7D\xAE\x80\x6E\x98\x60\x5C\xC3"
				append ::patch_cos::replace "\x08\xF6\xA0\x36\x58\xF2\x97\x0E\x00\x00\x00\x29\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x39\x46\xDF\xAA\x14\x17\x18\xC7\xBE\x33\x9A\x0D\x6C\x26\x30\x1C"
				append ::patch_cos::replace "\x76\xB5\x68\xAE\xBC\x5C\xD5\x26\x52\xF2\xE2\xE0\x29\x74\x37\xC3"
				append ::patch_cos::replace "\xE4\x89\x7B\xE5\x53\xAE\x02\x5C\xDC\xBF\x2B\x15\xD1\xC9\x23\x4E"
				append ::patch_cos::replace "\xA1\x3A\xFE\x8B\x63\xF8\x97\xDA\x2D\x3D\xC3\x98\x7B\x39\x38\x9D"
				append ::patch_cos::replace "\xC1\x0B\xAD\x99\xDF\xB7\x03\x83\x8C\x4A\x0B\xC4\xE8\xBB\x44\x65"
				append ::patch_cos::replace "\x9C\x72\x6C\xFD\x0C\xE6\x0D\x0E\x00\x00\x00\x17\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x07\x86\xF4\xB0\xCA\x59\x37\xF5\x15\xBD\xCE\x18\x8F\x56\x9B\x2E"
				append ::patch_cos::replace "\xF3\x10\x9A\x4D\xA0\x78\x0A\x7A\xA0\x7B\xD8\x9C\x33\x50\x81\x0A"
				append ::patch_cos::replace "\x04\xAD\x3C\x2F\x12\x2A\x3B\x35\xE8\x04\x85\x0C\xAD\x14\x2C\x6D"
				append ::patch_cos::replace "\xA1\xFE\x61\x03\x5D\xBB\xEA\x5A\x94\xD1\x20\xD0\x3C\x00\x0D\x3B"
				append ::patch_cos::replace "\x2F\x08\x4B\x9F\x4A\xFA\x99\xA2\xD4\xA5\x88\xDF\x92\xB8\xF3\x63"
				append ::patch_cos::replace "\x27\xCE\x9E\x47\x88\x9A\x45\xD0\x00\x00\x00\x2A\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x03\xC2\x1A\xD7\x8F\xBB\x6A\x3D\x42\x5E\x9A\xAB\x12\x98\xF9\xFD"
				append ::patch_cos::replace "\x70\xE2\x9F\xD4\xE6\xE3\xA3\xC1\x51\x20\x5D\xA5\x0C\x41\x3D\xE4"
				append ::patch_cos::replace "\x0A\x99\xD4\xD4\xF8\x30\x1A\x88\x05\x2D\x71\x4A\xD2\xFB\x56\x5E"
				append ::patch_cos::replace "\x39\x95\xC3\x90\xC9\xF7\xFB\xBA\xB1\x24\xA1\xC1\x4E\x70\xF9\x74"
				append ::patch_cos::replace "\x1A\x5E\x6B\xDF\x17\xA6\x05\xD8\x82\x39\x65\x2C\x8E\xA7\xD5\xFC"
				append ::patch_cos::replace "\x9F\x24\xB3\x05\x46\xC1\xE4\x4B\x00\x00\x00\x27\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x35\x7E\xBB\xEA\x26\x5F\xAE\xC2\x71\x18\x2D\x57\x1C\x6C\xD2\xF6"
				append ::patch_cos::replace "\x2C\xFA\x04\xD3\x25\x58\x8F\x21\x3D\xB6\xB2\xE0\xED\x16\x6D\x92"
				append ::patch_cos::replace "\xD2\x6E\x6D\xD2\xB7\x4C\xD7\x8E\x86\x6E\x74\x2E\x55\x71\xB8\x4F"
				append ::patch_cos::replace "\x00\xDC\xF5\x39\x16\x18\x60\x4A\xB4\x2C\x8C\xFF\x3D\xC3\x04\xDF"
				append ::patch_cos::replace "\x45\x34\x1E\xBA\x45\x51\x29\x3E\x9E\x2B\x68\xFF\xE2\xDF\x52\x7F"
				append ::patch_cos::replace "\xFA\x3B\xE8\x32\x9E\x01\x5E\x57\x00\x00\x00\x3A\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x33\x7A\x51\x41\x61\x05\xB5\x6E\x40\xD7\xCA\xF1\xB9\x54\xCD\xAF"
				append ::patch_cos::replace "\x4E\x76\x45\xF2\x83\x79\x90\x4F\x35\xF2\x7E\x81\xCA\x7B\x69\x57"
				append ::patch_cos::replace "\x84\x05\xC8\x8E\x04\x22\x80\xDB\xD7\x94\xEC\x7E\x22\xB7\x40\x02"
				append ::patch_cos::replace "\x9B\xFF\x1C\xC7\x11\x8D\x23\x93\xDE\x50\xD5\xCF\x44\x90\x98\x60"
				append ::patch_cos::replace "\x68\x34\x11\xA5\x32\x76\x7B\xFD\xAC\x78\x62\x2D\xB9\xE5\x45\x67"
				append ::patch_cos::replace "\x53\xFE\x42\x2C\xBA\xFA\x1D\xA1\x00\x00\x00\x18\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x13\x5C\x09\x8C\xBE\x6A\x3E\x03\x7E\xBE\x9F\x2B\xB9\xB3\x02\x18"
				append ::patch_cos::replace "\xDD\xE8\xD6\x82\x17\x34\x6F\x9A\xD3\x32\x03\x35\x2F\xBB\x32\x91"
				append ::patch_cos::replace "\x40\x70\xC8\x98\xC2\xEA\xAD\x16\x34\xA2\x88\xAA\x54\x7A\x35\xA8"
				append ::patch_cos::replace "\xBB\xD7\xCC\xCB\x55\x6C\x2E\xF0\xF9\x08\xDC\x78\x10\xFA\xFC\x37"
				append ::patch_cos::replace "\xF2\xE5\x6B\x3D\xAA\x5F\x7F\xAF\x53\xA4\x94\x4A\xA9\xB8\x41\xF7"
				append ::patch_cos::replace "\x6A\xB0\x91\xE1\x6B\x23\x14\x33\x00\x00\x00\x3B\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x4B\x3C\xD1\x0F\x6A\x6A\xA7\xD9\x9F\x9B\x3A\x66\x0C\x35\xAD\xE0"
				append ::patch_cos::replace "\x8E\xF0\x1C\x2C\x33\x6B\x9E\x46\xD1\xBB\x56\x78\xB4\x26\x1A\x61"
				append ::patch_cos::replace "\xC0\xF2\xAB\x86\xE6\xE0\x45\x75\x52\xDB\x50\xD7\x21\x93\x71\xC5"
				append ::patch_cos::replace "\x64\xA5\xC6\x0B\xC2\xAD\x18\xB8\xA2\x37\xE4\xAA\x69\x06\x47\xE1"
				append ::patch_cos::replace "\x2B\xF7\xA0\x81\x52\x3F\xAD\x4F\x29\xBE\x89\xAC\xAC\x72\xF7\xAB"
				append ::patch_cos::replace "\x43\xC7\x4E\xC9\xAF\xFD\xA2\x13\x00\x00\x00\x27\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
				
				set ::patch_cos::offset 5				
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf						
			}	
		}			
	}
	### ------------------------------------- END:    Do_LV0_Patches{} --------------------------------------------- ### 
	
	
	
	# --------------------------  BEGIN:  Do_LV1_Patches   --------------------------------------------------------- ### 
	#
	# This proc is for applying any patches to the "LV1" self file
	#
	#	
	proc Do_LV1_Patches {path} {
		
		# **** LV1 PATCHES ARE CURRENTLY DONE IN "patch_lv1.tcl" *****
		#log "Applying LV1 patches...."
	
	}
	### ------------------------------------- END:    Do_LV1_Patches{} --------------------------------------------- ###   
	
	
	
	# --------------------------  BEGIN:  Do_LV2_Patches   --------------------------------------------------------- ### 
	#
	# This proc is for applying any patches to the "LV2" self file
	#
	#
	proc Do_LV2_Patches {path} {
	
		log "Applying LV2 patches...."
		
		#if {!$::patch_cos::options(--patch-lv2-peek-poke-355) && !$::patch_cos::options(--patch-lv2-peek-poke-4x) && $::patch_cos::options(--patch-lv2-lv1-peek-poke-355) || $::patch_cos::options(--patch-lv2-lv1-call-355) ||  $::patch_cos::options(--patch-lv2-payload-hermes-355) ||  $::patch_cos::options(--patch-lv2-SC36-355) ||  $::patch_cos::options(--patch-lv2-lv1-peek-poke-4x) ||  $::patch_cos::options(--patch-lv2-npdrm-ecdsa-check) ||  $::patch_cos::options(--patch-lv2-payload-hermes-4x) ||  $::patch_cos::options(--patch-lv2-SC36-4x)} {
        #    set self "lv2_kernel.self"
        #    ::modify_self_file $self ::patch_cos::patch_elf
        #}
		
		##  set the filename here, and prepend the "path"
		set self "lv2_kernel.self"
		set file [file join $path $self]
		set ::SELF $self
	
		# check for any erroneous settings, and throw up message boxes if so
		if {$::patch_cos::options(--patch-lv2-peek-poke-355) || $::patch_cos::options(--patch-lv2-peek-poke-4x) } {
            if {[::patch_cos::check_task] == "true"} {
                log "WARNING: You enabled Peek&Poke without enabling LV1 mmap or LV2 protection patching." 1
                log "WARNING: Patching LV1 mmap or deactivated LV2 protection is necessary for Poke to function." 1
				tk_messageBox -default ok -message "WARNING: You enabled Peek&Poke without enabling LV1 mmap or LV2 protection patching, \
				Patching LV1 mmap or deactivated LV2 protection is necessary for Poke to function." -icon warning
            } 
        }		
		# if "lv2-peek-poke" enabled for LV2 3.55
		if {$::patch_cos::options(--patch-lv2-peek-poke-355)} {
		
			log "Patching LV2 to allow Peek and Poke support"										
			set ::patch_cos::search    "\xEB\xA1\x00\x88\x38\x60\x00\x00\xEB\xC1\x00\x90\xEB\xE1\x00\x98"
			append ::patch_cos::search "\x7C\x08\x03\xA6\x7C\x63\x07\xB4\x38\x21\x00\xA0\x4E\x80\x00\x20"
			append ::patch_cos::search "\x3C\x60\x80\x01\x60\x63\x00\x03\x4E\x80\x00\x20\x3C\x60\x80\x01"
			append ::patch_cos::search "\x60\x63\x00\x03\x4E\x80\x00\x20"
			set ::patch_cos::replace   "\xE8\x63\x00\x00\x60\x00\x00\x00\x4E\x80\x00\x20\xF8\x83\x00\x00\x60\x00\x00\x00"				 
			set ::patch_cos::offset 32
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf						
		}
		# if "patch-lv2-lv1-peek-poke" for LV2 3.55
		if {$::patch_cos::options(--patch-lv2-lv1-peek-poke-355)} {
		
			log "Patching LV2 to allow LV1 Peek and Poke support (3.55)"					
			set ::patch_cos::search     "\x7C\x71\x43\xA6\x7C\x92\x43\xA6\x7C\xB3\x43\xA6\x48"
			set ::patch_cos::replace    "\x7C\x08\x02\xA6\xF8\x01\x00\x10\x39\x60\x00\xB6\x44\x00\x00\x22"
			append ::patch_cos::replace "\x7C\x83\x23\x78\xE8\x01\x00\x10\x7C\x08\x03\xA6\x4E\x80\x00\x20"
			append ::patch_cos::replace "\x7C\x08\x02\xA6\xF8\x01\x00\x10\x39\x60\x00\xB7\x44\x00\x00\x22"
			append ::patch_cos::replace "\x38\x60\x00\x00\xE8\x01\x00\x10\x7C\x08\x03\xA6\x4E\x80\x00\x20"				 
			set ::patch_cos::offset 5644
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf							
		 
			set ::patch_cos::search     "\xEB\xA1\x00\x88\x38\x60\x00\x00\xEB\xC1\x00\x90\xEB\xE1\x00\x98"
			append ::patch_cos::search  "\x7C\x08\x03\xA6\x7C\x63\x07\xB4\x38\x21\x00\xA0\x4E\x80\x00\x20"
			set ::patch_cos::replace    "\x4B\xFE\x83\xB8\x60\x00\x00\x00\x60\x00\x00\x00\x4B\xFE\x83\xCC"
			append ::patch_cos::replace "\x60\x00\x00\x00\x60\x00\x00\x00"
			set ::patch_cos::offset 56
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf						   
		}
		# if "--patch-lv2-lv1-call-355" enabled, do patch
		if {$::patch_cos::options(--patch-lv2-lv1-call-355)} {
		
			log "Patching LV2 to allow LV1 Call support (3.55)"				 
			set ::patch_cos::search     "\x7C\x71\x43\xA6\x7C\x92\x43\xA6\x7C\xB3\x43\xA6\x48"
			set ::patch_cos::replace    "\x7C\x08\x02\xA6\xF8\x01\x00\x10\x7D\x4B\x53\x78\x44\x00\x00\x22"
			append ::patch_cos::replace "\xE8\x01\x00\x10\x7C\x08\x03\xA6\x4E\x80\x00\x20"				  
			set ::patch_cos::offset 5708
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf							
		 
			set ::patch_cos::search     "\xEB\xA1\x00\x88\x38\x60\x00\x00\xEB\xC1\x00\x90\xEB\xE1\x00\x98"
			append ::patch_cos::search  "\x7C\x08\x03\xA6\x7C\x63\x07\xB4\x38\x21\x00\xA0\x4E\x80\x00\x20"
			set ::patch_cos::replace    "\x4B\xFE\x83\xE0\x60\x00\x00\x00\x60\x00\x00\x00"				 
			set ::patch_cos::offset 80
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf							
		}
		# if "--patch-lv2-payload-hermes-355" enabled, do patch
		if {$::patch_cos::options(--patch-lv2-payload-hermes-355)} {
		
			log "Patching Hermes payload 3.55 into LV2"				 
			set ::patch_cos::search     "\x4B\xFF\xFD\x04\xE8\x01\x00\x90\x60\x63\x00\x02\xEB\xC1\x00\x70"
			set ::patch_cos::replace    "\x25\x64\x25\x73\x25\x30\x31\x36\x6C\x78\x25\x30\x31\x36\x6C\x6C"
			append ::patch_cos::replace "\x78\x25\x30\x31\x36\x6C\x6C\x78\x25\x73\x25\x73\x25\x30\x38\x78"
			append ::patch_cos::replace "\x25\x64\x25\x31\x64\x25\x31\x64\x25\x31\x64\x41\x41\x41\x0A\x00"
			append ::patch_cos::replace "\xF8\x21\xFF\x31\x7C\x08\x02\xA6\xF8\x01\x00\xE0\xFB\xE1\x00\xC8"
			append ::patch_cos::replace "\x38\x81\x00\x70\x4B\xEC\xF7\x85\x3B\xE0\x00\x01\x7B\xFF\xF8\x06"
			append ::patch_cos::replace "\x67\xFF\x00\x2B\x63\xFF\xE5\x5C\xE8\x7F\x00\x00\x2C\x23\x00\x00"
			append ::patch_cos::replace "\x41\x82\x00\x0C\x38\x80\x00\x27\x4B\xDA\x2A\xAD\x38\x80\x00\x27"
			append ::patch_cos::replace "\x38\x60\x08\x00\x4B\xDA\x26\x65\xF8\x7F\x00\x00\xE8\x81\x00\x70"
			append ::patch_cos::replace "\x4B\xD9\x01\x65\xE8\x61\x00\x70\x38\x80\x00\x27\x4B\xDA\x2A\x89"
			append ::patch_cos::replace "\xE8\x7F\x00\x00\x4B\xD9\x01\x79\xE8\x9F\x00\x00\x7C\x64\x1A\x14"
			append ::patch_cos::replace "\xF8\x7F\x00\x08\x38\x60\x00\x00\xEB\xE1\x00\xC8\xE8\x01\x00\xE0"
			append ::patch_cos::replace "\x38\x21\x00\xD0\x7C\x08\x03\xA6\x4E\x80\x00\x20\x00\x00\x00\x00"
			append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
			append ::patch_cos::replace "\x80\x00\x00\x00\x00\x2B\xE4\xD0\x00\x00\x00\x00\x00\x00\x00\x00"
			append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
			append ::patch_cos::replace "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
			append ::patch_cos::replace "\xF8\x21\xFF\x61\x7C\x08\x02\xA6\xFB\x81\x00\x80\xFB\xA1\x00\x88"
			append ::patch_cos::replace "\xFB\xE1\x00\x98\xFB\x41\x00\x70\xFB\x61\x00\x78\xF8\x01\x00\xB0"
			append ::patch_cos::replace "\x7C\x9C\x23\x78\x7C\x7D\x1B\x78\x3B\xE0\x00\x01\x7B\xFF\xF8\x06"
			append ::patch_cos::replace "\x67\xE4\x00\x2B\x60\x84\xE6\x64\x38\xA0\x00\x09\x4B\xD9\x00\xFD"
			append ::patch_cos::replace "\x28\x23\x00\x00\x40\x82\x00\x30\x67\xFF\x00\x2B\x63\xFF\xE5\x5C"
			append ::patch_cos::replace "\xE8\x7F\x00\x00\x28\x23\x00\x00\x41\x82\x00\x14\xE8\x7F\x00\x08"
			append ::patch_cos::replace "\x38\x9D\x00\x09\x4B\xD9\x00\x81\xEB\xBF\x00\x00\x7F\xA3\xEB\x78"
			append ::patch_cos::replace "\x4B\xFF\x4C\x8C\x7F\xA3\xEB\x78\x3B\xE0\x00\x01\x7B\xFF\xF8\x06"
			append ::patch_cos::replace "\x67\xE4\x00\x2B\x60\x84\xE6\x6E\x38\xA0\x00\x09\x4B\xD9\x00\xAD"
			append ::patch_cos::replace "\x28\x23\x00\x00\x40\x82\x00\x28\x67\xFF\x00\x2B\x63\xFF\xE5\x5C"
			append ::patch_cos::replace "\xE8\x7F\x00\x00\x28\x23\x00\x00\x41\x82\x00\x14\xE8\x7F\x00\x08"
			append ::patch_cos::replace "\x38\x9D\x00\x09\x4B\xD9\x00\x31\xEB\xBF\x00\x00\x7F\xA3\xEB\x78"
			append ::patch_cos::replace "\x4B\xFF\x4C\x3C\x2F\x64\x65\x76\x5F\x62\x64\x76\x64\x00\x2F\x61"
			append ::patch_cos::replace "\x70\x70\x5F\x68\x6F\x6D\x65\x00"					
			set ::patch_cos::offset 0
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf									
			
			log "Patching Hermes payload pointer Syscall_Map_Open_Desc"    
			set ::patch_cos::search     "\x"
			set ::patch_cos::replace    "\x80\x00\x00\x00\x00\x2B\xE5\x70"
			set ::patch_cos::offset 0
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf									
		}
		# if "--patch-lv2-SC36-355" enabled, do patch
		if {$::patch_cos::options(--patch-lv2-SC36-355)} {
		
			log "Patching LV2 SysCall36 3.55 CFW"				 
			set ::patch_cos::search     "\x7C\x7F\x1B\x78\x41\xC2\x00\x58\x80\x1F\x00\x48\x2F\x80\x00\x02"
			set ::patch_cos::replace    "\x60\x00\x00\x00\x80\x1F\x00\x48\x48\x00\x00\x98"
			set ::patch_cos::offset 4
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf							
		   
			set ::patch_cos::search     "\x7C\xF9\x3B\x78\x90\x1D\x00\x80\x90\x1D\x00\x84\xF9\x3D\x00\x90"
			append ::patch_cos::search  "\x91\x3D\x00\x98\xF8\xDD\x00\xA0"
			set ::patch_cos::replace    "\x60\x00\x00\x00\x90\x1D\x00\x80\x90\x1D\x00\x84\xF9\x3D\x00\x90"
			append ::patch_cos::replace "\x91\x3D\x00\x98\x60\x00\x00\x00"
			set ::patch_cos::offset 0
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf							
		}
		# if "--patch-lv2-peek-poke-4x" enabled, do patch
		if {$::patch_cos::options(--patch-lv2-peek-poke-4x)} {
		
			log "Patching LV2 peek&poke for 4.xx CFW - part 1/3"				 
			set ::patch_cos::search     "\x63\xFF\x00\x3E\x4B\xFF\xFF\x0C"
			set ::patch_cos::replace    "\x3F\xE0\x80\x01\x3B\xE0\x00\x00"
			set ::patch_cos::offset 0
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf					
			
			log "Patching LV2 peek&poke for 4.xx CFW - part 2/3"	
			set ::patch_cos::search     "\x51\x7C\x7D\x1B\x78\x4B\xFF\xFF\x34\xF8\x21\xFF\x61\x7C\x08\x02\xA6"
			set ::patch_cos::replace    "\x48\x02\x62\xC4"
			set ::patch_cos::offset 9
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf				 					
			
			log "Patching LV2 peek&poke for 4.xx CFW - part 3/3"	
			set ::patch_cos::search     "\x41\x9E\xFF\xD4\x38\xDE"
			set ::patch_cos::replace    "\x60\x00\x00\x00"
			set ::patch_cos::offset 0
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf				 
		}
		# if "--patch-lv2-lv1-peek-poke-4x" enabled, do patch
		if {$::patch_cos::options(--patch-lv2-lv1-peek-poke-4x)} {
		
			log "Patching LV1 peek&poke call permission for LV2 into LV2"				 
			set ::patch_cos::search     "\x7C\x71\x43\xA6\x7C\x92\x43\xA6\x48\x00\x00\x00\x00\x00\x00\x00"
			append ::patch_cos::search  "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
			append ::patch_cos::search  "\x7C\x71\x43\xA6\x7C\x92\x43\xA6"
			set ::patch_cos::replace    "\xE8\x63\x00\x00\x4E\x80\x00\x20\xF8\x83\x00\x00\x4E\x80\x00\x20"
			append ::patch_cos::replace "\x7C\x08\x02\xA6\xF8\x01\x00\x10\x39\x60\x00\xB6\x44\x00\x00\x22"
			append ::patch_cos::replace "\x7C\x83\x23\x78\xE8\x01\x00\x10\x7C\x08\x03\xA6\x4E\x80\x00\x20"
			append ::patch_cos::replace "\x7C\x08\x02\xA6\xF8\x01\x00\x10\x39\x60\x00\xB7\x44\x00\x00\x22"
			append ::patch_cos::replace "\x38\x60\x00\x00\xE8\x01\x00\x10\x7C\x08\x03\xA6\x4E\x80\x00\x20"
			append ::patch_cos::replace "\x7C\x08\x02\xA6\xF8\x01\x00\x10\x7D\x4B\x53\x78\x44\x00\x00\x22"
			append ::patch_cos::replace "\xE8\x01\x00\x10\x7C\x08\x03\xA6\x4E\x80\x00\x20\x80\x00\x00\x00"
			append ::patch_cos::replace "\x00\x00\x17\x0C\x80\x00\x00\x00\x00\x00\x17\x14\x80\x00\x00\x00"
			append ::patch_cos::replace "\x00\x00\x17\x1C\x80\x00\x00\x00\x00\x00\x17\x3C\x80\x00\x00\x00"
			append ::patch_cos::replace "\x00\x00\x17\x5C"
			set ::patch_cos::offset 3060
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf					 					
			
			set ::patch_cos::search     "\x80\x00\x00\x00\x00\x2F\xEA\x40"
			set ::patch_cos::replace    "\x80\x00\x00\x00\x00\x00\x17\x78\x80\x00\x00\x00\x00\x00\x17\x80"
			append ::patch_cos::replace "\x80\x00\x00\x00\x00\x00\x17\x88\x80\x00\x00\x00\x00\x00\x17\x90"
			append ::patch_cos::replace "\x80\x00\x00\x00\x00\x00\x17\x98"
			set ::patch_cos::offset 16
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf					   
		}
		# if "-patch-lv2-npdrm-ecdsa-check" enabled, do patch
		if {$::patch_cos::options(--patch-lv2-npdrm-ecdsa-check)} {
		
			log "Patching NPDRM ECDSA check disabled"				 
			set ::patch_cos::search     "\x41\x9E\xFD\x68\x4B\xFF\xFD\x68\xE9\x22\x99\x90\x7C\x08\x02\xA6"
			set ::patch_cos::replace    "\x38\x60\x00\x00\x4E\x80\x00\x20"
			set ::patch_cos::offset 8
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf						
		}
		# if "--patch-lv2-SC36-4x" enabled, do patch
		if {$::patch_cos::options(--patch-lv2-SC36-4x)} {
		
			log "Patching LV2 with SysCall36 4.xx CFW"				 
			set ::patch_cos::search     "\x41\x9E\x00\xD8\x41\x9D\x00\xC0\x2F\x84\x00\x04\x40\x9C\x00\x48"
			set ::patch_cos::replace    "\x60\x00\x00\x00\x2F\x84\x00\x04\x48\x00\x00\x98"
			set ::patch_cos::offset 4
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf						
			
			set ::patch_cos::search     "\x41\x9E\x00\x70\xE8\x61\x01\x88"
			set ::patch_cos::replace    "\x60\x00\x00\x00"
			set ::patch_cos::offset 0
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf					 					
			
			set ::patch_cos::search     "\x4B\xFF\xF3\x31\x54\x63\x06\x3E\x2F\x83\x00\x00\x41\x9E\x00\x70"
			set ::patch_cos::replace    "\x60\x00\x00\x00"
			set ::patch_cos::offset 12
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf					 
		}
		# if "--patch-lv2-payload-hermes-4x" enabled, then patch
		if {$::patch_cos::options(--patch-lv2-payload-hermes-4x)} {
		
			log "Patching Hermes payload 4.xx into LV2"				 
			set ::patch_cos::search     "\x52\x52\x30\x20\x3A\x20\x30\x78"
			set ::patch_cos::replace    "\xF8\x21\xFF\x61\x7C\x08\x02\xA6\xFB\x81\x00\x80\xFB\xA1\x00\x88"
			append ::patch_cos::replace "\xFB\xE1\x00\x98\xFB\x41\x00\x70\xFB\x61\x00\x78\xF8\x01\x00\xB0"
			append ::patch_cos::replace "\x7C\x9C\x23\x78\x7C\x7D\x1B\x78\x3B\xE0\x00\x01\x7B\xFF\xF8\x06"
			append ::patch_cos::replace "\x67\xE4\x00\x2E\x60\x84\xA0\x0C\x38\xA0\x00\x02\x4B\xD6\x47\x71"
			append ::patch_cos::replace "\x28\x23\x00\x00\x40\x82\x00\x28\x67\xFF\x00\x2E\x63\xFF\xA0\x1C"
			append ::patch_cos::replace "\xE8\x7F\x00\x00\x28\x23\x00\x00\x41\x82\x00\x14\xE8\x7F\x00\x08"
			append ::patch_cos::replace "\x38\x9D\x00\x09\x4B\xD6\x46\xF5\xEB\xBF\x00\x00\x7F\xA3\xEB\x78"
			append ::patch_cos::replace "\x4B\xFD\x9C\xF4\x2F\x61\x70\x70\x5F\x68\x6F\x6D\x65\x00\x00\x00"
			append ::patch_cos::replace "\x00\x00\x00\x00\x80\x00\x00\x00\x00\x2E\xA0\x2C\x80\x00\x00\x00"
			append ::patch_cos::replace "\x00\x2E\xA0\x3A\x2F\x64\x65\x76\x5F\x66\x6C\x61\x73\x68\x2F\x6D"
			append ::patch_cos::replace "\x66\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
			set ::patch_cos::offset 0
			# base function to decrypt the "self" to "elf" for patching
			::modify_self_file $file ::patch_cos::patch_elf							
		}
	}
	### ------------------------------------- END:    Do_LV2_Patches{} --------------------------------------------- ###   
	
	
	# --------------------------  BEGIN:  Do_Misc_OS_Patches   --------------------------------------------------------- ### 
	#
	# This proc is for applying any patches any other OS specific files
	#
	#
	proc Do_Misc_OS_Patches {path} {
		
		debug "Applying OS Misc File patches...."
		
		# if "gameos-bootmem-size" patch enabled
		if {$::patch_cos::options(--patch-profile-gameos-bootmem-size)} {
		
			log "Patching GameOS profile to increase boot memory size"   				
			## set the filename here, and prepend the "path"				
			## set spp "default.spp"
			set self "default.spp"
			set file [file join $path $self]
			set ::SELF $self	
			
			set ::patch_cos::search    "\x50\x53\x33\x5f\x4c\x50\x41\x52\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
			append ::patch_cos::search "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x02\x50"
			append ::patch_cos::search "\x10\x70\x00\x00\x02\x00\x00\x01\x2f\x66\x6c\x68\x2f\x6f\x73\x2f\x6c\x76\x32\x5f"
			append ::patch_cos::search "\x6b\x65\x72\x6e\x65\x6c\x2e\x73\x65\x6c\x66\x00\x00\x00\x00\x00\x00\x00\x00\x00"
			set ::patch_cos::replace   "\x00\x00\x00\x00\x00\x00\x00\x1b"							
			set ::patch_cos::offset 304				
			# base function to decrypt the "spp" file for patching
			::modify_spp_file $file ::patch_cos::patch_elf			 				
		}
		# if patches for "disable search-in-game-disc" or "gameos-hdd-region-size"
		if {$::patch_cos::options(--patch-pup-search-in-game-disc) || !$::patch_cos::options(--patch-gameos-hdd-region-size) == "" } {
		
			##  set the filename here, and prepend the "path"
			set self "emer_init.self"
			set file [file join $path $self]
			set ::SELF $self
			
			# if "--patch-pup-search-in-game-disc" enabled, do patch
			if {$::patch_cos::options(--patch-pup-search-in-game-disc)} {
				
				log "Patching [file tail $elf] to disable searching for update packages in GAME disc"															         
				set ::patch_cos::search  "\x80\x01\x00\x74\x2f\x80\x00\x00\x40\x9e\x00\x14\x7f\xa3\xeb\x78"
				set ::patch_cos::replace "\x38\x00\x00\x01"				 
				set ::patch_cos::offset 0
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf			
			}											
			# determine if we have a user-defined HDD "size",
			# if we have one set, then do the HDD resize patch
			set size $::patch_cos::options(--patch-gameos-hdd-region-size)								
			if {$size != ""} {
			
				log "Patching [file tail $elf] to create GameOS HDD region of size $size of installed HDD"				 
				set ::patch_cos::search    "\xe9\x21\x00\xa0\x79\x4a\x00\x20\xe9\x1b\x00\x00\x38\x00\x00\x00"
				append ::patch_cos::search "\x7d\x26\x48\x50\x7d\x49\x03\xa6\x39\x40\x00\x00\x38\xe9\xff\xf8"
				set ::patch_cos::replace   "\x79\x27"
			 
				if {[string equal ${size} "1/eighth of drive"] == 1} {
					append ::patch_cos::replace "\xe8\xc2"
				} elseif {[string equal ${size} "1/quarter of drive"] == 1} {
					append ::patch_cos::replace "\xf0\x82"
				} elseif {[string equal ${size} "1/half of drive"] == 1} {
					append ::patch_cos::replace "\xf8\x42"
				} elseif {[string equal ${size} "22GB"] == 1} {
					append ::patch_cos::replace "\xfd\x40"
				} elseif {[string equal ${size} "10GB"] == 1} {
					append ::patch_cos::replace "\xfe\xc0"
				} elseif {[string equal ${size} "20GB"] == 1} {
					append ::patch_cos::replace "\xfd\x80"
				} elseif {[string equal ${size} "30GB"] == 1} {
					append ::patch_cos::replace "\xfc\x40"
				} elseif {[string equal ${size} "40GB"] == 1} {
					append ::patch_cos::replace "\xfb\x00"
				} elseif {[string equal ${size} "50GB"] == 1} {
					append ::patch_cos::replace "\xf9\xc0"
				} elseif {[string equal ${size} "60GB"] == 1} {
					append ::patch_cos::replace "\xf8\x80"
				} elseif {[string equal ${size} "70GB"] == 1} {
					append ::patch_cos::replace "\xf7\x40"
				} elseif {[string equal ${size} "80GB"] == 1} {
					append ::patch_cos::replace "\xf6\x00"
				} elseif {[string equal ${size} "90GB"] == 1} {
					append ::patch_cos::replace "\xf4\xc0"
				} elseif {[string equal ${size} "100GB"] == 1} {
					append ::patch_cos::replace "\xf3\x80"
				} elseif {[string equal ${size} "110GB"] == 1} {
					append ::patch_cos::replace "\xf2\x40"
				} elseif {[string equal ${size} "120GB"] == 1} {
					append ::patch_cos::replace "\xf1\x00"
				} elseif {[string equal ${size} "130GB"] == 1} {
					append ::patch_cos::replace "\xef\xc0"
				} elseif {[string equal ${size} "140GB"] == 1} {
					append ::patch_cos::replace "\xee\x80"
				} elseif {[string equal ${size} "150GB"] == 1} {
					append ::patch_cos::replace "\xed\x40"
				} elseif {[string equal ${size} "160GB"] == 1} {
					append ::patch_cos::replace "\xec\x00"
				} elseif {[string equal ${size} "170GB"] == 1} {
					append ::patch_cos::replace "\xea\xc0"
				} elseif {[string equal ${size} "180GB"] == 1} {
					append ::patch_cos::replace "\xe9\x80"
				} elseif {[string equal ${size} "190GB"] == 1} {
					append ::patch_cos::replace "\xe8\x40"
				} elseif {[string equal ${size} "200GB"] == 1} {
					append ::patch_cos::replace "\xe7\x00"
				} elseif {[string equal ${size} "210GB"] == 1} {
					append ::patch_cos::replace "\xe5\xc0"
				} elseif {[string equal ${size} "220GB"] == 1} {
					append ::patch_cos::replace "\xe4\x80"
				} elseif {[string equal ${size} "230GB"] == 1} {
					append ::patch_cos::replace "\xe3\x40"
				} elseif {[string equal ${size} "240GB"] == 1} {
					append ::patch_cos::replace "\xe2\x00"
				} elseif {[string equal ${size} "250GB"] == 1} {
					append ::patch_cos::replace "\xe0\xc0"
				} elseif {[string equal ${size} "260GB"] == 1} {
					append ::patch_cos::replace "\xdf\x80"
				} elseif {[string equal ${size} "270GB"] == 1} {
					append ::patch_cos::replace "\xde\x40"
				} elseif {[string equal ${size} "280GB"] == 1} {
					append ::patch_cos::replace "\xdd\x00"
				} elseif {[string equal ${size} "290GB"] == 1} {
					append ::patch_cos::replace "\xdb\xc0"
				} elseif {[string equal ${size} "300GB"] == 1} {
					append ::patch_cos::replace "\xda\x80"
				} elseif {[string equal ${size} "310GB"] == 1} {
					append ::patch_cos::replace "\xd9\x40"
				} elseif {[string equal ${size} "320GB"] == 1} {
					append ::patch_cos::replace "\xd8\x00"
				} elseif {[string equal ${size} "330GB"] == 1} {
					append ::patch_cos::replace "\xd6\xc0"
				} elseif {[string equal ${size} "340GB"] == 1} {
					append ::patch_cos::replace "\xd5\x80"
				} elseif {[string equal ${size} "350GB"] == 1} {
					append ::patch_cos::replace "\xd4\x40"
				} elseif {[string equal ${size} "360GB"] == 1} {
					append ::patch_cos::replace "\xd3\x00"
				} elseif {[string equal ${size} "370GB"] == 1} {
					append ::patch_cos::replace "\xd1\xc0"
				} elseif {[string equal ${size} "380GB"] == 1} {
					append ::patch_cos::replace "\xd0\x80"
				} elseif {[string equal ${size} "390GB"] == 1} {
					append ::patch_cos::replace "\xcf\x40"
				} elseif {[string equal ${size} "400GB"] == 1} {
					append ::patch_cos::replace "\xce\x00"
				} elseif {[string equal ${size} "410GB"] == 1} {
					append ::patch_cos::replace "\xcc\xc0"
				} elseif {[string equal ${size} "420GB"] == 1} {
					append ::patch_cos::replace "\xcb\x80"
				} elseif {[string equal ${size} "430GB"] == 1} {
					append ::patch_cos::replace "\xca\x40"
				} elseif {[string equal ${size} "440GB"] == 1} {
					append ::patch_cos::replace "\xc9\x00"
				} elseif {[string equal ${size} "450GB"] == 1} {
					append ::patch_cos::replace "\xc7\xc0"
				} elseif {[string equal ${size} "460GB"] == 1} {
					append ::patch_cos::replace "\xc6\x80"
				} elseif {[string equal ${size} "470GB"] == 1} {
					append ::patch_cos::replace "\xc5\x40"
				} elseif {[string equal ${size} "480GB"] == 1} {
					append ::patch_cos::replace "\xc4\x00"
				} elseif {[string equal ${size} "490GB"] == 1} {
					append ::patch_cos::replace "\xc2\xc0"
				} elseif {[string equal ${size} "500GB"] == 1} {
					append ::patch_cos::replace "\xc1\x80"
				} elseif {[string equal ${size} "510GB"] == 1} {
					append ::patch_cos::replace "\xc0\x40"
				} elseif {[string equal ${size} "520GB"] == 1} {
					append ::patch_cos::replace "\xbf\x00"
				} elseif {[string equal ${size} "530GB"] == 1} {
					append ::patch_cos::replace "\xbd\xc0"
				} elseif {[string equal ${size} "540GB"] == 1} {
					append ::patch_cos::replace "\xbc\x80"
				} elseif {[string equal ${size} "550GB"] == 1} {
					append ::patch_cos::replace "\xbb\x40"
				} elseif {[string equal ${size} "560GB"] == 1} {
					append ::patch_cos::replace "\xba\x00"
				} elseif {[string equal ${size} "570GB"] == 1} {
					append ::patch_cos::replace "\xb8\xc0"
				} elseif {[string equal ${size} "580GB"] == 1} {
					append ::patch_cos::replace "\xb7\x80"
				} elseif {[string equal ${size} "590GB"] == 1} {
					append ::patch_cos::replace "\xb6\x40"
				} elseif {[string equal ${size} "600GB"] == 1} {
					append ::patch_cos::replace "\xb5\x00"
				} elseif {[string equal ${size} "610GB"] == 1} {
					append ::patch_cos::replace "\xb3\xc0"
				} elseif {[string equal ${size} "620GB"] == 1} {
					append ::patch_cos::replace "\xb2\x80"
				} elseif {[string equal ${size} "630GB"] == 1} {
					append ::patch_cos::replace "\xb1\x40"
				} elseif {[string equal ${size} "640GB"] == 1} {
					append ::patch_cos::replace "\xb0\x00"
				} elseif {[string equal ${size} "650GB"] == 1} {
					append ::patch_cos::replace "\xae\xc0"
				} elseif {[string equal ${size} "660GB"] == 1} {
					append ::patch_cos::replace "\xad\x80"
				} elseif {[string equal ${size} "670GB"] == 1} {
					append ::patch_cos::replace "\xac\x40"
				} elseif {[string equal ${size} "680GB"] == 1} {
					append ::patch_cos::replace "\xab\x00"
				} elseif {[string equal ${size} "690GB"] == 1} {
					append ::patch_cos::replace "\xa9\xc0"
				} elseif {[string equal ${size} "700GB"] == 1} {
					append ::patch_cos::replace "\xa8\x80"
				} elseif {[string equal ${size} "710GB"] == 1} {
					append ::patch_cos::replace "\xa7\x40"
				} elseif {[string equal ${size} "720GB"] == 1} {
					append ::patch_cos::replace "\xa6\x00"
				} elseif {[string equal ${size} "730GB"] == 1} {
					append ::patch_cos::replace "\xa4\xc0"
				} elseif {[string equal ${size} "740GB"] == 1} {
					append ::patch_cos::replace "\xa3\x80"
				} elseif {[string equal ${size} "750GB"] == 1} {
					append ::patch_cos::replace "\xa2\x40"
				} elseif {[string equal ${size} "760GB"] == 1} {
					append ::patch_cos::replace "\xa1\x00"
				} elseif {[string equal ${size} "770GB"] == 1} {
					append ::patch_cos::replace "\x9f\xc0"
				} elseif {[string equal ${size} "780GB"] == 1} {
					append ::patch_cos::replace "\x9e\x80"
				} elseif {[string equal ${size} "790GB"] == 1} {
					append ::patch_cos::replace "\x9d\x40"
				} elseif {[string equal ${size} "800GB"] == 1} {
					append ::patch_cos::replace "\x9c\x00"
				} elseif {[string equal ${size} "810GB"] == 1} {
					append ::patch_cos::replace "\x9a\xc0"
				} elseif {[string equal ${size} "820GB"] == 1} {
					append ::patch_cos::replace "\x99\x80"
				} elseif {[string equal ${size} "830GB"] == 1} {
					append ::patch_cos::replace "\x98\x40"
				} elseif {[string equal ${size} "840GB"] == 1} {
					append ::patch_cos::replace "\x97\x00"
				} elseif {[string equal ${size} "850GB"] == 1} {
					append ::patch_cos::replace "\x95\xc0"
				} elseif {[string equal ${size} "860GB"] == 1} {
					append ::patch_cos::replace "\x94\x80"
				} elseif {[string equal ${size} "870GB"] == 1} {
					append ::patch_cos::replace "\x93\x40"
				} elseif {[string equal ${size} "880GB"] == 1} {
					append ::patch_cos::replace "\x92\x00"
				} elseif {[string equal ${size} "890GB"] == 1} {
					append ::patch_cos::replace "\x90\xc0"
				} elseif {[string equal ${size} "900GB"] == 1} {
					append ::patch_cos::replace "\x8f\x80"
				} elseif {[string equal ${size} "910GB"] == 1} {
					append ::patch_cos::replace "\x8e\x40"
				} elseif {[string equal ${size} "920GB"] == 1} {
					append ::patch_cos::replace "\x8d\x00"
				} elseif {[string equal ${size} "930GB"] == 1} {
					append ::patch_cos::replace "\x8b\xc0"
				} elseif {[string equal ${size} "940GB"] == 1} {
					append ::patch_cos::replace "\x8a\x80"
				} elseif {[string equal ${size} "950GB"] == 1} {
					append ::patch_cos::replace "\x89\x40"
				} elseif {[string equal ${size} "960GB"] == 1} {
					append ::patch_cos::replace "\x88\x00"
				} elseif {[string equal ${size} "970GB"] == 1} {
					append ::patch_cos::replace "\x86\xc0"
				} elseif {[string equal ${size} "980GB"] == 1} {
					append ::patch_cos::replace "\x85\x80"
				} elseif {[string equal ${size} "990GB"] == 1} {
					append ::patch_cos::replace "\x84\x40"
				} elseif {[string equal ${size} "1000GB"] == 1} {
					append ::patch_cos::replace "\x83\x00"
				}
			 
				set ::patch_cos::offset 28
				# base function to decrypt the "self" to "elf" for patching
				::modify_self_file $file ::patch_cos::patch_elf								
			}											 			
		}
	}
	### ------------------------------------- END:    Do_Misc_OS_Patches{} --------------------------------------------- ###   
	
	
	# ---------------------------BEGIN:  patch_elf   --------------------------------------------------
	#
	# this is the proc for calling the ps3mfw_base::patch_elf{} routine
	#
	proc patch_elf {elf} {               
        catch_die {::patch_elf $elf $::patch_cos::search $::patch_cos::offset $::patch_cos::replace} \
        "Unable to patch self [file tail $elf]"
    }
	# --------------------------------------------------------------------------------------
	
	
	proc check_task { } {
	    set ida [::get_selected_tasks]
        foreach task  {$ida} {
            if {$task == "patch_lv1"} {
                return "false"
            } else {
			    return "true"
		    }
		}
    }
}
