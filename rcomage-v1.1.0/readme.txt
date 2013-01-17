Rcomage v1.1.0 readme
written by ZiNgA BuRgA

URL: http://endlessparadigm.com/forum/showthread.php?tid=19501


 Introduction
 ------------
Rcomage is a general purpose RCO creation/manipulation tool.  It is designed to allow RCOs to be modified in almost any way, and intended to replace my previous application, RCO Editor.  Rcomage should also generate almost fully "compliant" resource files (very similar to original Sony RCOs).
RCO files are resource files that can be found in the PSP's flash0:/vsh/resource directory which contain stuff like icon data and various other resource components.  RCOs can also be found on UMD Video/Audio discs, where they are used to supply resources to the menus.
Currently, it only has two primary features - RCO dumping and RCO compiling.

Unfortunately, I've released this in a bit of a rush, so haven't really checked many things and haven't added many features I intended to put in.


 Using
 -----
I've included a very basic GUI to save you learning the commands.  For normal operation, for editing an RCO file, you'd open the RCO in the Dump tab, select where to export the structure and resources to, then click Dump.
You may then proceed to edit the dump of the RCO (eg, replace images or modify the structure by editing the XML dump).
To compile an RCO, go to the Compile tab, select a valid XML structure file, select where to save the new RCO and click Compile.

For using the CLI, use the command 'rcomage help' for details.


 General RCOXML structure
 ------------------------
The following should give you a general idea of the general structure for an RCO file.  Not all nodes below are required, and various object/anim entries are omitted.

RcoFile - XML root element; generally does not need to be modified
	MainTree - root RCO node from which everything must descend from
		VSMXFile - attached UMD virtual machine instruction code, for UMD and some LFTV RCOs.  Only one may exist in an RCO file
		ImageTree - parent node from which all image resources descend from
			Image
			Image
			...
		ModelTree - parent node from which all model resources descend from
			Model
			Model
			...
		SoundTree - parent node from which all sound resources descend from
			Sound
			Sound
			...
		ObjectTree - parent node from which all object pages descend from
			<Page>
				page objects go here
			<Page>
				page objects go here
			...
		AnimTree - parent node from which all animation sequences descend from
			<Animation>
				animation entries go here
			<Animation>
				animation entries go here
			...


 Changelog
 ---------
v1.1.0  (3rd Apr, 2010)
 - Minor message output changes
 - Fixed bug where rcomage may have tried to convert non-GIM images through gimconv when dumping
 - Fixed minor issue if Image/Sound/Text tree contained no subentries
 - Removed option to select compression for PNG/JPG/TIF/GIF resources in GUI as it's mostly useless and may break the RCO if changed
 - Add UMDFlag attribute to RcoFile tag
 - Reduce the use of CDATA sections in the dumped text XML file
 - Add basic VSMX decoder/encoder; add corresponding option when dumping/compiling in CLI and GUI, as well as vsmxdec and vsmxenc functions in the CLI
 - Add experimental VSMX -> Javascript decompiler.  This will most likely crash, but if you're lucky, it might go through and give half-readable output.  Only use this if you're really interested; can only be accessed via the CLI using the --decompile option of vsmxdec
 - Export some internal constants to .ini files
 - Add support for UTF8 and UTF32 text in RCOs (found in PS3 RCOs); also fixed some potential character encoding issues
 - Add support for Fontstyle entries (used in the sysconf PS3 RCO)
 - Greatly improve handling PS3 RCO object structures (thanks goes to geohot for RCO samples)
 - Add support for writing PS3 RCOs; also modify GimConv to add PS3 configuration option

v1.0.2  (7th Dec, 2009)
 - statically link all libraries; also now built with MinGW so MSVC runtime no longer required
 - include required DLLs with GimConv
 - fixed bug in GUI where it didn't chdir across drives
 - partially removed annoying auto-fill for dumping RCOs for GUI
 - fixed crash where bad label reference was supplied
 - add like two additional warnings
 - add ability to select zlib compression options from CLI
 - partial support for reading big-endian (PS3?) RCOs; it's "partial" as there are still issues - mainly object handling is mostly stuffed up
 - fix regression in earlier update which broke VSMX dumping
 - minor changes to XML format
 - apply hack which hopefully fixes up GimConv converting from some GIMs
 - and if the above still causes GimConv to freeze, added a timeout to try to not cause Rcomage to lock up as well
 - added "vagenc" and "vagdec" functions if you happen to want to convert a .vag file
 - added "extract" function (not 100% complete)

v1.0.1  (28th Oct, 2009)
 - fix crash with WAV -> VAG conversion
 - fix sound clipping issues with WAV -> VAG conversion (fix appears to work, but I really haven't looked at it much)
 - added ability for compile function to read from stdin
 - use \ for directory separators on Windows
 - slight speedup with gimconv (no longer invokes the cmd shell)
 - '--xml-only' switch for dumping removed, use '--resdir -' instead
 - fix bugs relating to handling XML files with resource dumping disabled
 - minor changes to messages
 - GUI will attempt to use relative paths instead of always relying on absolute paths
 - fix folder creation bug in GUI
 - other minor GUI changes


 Planned Features
 ----------------
- better sanity checks and error handling
- giant cleanup of code (so I can release it later and allow Linux users to compile it)
- RLZ compression/decompression
- better information displays
- internal BMP <-> GIM converter
- documentation of RCOXML format as well as the RCO file format
- more functions (rather than just "dump" and "compile" etc)
- discovery of various "unknown" values
- anything not on my mind right now


 Notes
 -----
- RCO Editor doesn't write adler32 checksums when compressing images (yes, stupid stupid me) so anything edited with RCOEdit will generate a warning when you try to dump it; use --no-decomp-warn flag to suppress warnings (the GUI automatically does this)
- Sony's Gimconv is a little slow, so if you're dumping and converting GIMs, be a little patient (yes, I really did not write gimconv)
- what was referred to as "page" in RCOEdit is now called "object"
- conversions (such as WAV<->VAG or PNG<->GIM) may be lossy!
- a recent update_plugin.rco decompressed with Resurssiklunssi will generate a warning due to Sony deciding not to compress a particular icon in it, in turn, changing the structure a bit, which Resurssiklunssi wasn't designed to handle, so generates a "bad" RCO; recompiling the RCO with Rcomage will fix this issue however
- if zlib level 9 compression is used (specify '--zlib-method default --zlib-level 9' when compiling), RCOs recompiled with Rcomage should either be the same size as the original (decompressed with Resurssiklunssi), or 4 bytes smaller.  This 4 byte difference is due to some weird padding found in the EventData segment of some RCOs, which don't seem to really make any sense to me.  However, these 4 bytes don't seem to be necessary.
- other differences which may occur when recompiling are reordering of names/events and how null text data is represented


 Credits
 -------
- highboy for his WAV <-> VAG conversion sample code
- Z33 for sample GIM handling code and his various RCO tools as well as guides/investigations on various file formats
- creators of 7-zip for their awesome implementation of deflate
- supporting libraries: libxml2, iconv and zlib
- geohot for help with PS3 RCO support
- alpha testers, for discovering some issues and supporting theme development
- everyone else supporting PSP customisation and homebrew scene (too numerous to name)
- anyone I forgot to mention
