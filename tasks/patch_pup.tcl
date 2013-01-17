#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#
    
# Priority: 100
# Description: Patch PUP

# Option --pup-build: PUP build number
# Option --version-string: If set, overrides the entire PUP version string
# Option --version-prefix: Prefix to add to the PUP version string
# Option --version-suffix: Suffix to add to the PUP version string
# Option --version-suffix-manuel: Or change suffix above to nothing and enter one manually
# Option --patch-shop-2-retail: Patch Shop PUP to make Shop console Retail
# Option --patch-retail-2-shop: Patch Retail PUP to make Retail console Shop
# Option --remove-bd-revoke: Remove BdpRevoke to updat console with broken Drive (THIS WILL REMOVE BLU-RAY DRIVE FIRMWARE)
# Option --remove-bd-firmware: Remove BD firmware to updat console with broken Drive (THIS WILL REMOVE BLU-RAY DRIVE FIRMWARE)
# Option --remove-bt-firmware: Remove Bluetooth firmware to updat console with broken BT (THIS WILL REMOVE BLUETOOTH FIRMWARE)

# Type --pup-build: string
# Type --version-string: string
# Type --version-prefix: string
# Type --version-suffix: combobox { {} {-PS3MFW} {-Promotional-to-Retail} {-Retail-to-Promotional} {-OtherOS++} {-AC1D} }
# Type --version-suffix-manuel: string
# Type --patch-shop-2-retail: boolean
# Type --patch-retail-2-shop: boolean
# Type --remove-bd-revoke: boolean
# Type --remove-bd-firmware: boolean
# Type --remove-bt-firmware: boolean
    
namespace eval ::patch_pup {

    array set ::patch_pup::options {
      --pup-build ""
      --version-string ""
      --version-prefix ""
      --version-suffix {-PS3MFW}
      --version-suffix-manuel ""
      --patch-shop-2-retail false
      --patch-retail-2-shop false
      --remove-bd-revoke false
      --remove-bd-firmware false
      --remove-bt-firmware false
    }

    proc main {} {
        variable options
        
        if {$::patch_pup::options(--patch-shop-2-retail)} {
            debug "Patching [file tail $::CUSTOM_UPDATE_FLAGS_TXT]"
            set fd [open $::CUSTOM_UPDATE_FLAGS_TXT w]
            puts -nonewline $fd "0000"
            close $fd
          
            debug "Deleting [file tail $::CUSTOM_PROMO_FLAGS_TXT]"
            ::delete_promo
        }
        
        if {$::patch_pup::options(--patch-retail-2-shop)} {
            debug "Patching [file tail $::CUSTOM_PROMO_FLAGS_TXT]"
            set fd [open $::CUSTOM_PROMO_FLAGS_TXT w]
            puts -nonewline $fd "0"
            close $fd
          
            debug "Patching [file tail $::CUSTOM_UPDATE_FLAGS_TXT]"
            set fd [open $::CUSTOM_UPDATE_FLAGS_TXT w]
            puts -nonewline $fd "0300"
            close $fd
        }
      
        if {$::patch_pup::options(--pup-build) != ""} {
            log "Changing PUP version Build"
            ::set_pup_build $::patch_pup::options(--pup-build)
        } else {
            ::set_pup_build [::get_pup_build]
        }
     
        if {$::patch_pup::options(--version-string) != ""} {
            log "Changing PUP version.txt file"
            ::modify_pup_version_file $options(--version-string) "" 1
        } elseif {$::patch_pup::options(--version-suffix) != 0} {
            ::modify_pup_version_file $::patch_pup::options(--version-prefix) $::patch_pup::options(--version-suffix)
        } else {
            ::modify_pup_version_file $::patch_pup::options(--version-prefix) $::patch_pup::options(--version-suffix-manuel)
        }
        
		if {$::patch_pup::options(--remove-bd-revoke) || $::patch_pup::options(--remove-bd-firmware) || $::patch_pup::options(--remove-bt-firmware)} {
            ::modify_upl_file ::patch_pup::callback
	    }
    }
    
    proc callback { file } {
        log "Modifying XML file [file tail ${file}]"
     
        if {[package provide Tk] != "" } {
           tk_messageBox -default ok -message "Removing blu-ray drive / bluetooth firmware packages press ok to continue" -icon warning
        }
     
        set xml [::xml::LoadFile $file]
     
        if {$::patch_pup::options(--remove-bd-revoke)} {
          set xml [::remove_pkg_from_upl_xml $xml "BdpRevoke" "blu-ray drive revoke"]
        }
     
        if {$::patch_pup::options(--remove-bd-firmware)} {
          set xml [::remove_pkgs_from_upl_xml $xml "BD" "blu-ray drive firmware"]
        }
        
        if {$::patch_pup::options(--remove-bt-firmware)} {
          set xml [::remove_pkgs_from_upl_xml $xml "BT" "bluetooth firmware"]
        }
     
        ::xml::SaveToFile $xml $file
    }
}

