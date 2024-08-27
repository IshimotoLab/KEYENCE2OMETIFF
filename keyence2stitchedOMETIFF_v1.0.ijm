// keyence tile images transform to stitched ome-tif
// Show dialog to select tile image directory
close("*");
showMessageWithCancel("keyence2stitchedOMETIFF", "Select a Directory within the Keyence tile images. Press OK to proceed.");
openDir = getDirectory("Select a Directory within the Keyence tile images");

// get channel number
ALLimagelist = getFileList(openDir); 
tile1 = Array.filter(ALLimagelist, "(_00001_CH[1234].tif)");
ch_count = tile1.length;

if (ch_count == 0) {
	exit("There is no Keyence formatted tile image. Select the correct folder.");
}

ch_list = newArray(ch_count);

for (i = 0; i < (ch_count); i++) {
	split1 = split(tile1[i], ".tif");
	tile1_name = split1[split1.length - 1];
	split2 = split(tile1_name, "_");
	tile1_ch = split2[split2.length - 1];
	ch_list[i] = tile1_ch;
}

// get image number for stitching
tileimage_list = Array.filter(ALLimagelist, "(_[0-9]{5}_" + ch_list[0] + ".tif)");
tile_count = tileimage_list.length;
tile_list = newArray(tile_count);
tile_sample_split = split(tileimage_list[0], "(_[0-9]{5}_)");
tile_sample = tile_sample_split[tile_sample_split.length - 2];

for (i = 0; i < (tile_count); i++) {
	split1 = split(tileimage_list[i], ".tif");
	tile1_name = split1[split1.length - 1];
	split2 = split(tile1_name, "_");
	tile1_no = split2[split2.length - 2];
	tile_list[i] = tile1_no;
}


// get information of images
// Show dialog
if (ch_count == 1) {
	Dialog.create("Information");
	Dialog.addDirectory("Select a output folder", File.getDirectory(openDir));
	Dialog.addString("Sample name", tile_sample, 25);
	Dialog.setInsets(-8, 100, 0);
	Dialog.addMessage("Do not include space or under score. (\" \" or \"_\")", 11);
	Dialog.setInsets(10, 0, 0);
	items1 = newArray("HE", "Fluorescence");
	Dialog.addRadioButtonGroup("Select your image format", items1, 1, 2, "HE");
	Dialog.setInsets(10, 0, 0);	
	Dialog.addNumber("Grid size x", 1);
	Dialog.addToSameRow();
	Dialog.addNumber("Grid size y", 1);
		
	Dialog.show();
			
	saveDir = Dialog.getString();
	samplename = Dialog.getString();
	image_format = Dialog.getRadioButton();	
	grid_x = Dialog.getNumber();
	grid_y = Dialog.getNumber();
		
	DNAch = ch_list[0];
	grid_total = grid_x * grid_y;
		
	if (image_format == "HE") {
		DNAch_name = "HE";
	} else {
		DNAch_name = "DNA";
	}
										
	ch_list_new = newArray(DNAch);
	ch_name_list = newArray(DNAch_name);
	
	if (grid_total != tile_count) {
		exit("Tiling image count is " + tile_count + ". But your grid setting is " + grid_x + " x " + grid_y + " = " + grid_total + "\nTry it again with the correct settings.");
	}
	}else {
		Dialog.create("Information");
		Dialog.addDirectory("Select a output folder", File.getDirectory(openDir));
		Dialog.addString("Sample name", tile_sample, 25);
		Dialog.setInsets(-8, 100, 0);
		Dialog.addMessage("Do not include space or under score. (\" \" or \"_\")", 11);
		Dialog.addMessage("Select DNA Channel");
		Dialog.addChoice("DNA channel", ch_list, ch_list[0]);
		Dialog.addNumber("Cycle no", 1);
		Dialog.addNumber("Grid size x", 1);
		Dialog.addToSameRow();
		Dialog.addNumber("Grid size y", 1);
		Dialog.show();
			
		saveDir = Dialog.getString();
		samplename = Dialog.getString();
		DNAch = Dialog.getChoice();
		cycl_no = Dialog.getNumber();
		grid_x = Dialog.getNumber();
		grid_y = Dialog.getNumber();
		ch_list_withoutDNA = Array.deleteValue(ch_list, DNAch);
		grid_total = grid_x * grid_y;
		DNAch_name = "DNA" + cycl_no;
		
		if (grid_total != tile_count) {
			exit("Tiling image count is " + tile_count + ". But your grid setting is " + grid_x + " x " + grid_y + " = " + grid_total + "\nTry it again with the correct settings.");
		
		}else if (ch_count == 2) {
				Dialog.create("Information2");
				Dialog.setInsets(0, 3, 0);
				Dialog.addMessage("Modify Channel name");
				Dialog.addString(ch_list_withoutDNA[0], ch_list_withoutDNA[0], 15);
				Dialog.setInsets(-8, 90, 0);
				Dialog.addMessage("e.g. aSMA");
				Dialog.setInsets(20, 3, 0);
				Dialog.addMessage("Modify stacking order");
				Dialog.setInsets(0, 3, 0);
				Dialog.addMessage("First channel is " + DNAch + " (" + DNAch_name + ")");
				Dialog.setInsets(0, 5, 0);
				Dialog.addChoice("2nd channel", ch_list_withoutDNA, ch_list_withoutDNA[0]);
			
				Dialog.show();
			
				ch2nd_name = Dialog.getString();
				ch2nd = Dialog.getChoice();
				ch_list_new = newArray(DNAch, ch2nd);
				ch_name_list = newArray(DNAch_name, ch2nd_name);
			
		}else if (ch_count == 3) {
				Dialog.create("Information2");
				Dialog.setInsets(0, 3, 0);
				Dialog.addMessage("Modify Channel name");
				Dialog.addString(ch_list_withoutDNA[0], ch_list_withoutDNA[0], 15);
				Dialog.addString(ch_list_withoutDNA[1], ch_list_withoutDNA[1], 15);
				Dialog.setInsets(-8, 90, 0);
				Dialog.addMessage("e.g. aSMA");
				Dialog.setInsets(20, 3, 0);
				Dialog.addMessage("Modify stacking order");
				Dialog.setInsets(0, 3, 0);
				Dialog.addMessage("First channel is " + DNAch + " (" + DNAch_name + ")");
				Dialog.setInsets(0, 5, 0);
				Dialog.addChoice("2nd channel", ch_list_withoutDNA, ch_list_withoutDNA[0]);
				Dialog.setInsets(0, 5, 0);
				Dialog.addChoice("3rd channel", ch_list_withoutDNA, ch_list_withoutDNA[1]);
			
				Dialog.show();
			
				ch2nd_name = Dialog.getString();
				ch3rd_name = Dialog.getString();
				ch2nd = Dialog.getChoice();
				ch3rd = Dialog.getChoice();
				ch_list_new = newArray(DNAch, ch2nd, ch3rd);
				ch_name_list = newArray(DNAch_name, ch2nd_name, ch3rd_name);
			
		}else if (ch_count == 4) {
				Dialog.create("Information2");
				Dialog.setInsets(0, 3, 0);
				Dialog.addMessage("Modify Channel name");
				Dialog.addString(ch_list_withoutDNA[0], ch_list_withoutDNA[0], 15);
				Dialog.addString(ch_list_withoutDNA[1], ch_list_withoutDNA[1], 15);
				Dialog.addString(ch_list_withoutDNA[2], ch_list_withoutDNA[2], 15);
				Dialog.setInsets(-8, 90, 0);
				Dialog.addMessage("e.g. aSMA");
				Dialog.setInsets(20, 3, 0);
				Dialog.addMessage("Modify stacking order");
				Dialog.setInsets(0, 3, 0);
				Dialog.addMessage("First channel is " + DNAch + " (" + DNAch_name + ")");
				Dialog.setInsets(0, 5, 0);
				Dialog.addChoice("2nd channel", ch_list_withoutDNA, ch_list_withoutDNA[0]);
				Dialog.setInsets(0, 5, 0);
				Dialog.addChoice("3rd channel", ch_list_withoutDNA, ch_list_withoutDNA[1]);
				Dialog.setInsets(0, 5, 0);
				Dialog.addChoice("4th channel", ch_list_withoutDNA, ch_list_withoutDNA[2]);
			
				Dialog.show();
			
				ch2nd_name = Dialog.getString();
				ch3rd_name = Dialog.getString();
				ch4th_name = Dialog.getString();
				ch2nd = Dialog.getChoice();
				ch3rd = Dialog.getChoice();
				ch4th = Dialog.getChoice();
				ch_list_new = newArray(DNAch, ch2nd, ch3rd, ch4th);
				ch_name_list = newArray(DNAch_name, ch2nd_name, ch3rd_name, ch4th_name);
		}
	}

