#!/usr/bin/tclsh
#
# ps3mfw -- PS3 MFW creator
#
# Copyright (C) Anonymous Developers (Code Monkeys)
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 3, as published by the Free Software Foundation.
#
    
# Priority: 600
# Description: Patch XMB
     
# Option --add-install-pkg: Add the standart Install Package Files Segment to the HomeBrew Category in XMB
# Option --patch-act-pkg: Patch the standart  '*Install Packeg Files'  function back in to the XMB (4.30+)
# Option --add-pkg-mgr: Add MFW PKG Manager Segment to the HomeBrew Category in XMB
# Option --add-hb-seg: Add MFW HomeBrew Segment to the HomeBrew Category in XMB
# Option --add-emu-seg: Add MFW Emulator Segment to the HomeBrew Category in XMB
# Option --homebrew-cat: Specify new HomeBrew category manually (Do not use with options above!!)
# Option --patch-package-files: Add "Install Package Files" icon to the XMB Game Category
# Option --patch-app-home: Add "/app_home" icon to the XMB Game Category
# Option --patch-ren-apphome: Rename /app_home/PS3_GAME/ to Discless
# Option --patch-alpha-sort: Alphabetical sort Order for Games in the XMB
# Option --patch-rape-sfo: Rape the SFO Param's X0 (NeoGeo) and X4 (PCEngine) to use with the Homebrew category and custome segments
# Option --fix-typo-sysconf-Italian: Fix a typo in the Italian localization of the sysconf plugin
# Option --tv-cat: Show TV category in xmb no matter if your country support it.

# Type --add-install-pkg: boolean
# Type --patch-act-pkg: boolean
# Type --add-pkg-mgr: boolean
# Type --add-hb-seg: boolean
# Type --add-emu-seg: boolean
# Type --homebrew-cat: combobox {{ } {Users} {Photo} {Music} {Video} {TV} {Game} {Network} {PlayStation® Network} {Friends}}
# Type --patch-package-files: boolean
# Type --patch-app-home: boolean
# Type --patch-ren-apphome: boolean
# Type --patch-alpha-sort: boolean
# Type --patch-rape-sfo: boolean
# Type --fix-typo-sysconf-Italian: boolean
# Type --tv-cat: boolean

namespace eval patch_xmb {
    
    array set ::patch_xmb::options {
        --add-install-pkg true
		--patch-act-pkg true
        --add-pkg-mgr true
        --add-hb-seg true
        --add-emu-seg true
        --homebrew-cat "Category to replace"
        --patch-package-files false
        --patch-app-home true
        --patch-ren-apphome true
        --patch-alpha-sort true
        --patch-rape-sfo true
        --fix-typo-sysconf-Italian false
        --tv-cat false
    }
    
