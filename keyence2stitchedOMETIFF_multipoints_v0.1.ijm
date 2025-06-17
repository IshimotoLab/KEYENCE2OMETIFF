// keyence tile images transform to stitched ome-tif
// Show dialog to select tile image directory
close("*");
showMessageWithCancel("keyence2stitchedOMETIFF", "Select a Directory within Keyence multi-poisnts tile images. Press OK to proceed.");
multiopenDir = getDirectory("Select a Directory within Keyence multi-poisnts tile images");

// get points number
pointlist = getFileList(multiopenDir);
sample_count = pointlist.length;

pointlist2 = newArray(sample_count);
for (i = 0; i < (sample_count); i++) {
	splitmulti = split(pointlist[i], "/");
	splitmulti1 = splitmulti[splitmulti.length - 1];
	pointlist2[i] = splitmulti1;
}

// get channel number
ALLimagelist = getFileList(multiopenDir + pointlist[0]); 
tile1 = Array.filter(ALLimagelist, "(_00001_CH[1234].tif)");
ch_count = tile1.length;

if (ch_count == 0) {
	exit("There is no Keyence multi-poisnts formatted tile image. Select the correct folder.");
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
tile_sample_split = split(tileimage_list[0], "(_XY[0-9]{2}_)");
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
	Dialog.addDirectory("Select a output folder", File.getDirectory(multiopenDir + pointlist[0]));
	Dialog.addString("Sample name", tile_sample, 25);
	Dialog.setInsets(-8, 200, 0);
	Dialog.addMessage("Do not include space or under score. (\" \" or \"_\")", 11);
	Dialog.setInsets(10, 40, 0);
	items1 = newArray("x4", "x10", "x20", "x40", "x60");
	Dialog.addRadioButtonGroup("Select magnification", items1, 1, 5, "x20");
	Dialog.setInsets(5, 40, 0);
	items2 = newArray("High Resolution", "Standard", "High Sensitivity");
	Dialog.addChoice("Select Resolution/Sensitivity", items2);
	Dialog.setInsets(15, 40, 0);
	items3 = newArray("HE", "Fluorescence");
	Dialog.addRadioButtonGroup("Select your image format", items3, 1, 2, "HE");
	Dialog.setInsets(10, 40, 0);	
	Dialog.addNumber("Grid size x", 1);
	Dialog.setInsets(0, 40, 0);
	Dialog.addNumber("Grid size y", 1);
		
	Dialog.show();
			
	saveDir = Dialog.getString();
	samplename = Dialog.getString();
	magnif = Dialog.getRadioButton();	
	resolution = Dialog.getChoice();
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
		exit("Tiling image count is " + tile_count + 
		". But your grid setting is " + grid_x + " x " + grid_y + " = " + 
		grid_total + "\nTry it again with the correct settings.");
	}
}else {
	Dialog.create("Information");
	Dialog.addDirectory("Select a output folder", File.getDirectory(multiopenDir + pointlist[0]));
	Dialog.addString("Sample name", tile_sample, 25);
	Dialog.setInsets(-8, 200, 0);
	Dialog.addMessage("Do not include space or under score. (\" \" or \"_\")", 11);
	Dialog.setInsets(10, 30, 0);
	items1 = newArray("x4", "x10", "x20", "x40", "x60");
	Dialog.addRadioButtonGroup("Select magnification", items1, 1, 5, "x20");
	Dialog.setInsets(5, 30, 0);
	items2 = newArray("High Resolution", "Standard", "High Sensitivity");
	Dialog.addChoice("Select Resolution/Sensitivity", items2);
	Dialog.setInsets(10, 30, 0);
	Dialog.addMessage("Select DNA Channel");
	Dialog.addChoice("DNA channel", ch_list, ch_list[0]);
	Dialog.addNumber("Cycle no", 1);
	Dialog.addNumber("Grid size x", 1);
	Dialog.addNumber("Grid size y", 1);
	Dialog.show();
			
	saveDir = Dialog.getString();
	samplename = Dialog.getString();
	magnif = Dialog.getRadioButton();	
	resolution = Dialog.getChoice();	
	DNAch = Dialog.getChoice();
	cycl_no = Dialog.getNumber();
	grid_x = Dialog.getNumber();
	grid_y = Dialog.getNumber();
	ch_list_withoutDNA = Array.deleteValue(ch_list, DNAch);
	grid_total = grid_x * grid_y;
	DNAch_name = "DNA" + cycl_no;
	image_format = "Fluorescence";
		
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
	
	
///////////////////////////



if (image_format == "HE") {
	
	for (i = 0; i < (sample_count); i++) {
		openDir = multiopenDir + pointlist[i];
		pointname = samplename + "_" + pointlist2[i];
		
		run("keyence2stitchedOMETIFF v1.1", "select=[" + openDir + "] select=[" + saveDir + "] sample=[" +
			 pointname + "] select_1=[" + magnif + "] select_2=[" + resolution + "] select_3=[" + image_format + 
			 "] grid=[" + grid_x + "] grid_0=[" + grid_y + "]");
			 
		close("*");
	}
}else if (image_format == "Fluorescence") {
	
		for (i = 0; i < (sample_count); i++) {
		openDir = multiopenDir + pointlist[i];
		pointname = samplename + "_" + pointlist2[i];
		
		if (ch_count == 1) {
			chstring = "";
		}else if (ch_count == 2) {
			chst1 = toLowerCase(ch_list_withoutDNA[0]);
			chstring = chst1 + "=" + ch2nd_name + " 2nd=" + ch2nd;
			
		}else if (ch_count == 3) {
			chst1 = toLowerCase(ch_list_withoutDNA[0]);
			chst2 = toLowerCase(ch_list_withoutDNA[1]);
			chstring = chst1 + "=" + ch2nd_name + " " + chst2 + "=" + ch3rd_name + " 2nd=" + ch2nd + " 3rd=" + ch3rd;
			
		}else if (ch_count == 4) {
			chst1 = toLowerCase(ch_list_withoutDNA[0]);
			chst2 = toLowerCase(ch_list_withoutDNA[1]);
			chst3 = toLowerCase(ch_list_withoutDNA[2]);
			chstring = chst1 + "=" + ch2nd_name + " " + chst2 + "=" + ch3rd_name + " " + chst3 + "=" + ch4th_name + " 2nd=" + ch2nd + " 3rd=" + ch3rd + " 4th=" + ch4th;
		}

		
		run("keyence2stitchedOMETIFF v2.1", "select=[" + openDir + "] select=[" + saveDir + "] sample=[" +
			 pointname + "] select_1=[" + magnif + "] select_2=[" + resolution + 
			 "] dna=[" + DNAch + "] cycle=[" + cycl_no + 
			 "] grid=[" + grid_x + "] grid_0=[" + grid_y + 
			 "] " + chstring);
			 
		close("*");
}



//functions---------------------

// get index of value in array
function index(a, value) {
	for (i=0; i<a.length; i++)
	if (a[i]==value) return i;
	
	return -1; 
}



//------------------------------