// transform images to ome-tiff	
// stitching DNA channel
	savepath = saveDir + samplename + "_" + String.join(ch_name_list, "_");
	configDna_path = "TileConfiguration.txt";
	DNAch_genericname = tile_sample + "_{iiiii}_" + DNAch + ".tif";
	run("Grid/Collection stitching", "type=[Grid: snake by rows] order=[Right & Down                ] grid_size_x=" + grid_x +" grid_size_y=" + grid_y +" tile_overlap=30 first_file_index_i=1 directory=[" + openDir + "] file_names=[" + DNAch_genericname + "] output_textfile_name=[" + configDna_path + "] fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		
	if (ch_count == 1) {
		if (image_format == "Fluorescence") {
			stack2gray();
		}
	}else {								
		stack2gray();
			
// stitching other channels			
		for (i = 1; i < (ch_count); i++) {
		config_dna = File.openAsString(openDir + configDna_path);
		confignew_path = "TileConfiguration_" + ch_list_new[i] + ".txt";
		config_new = replace(config_dna, ch_list_new[0], ch_list_new[i]);
		close("Log");
		print(config_new);
		saveAs("text", openDir + confignew_path);
		close("Log");
			
		run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory=[" + openDir + "] layout_file=[" + confignew_path +"] fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
			stack2gray();
		}			
		run("Images to Stack", "use");
		run("Stack to Hyperstack...", "order=xyczt(default) channels=ch_count slices=1 frames=1 display=Color");
	}

// save as OME-TIFF
		run("Bio-Formats Exporter", "save=[" + savepath + ".ome.tif] export compression=Uncompressed");

		close("*");
		close("Log");

							
					
//functions---------------------

// 48 bit RGB stack to 16 bit grayscale
function stack2gray(){
	if (is("composite")) {
		Stack.setDisplayMode("grayscale");
		run("Z Project...", "projection=[Average Intensity]");
	}
}



//------------------------------