    proc main {} {
        variable options
        set pointer_xmb 0
        set embd $::customize_firmware::options(--customize-embended-app)
        set CATEGORY_TV_XML [file join dev_flash vsh resource explore xmb category_tv.xml]
        set XMB_PLUGIN [file join dev_flash vsh module xmb_plugin.sprx]
        set SYSCONF_PLUGIN_RCO [file join dev_flash vsh resource sysconf_plugin.rco]
        set EXPLORE_PLUGIN_FULL_RCO [file join dev_flash vsh resource explore_plugin_full.rco]
		set XMB_INGAME_RCO [file join dev_flash vsh resource xmb_ingame.rco]
	    set REGISTORY_XML [file join dev_flash vsh resource explore xmb registory.xml]
		set NET_CAT_XML [file join dev_flash vsh resource xmb category_network.xml]
		set CATEGORY_GAME_TOOL2_XML [file join dev_flash vsh resource explore xmb category_game_tool2.xml]
		set CATEGORY_GAME_XML [file join dev_flash vsh resource explore xmb category_game.xml]
		set PSN_CAT_XML [file join dev_flash vsh resource xmb category_psn.xml]
		set TEMPLAT_MFW_XML [file join ${::CUSTOM_TEMPLAT_DIR} mfw_templat.xml]
		set ACTIVATE_IPF {xmb_ingame.rco explore_plugin_full.rco}
		set rapeo "cond=An+Game:Game.category"
		set rapen "cond=An+Game:Game.category X4+An+Game:Game.category X0+An+Game:Game.category"
		
		if {$::patch_xmb::options(--add-install-pkg) || $::patch_xmb::options(--add-pkg-mgr) || $::patch_xmb::options(--add-hb-seg) || $::patch_xmb::options(--add-emu-seg)} {
		    ::modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::patch_xmb::callback_homebrew
		    ::modify_rco_file $XMB_INGAME_RCO ::patch_xmb::callback_homebrew
		    set pointer_xmb 1
		    ::modify_devflash_file $NET_CAT_XML ::patch_xmb::patch_xml
		} else {
			if {$::patch_xmb::options(--patch-ren-apphome)} {
		        ::modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::patch_xmb::callback_discless
		        :modify_rco_file $XMB_INGAME_RCO ::patch_xmb::callback_discless
		    }
		}
		
		if {$::patch_xmb::options(--patch-act-pkg)} {
		    modify_devflash_files [file join dev_flash vsh module] $ACTIVATE_IPF ::patch_xmb::patch_self
		}
       
		if {$::patch_xmb::options(--patch-app-home)  || $::patch_xmb::options(--patch-package-files) || $::patch_xmb::options(--patch-alpha-sort) || $::patch_xmb::options(--patch-rape-sfo) || $::patch_xmb::options(--homebrew-cat) != ""} {
		    ::modify_devflash_file $CATEGORY_GAME_XML ::patch_xmb::patch_xml	    
		}
        
        if {$::patch_xmb::options(--homebrew-cat) != "TV" && $::patch_xmb::options(--tv-cat)} {
            ::modify_devflash_file $XMB_PLUGIN ::patch_xmb::patch_self
        }
        
        if {$::patch_xmb::options(--fix-typo-sysconf-Italian) && $::customize_firmware::options(--customize-fw-version) == ""} {
            ::modify_rco_file $SYSCONF_PLUGIN_RCO ::patch_xmb::callback_fix_typo_sysconf_Italian
        }
    }
    
    proc patch_xml { } {
        if {$pointer_xmb == 1} {
            ${::TEMPLAT_MFW_XML} ::patch_xmb::find_nodes
            $CATEGORY_GAME_TOOL2_XML ::patch_xmb::find_nodes1
            $NET_CAT_XML ::patch_xmb::read_cat
            $NET_CAT_XML ::patch_xmb::inject_node
            $PSN_CAT_XML ::patch_xmb::inject_cat
        }
        
        if {$::patch_xmb::options(--patch-app-home)  || $::patch_xmb::options(--patch-package-files) } {
            if {$pointer_xmb == 0} {
                $CATEGORY_GAME_TOOL2_XML ::patch_xmb::find_nodes1
            }
		    ::patch_xmb::inject_nodes2 $CATEGORY_GAME_XML
		}
	  
		if {$::patch_xmb::options(--patch-alpha-sort)} {
            $REGISTORY_XML ::patch_xmb::alpha_sort
        }
        
        if {$::patch_xmb::options(--patch-rape-sfo) && !$::patch_xmb::options(--patch-alpha-sort)} {
            $REGISTORY_XML ::patch_xmb::rape_sfo
        }
        
        if {$::patch_xmb::options(--homebrew-cat) != ""} {
            if {$::patch_xmb::options(--homebrew-cat) == "Users"} {
		       set CATEGORY_XML [file join dev_flash vsh resource explore xmb category_user.xml]
		    }
		   
		    if {$::patch_xmb::options(--homebrew-cat) == "Photo"} {
		       set CATEGORY_XML [file join dev_flash vsh resource explore xmb category_photo.xml]
		    }
         
		    if {$::patch_xmb::options(--homebrew-cat) == "Music"} {
		       set CATEGORY_XML [file join dev_flash vsh resource explore xmb category_music.xml]
		    }
		  
		    if {$::patch_xmb::options(--homebrew-cat) == "Video"} {
		       set CATEGORY_XML [file join dev_flash vsh resource explore xmb category_video.xml]
		    }
		 
		    if {$::patch_xmb::options(--homebrew-cat) == "TV"} {
		       modify_devflash_file $XMB_PLUGIN ::patch_xmb::patch_self
		       $CATEGORY_TV_XML ::patch_xmb::find_nodes2
		       set CATEGORY_XML [file join dev_flash vsh resource explore xmb category_tv.xml]
		    }
		  
		    if {$::patch_xmb::options(--homebrew-cat) == "Game"} {
		       set CATEGORY_XML [file join dev_flash vsh resource explore xmb category_game.xml]
		    }
		 
		    if {$::patch_xmb::options(--homebrew-cat) == "Network"} {
		       set CATEGORY_XML [file join dev_flash vsh resource explore xmb category_network.xml]
		    }
		 
		    if {$::patch_xmb::options(--homebrew-cat) == "PlayStation® Network"} {
		       set CATEGORY_XML [file join dev_flash vsh resource explore xmb category_psn.xml]
		    }
		 
		    if {$::patch_xmb::options(--homebrew-cat) == "Friends"} {
		       set CATEGORY_XML [file join dev_flash vsh resource explore xmb category_friend.xml]
		    }		
            $CATEGORY_GAME_TOOL2_XML ::patch_xmb::find_nodes2
            $CATEGORY_XML ::patch_xmb::inject_nodes2
		    modify_rco_file $EXPLORE_PLUGIN_FULL_RCO ::patch_xmb::callback_manuell
		    modify_rco_file $XMB_INGAME_RCO ::patch_xmb::callback_manuell
        }
        
        unset ::query_package_files
        unset ::view_package_files
        unset ::view_packages
        unset ::query_gamedebug
        unset ::view_gamedebug
    }
    
