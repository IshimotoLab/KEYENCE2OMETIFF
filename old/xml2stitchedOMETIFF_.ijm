
// Show dialog to select tile image directory
close("*");
showMessageWithCancel("xml2stitchedOMETIFF", "Select a Directory within the xml file from bigstitcher. Press OK to proceed.");
openDir = getDirectory("Select a Directory within the xml file from bigstitcher");

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

Dialog.create("Information");
Dialog.addDirectory("Select a output folder", File.getDirectory(openDir));
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
items3 = newArray("Fluorescence", "HE");
Dialog.addRadioButtonGroup("Select your image format", items3, 1, 2, "Fluorescence");
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
ch_list_withoutDNA = Array.deleteValue(ch_list, DNAch);
	
if (grid_total != tile_count) {
	exit("Tiling image count is " + tile_count + 
	". But your grid setting is " + grid_x + " x " + grid_y + " = " + 
	grid_total + "\nTry it again with the correct settings.");
}

if (image_format == "Fluorescence") {

	if (ch_count == 2) {
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


if (image_format == "HE") {
	ch_tmp_list = newArray("CH1", "CH2", "CH3");
}else {
	ch_tmp_list = Array.copy(ch_list_new);
}

ch_tmp_count = ch_tmp_list.length;
tmppath = openDir;
	
///////////////////////////


// Create strings for tileconfiguration file
tileCfg = "# Define the number of dimensions we are working on\ndim = 2\n\n# Define the image coordinates";

// read Bigstitcher xml file as string
xmldata = File.openAsString(tmppath + File.separator + "dataset.xml");

startreg = indexOf(xmldata, "<ViewRegistrations>");
endreg = indexOf(xmldata, "</ViewRegistrations>");
xmldata_sub = substring(xmldata, startreg, endreg);
xmldata_arr = split(xmldata_sub, "\n");
xmldata_arr_filtered = Array.filter(xmldata_arr, "<affine>");
slicearr = Array.slice(xmldata_arr_filtered, 0, xmldata_arr_filtered.length/ch_tmp_count);
lineNum = (slicearr.length) / tile_count;

str0_calib = slicearr[lineNum-1];
startaff0_calib = indexOf(str0_calib, "<affine>")+8;
endaff0_calib = lastIndexOf(str0_calib, "</affine>");
calib0 = substring(str0_calib, startaff0_calib, endaff0_calib);
calibArr0 = split(calib0, " ");
loc_x0_calib = parseFloat(calibArr0[0]);
loc_y0_calib = parseFloat(calibArr0[5]);

loc_x0 = 0;
loc_y0 = 0;

for (i = 0; i < (lineNum-1); i++) {
	lineNo_0 = (lineNum-1) - i - 1;
	str0_1 = slicearr[lineNo_0];
	startaff0_1 = indexOf(str0_1, "<affine>")+8;
	endaff0_1 = lastIndexOf(str0_1, "</affine>");
	stitTrans0 = substring(str0_1, startaff0_1, endaff0_1);
	stitTArr0 = split(stitTrans0, " ");
	loc_x0 = loc_x0 + parseFloat(stitTArr0[3]);
	loc_y0 = loc_y0 + parseFloat(stitTArr0[7]);
}

loc_x0 = loc_x0 / loc_x0_calib;
loc_y0 = loc_y0 / loc_y0_calib;


for (i = 0; i < (tile_count); i++) {
	
	lineNo_calib = ((i + 1) * lineNum) - 1;
	str_calib = slicearr[lineNo_calib];
	startaff_calib = indexOf(str_calib, "<affine>")+8;
	endaff_calib = lastIndexOf(str_calib, "</affine>");
	calib = substring(str_calib, startaff_calib, endaff_calib);
	calibArr = split(calib, " ");
	loc_x_calib = parseFloat(calibArr[0]);
	loc_y_calib = parseFloat(calibArr[5]);
	
	loc_x_tmp = 0;
	loc_y_tmp = 0;
	
	for (j = 0; j < (lineNum-1); j++) {
		lineNo = lineNo_calib - j - 1;
		str_1 = slicearr[lineNo];
		startaff_1 = indexOf(str_1, "<affine>")+8;
		endaff_1 = lastIndexOf(str_1, "</affine>");
		stitTrans = substring(str_1, startaff_1, endaff_1);
		stitTArr = split(stitTrans, " ");
		loc_x_tmp = loc_x_tmp + parseFloat(stitTArr[3]);
		loc_y_tmp = loc_y_tmp + parseFloat(stitTArr[7]);
	}
	
	loc_x = loc_x_tmp / loc_x_calib;
	loc_y = loc_y_tmp / loc_y_calib;
	
	loc_x = d2s(loc_x - loc_x0, 13);
	loc_y = d2s(loc_y - loc_y0, 13);
	
	locstr = "\n" + tile_sample + "_" + tile_list[i] + "_" + ch_tmp_list[0] + ".tif; ; (" + loc_x + ", " + loc_y + ")";
	
	tileCfg = tileCfg + locstr;
}

// Save TileConfiguration file
tileconfigPath = tmppath + File.separator + "TileConfiguration.txt";
File.saveString(tileCfg, tileconfigPath);

///////////////////////////

// transform images to ome-tiff	
// using Grid/Collection stitching
savepath = saveDir + samplename + "_" + String.join(ch_name_list, "_");
//pxWidth = d2s(parseFloat(calibArr0[0]), 4);
//pxheight = d2s(parseFloat(calibArr0[5]), 4);
pxsize = d2s(calcKeyenceCalib(magnif, resolution), 5);

run("Grid/Collection stitching", 
	"type=[Positions from file] order=[Defined by TileConfiguration]" +
	" directory=[" + tmppath + File.separator + "] layout_file=[TileConfiguration.txt]" +
	" fusion_method=[Linear Blending] regression_threshold=0.30" +
	" max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50" +
	" subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)]" +
	" image_output=[Fuse and display]");

if (ch_tmp_count != 1) {
	
// stitching other channels			
	for (i = 1; i < (ch_tmp_count); i++) {
		config_dna = File.openAsString(tileconfigPath);
		confignew_path = "TileConfiguration_" + ch_tmp_list[i] + ".txt";
		config_new = replace(config_dna, ch_tmp_list[0], ch_tmp_list[i]);
		close("Log");
		print(config_new);
		saveAs("text", tmppath + File.separator + confignew_path);
		close("Log");
			
		run("Grid/Collection stitching", 
			"type=[Positions from file] order=[Defined by TileConfiguration]" +
			" directory=[" + tmppath + File.separator + "] layout_file=[" + confignew_path +"]" +
			" fusion_method=[Linear Blending] regression_threshold=0.30" +
			" max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50" +
			" subpixel_accuracy computation_parameters=[Save computation time (but use more RAM)]" +
			" image_output=[Fuse and display]");
	}	
	
	if (image_format == "HE") {
		
		run("Images to Stack", "use");
		run("Stack to RGB");
		Stack.setXUnit("micron");
		run("Properties...", "channels=1 slices=1 frames=1 pixel_width=" + pxsize +
			" pixel_height=" + pxsize + " voxel_depth=" + pxsize);
			
	}else {
		run("Images to Stack", "use");
		Stack.setXUnit("micron");
		run("Properties...", "channels=" + ch_count + " slices=1 frames=1" +
			" pixel_width=" + pxsize + " pixel_height=" + pxsize + " voxel_depth=" + pxsize);
	}

}else {
	Stack.setXUnit("micron");
	run("Properties...", "channels=" + ch_count + " slices=1 frames=1" +
		" pixel_width=" + pxsize + " pixel_height=" + pxsize + " voxel_depth=" + pxsize);
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

// get index of value in array
function index(a, value) {
	for (i=0; i<a.length; i++)
	if (a[i]==value) return i;
	
	return -1; 
}


// delete directory
function delDir(path, comm) { 
	delList = getFileList(path);
	for (i = 0; i < delList.length; i++) {
		File.delete(path + delList[i]);
	}
	File.delete(path);
	
	if (File.exists(path)) {
		exit("Unable to delete tmp directory\n" + comm);
	}
}


// calclation keyence calibratoin scale
function calcKeyenceCalib(m, res) { 
	magnif_rate_arr = newArray(1, 2.5, 5, 10, 15);
	calib_arr = newArray(5.66162, 3.77441, 1.8872);
	
	if (m == "x4") {
		magnif_rate = magnif_rate_arr[0];
	}else if (m == "x10") {
		magnif_rate = magnif_rate_arr[1];
	}else if (m == "x20") {
		magnif_rate = magnif_rate_arr[2];
	}else if (m == "x40") {
		magnif_rate = magnif_rate_arr[3];
	}else if (m == "x60") {
		magnif_rate = magnif_rate_arr[4];
	}
	
	if (res == "High Sensitivity") {
		calib = calib_arr[0];
	}else if (res == "Standard") {
		calib = calib_arr[1];
	}else if (res == "High Resolution") {
		calib = calib_arr[2];
	}
	
	pxsize = calib / magnif_rate;	
	return pxsize;
}


//------------------------------