    proc patch_self {self} {
        log "Patching [file tail $self]"
        ::modify_self_file2 $self ::patch_xmb::patch_elf
    }

    proc patch_elf {elf} {
        log "Patching [file tail $elf] to add tv category"
       
        set search  "\x64\x65\x76\x5f\x68\x64\x64\x30\x2f\x67\x61\x6d\x65\x2f\x42\x43\x45\x53\x30\x30\x32\x37\x35"
        set replace "\x64\x65\x76\x5f\x66\x6c\x61\x73\x68\x2f\x64\x61\x74\x61\x2f\x63\x65\x72\x74\x00\x00\x00\x00"
       
        catch_die {::patch_elf $elf $search 0 $replace} \
        "Unable to patch self [file tail $elf]"
		
		if {$::patch_xmb::options(--patch-act-pkg)} {
		    log "Patching [file tail $elf] to add Install Package Files back to the XMB"
         
            set search  "\xF8\x21\xFE\xD1\x7C\x08\x02\xA6\xFB\x81\x01\x10\x3B\x81\x00\x70"
            set replace "\x38\x60\x00\x01\x4E\x80\x00\x20"
         
            catch_die {::patch_elf $elf $search 0 $replace} "Unable to patch self [file tail $elf]"
		}
    }
    
    proc alpha_sort {path args} {
        log "Patching Alphabetical Sort for Games in file [file tail $path]"
        sed_in_place [file join $path] -Game:Common.stat.rating-Game:Common.timeCreated+Game:Common.titleForSort-Game:Game.category -Game:Common.stat.rating-Game:Common.title+Game:Common.titleForSort-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating+Game:Common.timeCreated+Game:Common.titleForSort-Game:Game.category -Game:Common.stat.rating+Game:Common.title+Game:Common.titleForSort-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating-Game:Common.stat.timeLastUsed+Game:Common.titleForSort-Game:Common.timeCreated-Game:Game.category -Game:Common.stat.rating-Game:Common.stat.timeLastUsed+Game:Common.titleForSort-Game:Common.title-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating+Game:Common.titleForSort-Game:Common.timeCreated-Game:Game.category -Game:Common.stat.rating+Game:Common.titleForSort-Game:Common.title-Game:Game.category
        sed_in_place [file join $path] -Game:Common.stat.rating+Game:Game.gameCategory-Game:Common.timeCreated+Game:Common.titleForSort -Game:Common.stat.rating+Game:Game.gameCategory-Game:Common.title+Game:Common.titleForSort
        
        if {$::patch_xmb::options(--patch-rape-sfo)} {
            ::patch_xmb::rape_sfo
        }
    }
    
    proc rape_sfo {path args} {
        log "Patching Rape SFO in file [file tail $path]"
        sed_in_place [file join $path] $rapeo $rapen       
    }

    proc callback_fix_typo_sysconf_Italian {path args} {
        log "Patching Italian.xml into [file tail $path]"
        sed_in_place [file join $path Italian.xml] backuip backup
    }
    
    proc callback_homebrew {path args} {		
        log "Patching English.xml into [file tail $path]"
        sed_in_place [file join $path English.xml] Network Homebrew
        
        log "Patching German.xml into [file tail $path]"
        sed_in_place [file join $path German.xml] Network Homebrew
        
        log "Patching Korean.xml into [file tail $path]"
        sed_in_place [file join $path Korean.xml] Network Homebrew
        
        log "Patching Russian.xml into [file tail $path]"
        sed_in_place [file join $path Russian.xml] Network Homebrew
        
        log "Patching Swedish.xml into [file tail $path]"
        sed_in_place [file join $path Swedish.xml] Network Homebrew
        
        log "Patching Spanish.xml into [file tail $path]"
        sed_in_place [file join $path Spanish.xml] Network Homebrew
        
        log "Patching Portugese.xml into [file tail $path]"
        sed_in_place [file join $path Portugese.xml] Network Homebrew
        
        log "Patching Norwegian.xml into [file tail $path]"
        sed_in_place [file join $path Norwegian.xml] Network Homebrew
        
        log "Patching Japanese.xml into [file tail $path]"
        sed_in_place [file join $path Japanese.xml] Network Homebrew
        
        log "Patching Italian.xml into [file tail $path]"
        sed_in_place [file join $path Italian.xml] Network Homebrew
        
        log "Patching French.xml into [file tail $path]"
        sed_in_place [file join $path French.xml] Network Homebrew
        
        log "Patching Finnish.xml into [file tail $path]"
        sed_in_place [file join $path Finnish.xml] Network Homebrew
        
        log "Patching Dutch.xml into [file tail $path]"
        sed_in_place [file join $path Dutch.xml] Network Homebrew
        
        log "Patching Danish.xml into [file tail $path]"
        sed_in_place [file join $path Danish.xml] Network Homebrew
        
        log "Patching ChineseTrad.xml into [file tail $path]"
        sed_in_place [file join $path ChineseTrad.xml] Network Homebrew
        
        log "Patching ChineseSimpl.xml into [file tail $path]"
        sed_in_place [file join $path ChineseSimpl.xml] Network Homebrew
        
        if {$::patch_xmb::options(--patch-ren-apphome)} { 
            ::patch_xmb::callback_discless
        }
    }
    
    proc callback_discless {path args} {
        log "Patching English.xml into [file tail $path]"
        sed_in_place [file join $path English.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching German.xml into [file tail $path]"
        sed_in_place [file join $path German.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Korean.xml into [file tail $path]"
        sed_in_place [file join $path Korean.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Russian.xml into [file tail $path]"
        sed_in_place [file join $path Russian.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Swedish.xml into [file tail $path]"
        sed_in_place [file join $path Swedish.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Spanish.xml into [file tail $path]"
        sed_in_place [file join $path Spanish.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Portugese.xml into [file tail $path]"
        sed_in_place [file join $path Portugese.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Norwegian.xml into [file tail $path]"
        sed_in_place [file join $path Norwegian.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Japanese.xml into [file tail $path]"
        sed_in_place [file join $path Japanese.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Italian.xml into [file tail $path]"
         sed_in_place [file join $path Italian.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching French.xml into [file tail $path]"
        sed_in_place [file join $path French.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Finnish.xml into [file tail $path]"
        sed_in_place [file join $path Finnish.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Dutch.xml into [file tail $path]"
        sed_in_place [file join $path Dutch.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching Danish.xml into [file tail $path]"
        sed_in_place [file join $path Danish.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching ChineseTrad.xml into [file tail $path]"
        sed_in_place [file join $path ChineseTrad.xml] /app_home/PS3_GAME/ Discless
        
        log "Patching ChineseSimpl.xml into [file tail $path]"
        sed_in_place [file join $path ChineseSimpl.xml] /app_home/PS3_GAME/ Discless
    }
    
    proc callback_manuell { file } {
        log "Patching English.xml into [file tail $path]"
        sed_in_place [file join $path English.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching German.xml into [file tail $path]"
        sed_in_place [file join $path German.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching Korean.xml into [file tail $path]"
        sed_in_place [file join $path Korean.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching Russian.xml into [file tail $path]"
        sed_in_place [file join $path Russian.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching Swedish.xml into [file tail $path]"
        sed_in_place [file join $path Swedish.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching Spanish.xml into [file tail $path]"
        sed_in_place [file join $path Spanish.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching Portugese.xml into [file tail $path]"
        sed_in_place [file join $path Portugese.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching Norwegian.xml into [file tail $path]"
        sed_in_place [file join $path Norwegian.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching Japanese.xml into [file tail $path]"
        sed_in_place [file join $path Japanese.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching Italian.xml into [file tail $path]"
        sed_in_place [file join $path Italian.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching French.xml into [file tail $path]"
        sed_in_place [file join $path French.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching Finnish.xml into [file tail $path]"
        sed_in_place [file join $path Finnish.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching Dutch.xml into [file tail $path]"
        sed_in_place [file join $path Dutch.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching Danish.xml into [file tail $path]"
        sed_in_place [file join $path Danish.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching ChineseTrad.xml into [file tail $path]"
        sed_in_place [file join $path ChineseTrad.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
        
        log "Patching ChineseSimpl.xml into [file tail $path]"
        sed_in_place [file join $path ChineseSimpl.xml] $::patch_xmb::options(--homebrew-cat) Homebrew
    }
    
    proc change_welcome_string { path args } {
        log "Changing Welcome string to Hombrew segment"       
        sed_in_place [file join $path category_networkt.xml] key="seg_browser"> key="seg_hbrew">
    }
    
    proc clean_net { file } {
        log "Modifying XML file [file tail $file]"
        log "Cleaning Homebrew category"
     
        set xml [::remove_node_from_xmb_xml $xml "seg_browser" "Internet Browser"]
        set xml [::remove_node_from_xmb_xml $xml "seg_folding_at_home" "Life with PlayStation "]
        set xml [::remove_node_from_xmb_xml $xml "seg_kensaku" "Internet Search"]
        set xml [::remove_node_from_xmb_xml $xml "seg_manual" "Online Instruction Manuals"]
        set xml [::remove_node_from_xmb_xml $xml "seg_premo" "Remote Play"]
        set xml [::remove_node_from_xmb_xml $xml "seg_dlctrl" "Download Controle"]
		
		::xml::SaveToFile $xml $file
    }
    
    proc read_cat { file } {
        log "Parsing XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
        
        set ::query_manual [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_manual"]
        set ::view_seg_manual [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_manual"]
        
        if {$::query_manual == "" || $::view_manual == "" } {
            die "Could not parse $file"
        }
        
        set ::query_premo [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_premo"]
        set ::view_premo [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_premo"]
        
        if {$::query_premo == "" || $::view_premo == "" } {
            die "Could not parse $file"
        }
        
        set ::query_browser [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_browser"]
        set ::view_browser [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_browser"]
        
        if {$::query_browser == "" || $::view_browser == "" } {
            die "Could not parse $file"
        }
        
        set ::query_kensaku [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_kensaku"]
        set ::view_kensaku [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_kensaku"]
        
        if {$::query_kensaku == "" || $::view_kensaku == "" } {
            die "Could not parse $file"
        }
        
        set ::query_dlctrl [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_dlctrl"]
        
        if {$::query_dlctrl == "" } {
            die "Could not parse $file"
        }
        
        ::patch_xmb::inject_nodes
        
    }
    
    proc inject_cat { file } {
        log "Modifying XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
        
        set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key ""] $::query_dlctrl]
      
        unset ::query_dlctrl
        
        set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "" ] $::query_kensaku]
        set xml [::xml::InsertNode $xml {2 end 0} $::view_kensaku]
     
        unset ::query_kensaku
        unset ::view_kensaku
        
        set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "" ] $::query_browser]
        set xml [::xml::InsertNode $xml {2 end 0} $::view_browser]
     
        unset ::query_browser
        unset ::view_browser
        
        set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "" ] $::query_premo]
        set xml [::xml::InsertNode $xml {2 end 0} $::view_premo]
     
        unset ::query_premo
        unset ::view_premo
        
        set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "" ] $::query_manual]
        set xml [::xml::InsertNode $xml {2 end 0} $::view_manual]
     
        unset ::query_manual
        unset ::view_manual
        
        ::xml::SaveToFile $xml $file
    }
    
    proc find_nodes { file } {
        log "Parsing XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
        
        if {$::patch_xmb::options(--add-emu-seg)} {
            set ::query_emulator [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_emulator"]
            set ::view_emulator [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_emulator"]
            set ::view_emu [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_emu"]
         
            if {$::query_emulator == "" || $::view_emulator == "" || $::view_emu == "" } {
                die "Could not parse $file"
            }
        }
        
        if {$::patch_xmb::options(--add-hb-seg)} {
            set ::query_hbrew [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_hbrew"]
            set ::view_hbrew [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_hbrew"]
            set ::view_brew [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_brew"]
         
            if {$::query_hbrew == "" || $::view_hbrew == "" || $::view_brew == "" } {
                die "Could not parse $file"
            }
        }
        
        if {$::patch_xmb::options(--add-pkg-mgr)} {
            set ::query_package_manager [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_package_manager"]
            set ::view_package_manager [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_package_manager"]
            set ::view_pkg_files [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_pkg_files"]
            set ::view_pkg_fixed [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_pkg_fixed"]
            set ::view_install_pkg_fixed [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_install_pkg_fixed"]
            set ::view_delete_pkg_fixed [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_delete_pkg_fixed"]
            set ::view_pkg_install_fixed [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_pkg_install_fixed"]
            set ::view_pkg_install_flash [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_pkg_install_flash"]
            set ::view_pkg_install_hdd0 [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_pkg_install_hdd0"]
            set ::view_pkg_install_usb [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_pkg_install_usb"]
            set ::view_pkg_install_orig [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_pkg_install_orig"]
            set ::view_pkg_delete_fixed [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_pkg_delete_fixed"]
            set ::view_pkg_delete_hdd0 [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_pkg_delete_hdd0"]
            set ::view_pkg_delete_usb [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_pkg_delete_usb"]
            set ::view_pkg_delete_orig [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_pkg_delete_orig"]
            
            if {$::query_package_manager == "" || $::view_package_manager == "" || $::view_pkg_files == "" || $::view_pkg_fixed == "" || $::view_install_pkg_fixed == "" || $::view_delete_pkg_fixed == "" || $::view_pkg_install_fixed == "" || $::view_pkg_install_flash == "" || $::view_pkg_install_hdd0 == "" || $::view_pkg_install_usb == "" || $::view_pkg_install_orig == "" || $::view_pkg_delete_fixed == "" || $::view_pkg_delete_hdd0 == "" || $::view_pkg_delete_usb == "" || $::view_pkg_delete_orig == "" } {
                die "Could not parse $file"
            }
        }
    }
    
    proc find_nodes1 { file } {
        log "Parsing XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
        
        if {$::patch_xmb::options(--add-install-pkg) || $::patch_xmb::options(--patch-pkg-files)} {
            set ::query_package_files [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_package_files"]
            set ::view_package_files [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_package_files"]
            set ::view_packages [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_packages"]
         
            if {$::query_package_files == "" || $::view_package_files == "" || $::view_packages == "" } {
                die "Could not parse $file"
            }
        }
        
        if {$::patch_xmb::options(--patch-app-home)} {
            set ::query_gamedebug [::xml::GetNodeByAttribute $xml "XMBML:View:Items:Query" key "seg_gamedebug"]
            set ::view_gamedebug [::xml::GetNodeByAttribute $xml "XMBML:View" id "seg_gamedebug"]
         
            if {$::query_gamedebug == "" || $::view_gamedebug== "" } {
                die "Could not parse $file"
            }
        }
    }
    
    proc find_nodes2 { file } {
        log "Parsing XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
     
        set ::XMBML [::xml::GetNodeByAttribute $xml "XMBML" version "1.0"]
     
        if {$::XMBML == ""} {
            die "Could not parse $file"
        }
    }
    
    proc inject_nodes { file } {
        log "Modifying XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
        
        if {$::patch_xmb::options(--add-emu-seg)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_emulator]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_emulator]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_emu]
         
            unset ::query_emulator
            unset ::view_emulator
            unset ::view_emu
        }
        
        if {$::patch_xmb::options(--add-hb-seg)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_hbrew]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_hbrew]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_brew]
          
            unset ::query_hbrew
            unset ::view_hbrew
            unset ::view_brew
        }
        
        if {$::patch_xmb::options(--add-pkg-mgr)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_package_manager]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_package_manager]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_pkg_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_pkg_fixed]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_install_pkg_fixed]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_delete_pkg_fixed]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_pkg_install_fixed]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_pkg_install_flash]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_pkg_install_hdd0]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_pkg_install_usb]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_pkg_install_orig]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_pkg_delete_fixed]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_pkg_delete_hdd0]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_pkg_delete_usb]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_pkg_delete_orig]
            
            unset ::query_package_manager
            unset ::view_package_manager
            unset ::view_pkg_files
            unset ::view_pkg_fixed
            unset ::view_install_pkg_fixed
            unset ::view_delete_pkg_fixed
            unset ::view_pkg_install_fixed
            unset ::view_pkg_install_flash
            unset ::view_pkg_install_hdd0
            unset ::view_pkg_install_usb
            unset ::view_pkg_install_orig
            unset ::view_pkg_delete_fixed
            unset ::view_pkg_delet_hdd0
            unset ::view_pkg_delete_usb
            unset ::view_pkg_delete_orig
        }
     
        if {$::patch_xmb::options(--add-install-pkg)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_packages]
        }
        
        ::patch_xmb::clean_net
        
        log "Saving XML"
        ::xml::SaveToFile $xml $file
        
        ::patch_xmb::change_welcome_string
        
        log "Copy custom icon's into dev_flash"
        ::copy_mfw_imgs
        
        if {[file exists $::customize_firmware::options(--customize-embended-app) != 0] && !$::patch_cos::options(--patch-lv2-payload-hermes-4x)} {
            log "WARNING! You want to change the embended App but you forgot to set the patch for lv2 payload hermes 4.xx"
            log "WARNING! Without this patch the App can not be mounted"
            log "Skipping customization of the embended App"        
        } elseif {[file exists $::customize_firmware::options(--customize-embended-app)] != 0 && $::patch_cos::options(--patch-lv2-payload-hermes-4x)} {
            log "Copy custom embended app into dev_flash"
            ::patch_ps3_game $embd
        } elseif {$::patch_cos::options(--patch-lv2-payload-hermes-4x)} {
            log "Installing standalone '*Install Package Files' app"
            ::patch_ps3_game ${::CUSTOM_PS3_GAME}
        }
		
    }
   
    proc inject_nodes2 { file } {
        log "Modifying XML: [file tail $file]"
        set xml [::xml::LoadFile $file]
            
        if {$::patch_xmb::options(--patch-package-files)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_package_files]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_packages]
        }
        
        if {$::patch_xmb::options(--patch-app-home)} {
            set xml [::xml::InsertNode $xml [::xml::GetNodeIndicesByAttribute $xml "XMBML:View:Items:Query" key "seg_gameexit"] $::query_gamedebug]
            set xml [::xml::InsertNode $xml {2 end 0} $::view_gamedebug]
        }       
        log "Saving XML"
        ::xml::SaveToFile $xml $file
        
        if {!$::patch_xmb::options(--add-install-pkg) && !$::patch_xmb::options(--add-pkg-mgr) && !$::patch_xmb::options(--add-hb-seg) && !$::patch_xmb::options(--add-emu-seg) } {
            if {[file exists $::customize_firmware::options(--customize-embended-app) != 0] && !$::patch_cos::options(--patch-lv2-payload-hermes-4x)} {
                log "WARNING! You want to change the embended App but you forgot to set the patch for lv2 payload hermes 4.xx"
                 log "WARNING! Without this patch the App can not be mounted"
                 log "Skipping customization of the embended App"        
            } elseif {[file exists $::customize_firmware::options(--customize-embended-app) != 0] && $::patch_cos::options(--patch-lv2-payload-hermes-4x)} {
                log "Copy custom embended app into dev_flash"
                ::patch_ps3_game $embd
            } elseif {$::patch_cos::options(--patch-lv2-payload-hermes-4x)} {
                log "Copy standalone '*Install Package Files' app into dev_flash"
                ::copy_ps3_game ${::CUSTOM_PS3_GAME}
            }  
        }
    }
	
	# fix for network cat, sony left a unclosed brace which will "modify_xml" command cause a error
	proc remove_line_from_network_cat {file} {
	    set src $file
	    set tmp ${src}.work
     
        set source [open $file]
        set desti [open $tmp w]
        set buff [read $source]
        close $source
        set lines [split $buff \n]
        set lines_after_deletion [lreplace $lines 47 47]
        puts -nonewline $desti [join $lines_after_deletion \n]
        close $desti
        file rename -force $tmp $file
	}
}