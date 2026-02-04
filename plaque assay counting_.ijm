// Plaques counter for 6 wells plate plaque assay
// Nicolas Landrein - MFP - SpacVir 2024


//Counter
//========================== Variables ==================================================
var ori=""; //original name of the analysed image
var in=""; //folder where the image is
var out=""; //folder for 
var minSize = 50;
var maxSize = "Infinity";
var minCirc = 0;
var nWaves = 2; //number of time that the macro dilate the plaque area for detection
var gaussBlur = 2;
var medFilt = 10;
var subBkgd = 50;
var resize = 5000;
var tableTitle = "Plaques Area";


//=======================================================================================

process();

//========================== WHERE THE MAGIC HAPPENS ====================================
function process(){
	prepareImage();
	preparePlaques();
	countPlaques();
	controlImg();
}
//=======================================================================================
function prepareImage(){
	run("Options...", "iterations=1 count=1 black");
	ori=getTitle();
	in = getInfo("image.directory");
	roiManager("Reset");
	run("Enhance Contrast", "saturated=0.35");
	run("Size...", "width="+resize+" height="+resize+" depth=1 constrain average interpolation=Bilinear");
	setTool("oval");
	waitForUser("Faire la sélection de la zone à étudier avec Oval puis appuyer sur OK");
	// Vider autour de la selection 
	setBackgroundColor(0, 0, 0);
	resetMinAndMax;
	run("32-bit");
	run("Clear Outside");
	run("Crop");
	run("Select None");
	run("Duplicate...", "title=count");
	//saveAs("Tiff", in+ori+"_half");
	run("Tile");
}
//=======================================================================================
function preparePlaques(){
	selectWindow("count");	
	run("Clear Results");
	roiManager("reset");
	run("Gaussian Blur...", "sigma="+gaussBlur);
	run("Subtract Background...", "rolling="+subBkgd);
	run("Median...", "radius="+medFilt);
	setAutoThreshold("Otsu dark dark no-reset");
	run("Threshold...");
	waitForUser("1-Modify the threshold to highlight the plaque area\n2-PRESS APPLY !!!\n3-Once done, click Ok");
	
	// Binary pour améliorer la détection
	run("Erode");
	run("Erode");
	for(i=0;i<nWaves;i++){
		run("Dilate");
	}
	run("Close-");
	run("Fill Holes");
	for(i=0;i<nWaves;i++){
		run("Erode");
	}
	//run("Analyze Particles...", "size=3000-Infinity show=Nothing exclude add");
	run("Analyze Particles...", "size="+minSize+"-"+maxSize+" circularity="+minCirc+"-1.00 show=Nothing exclude add");
	waitForUser("Remove the plaques that are not real plaques");
	//getStatistics(area, mean, min, max, std, histogram);
}
//=======================================================================================
function countPlaques(){
	findOrCreateTable(tableTitle);
	selectWindow("count");
	for (i = 0; i < roiManager("count"); i++) {
		Table.set("Image", Table.size, ori);
		roiManager("select", i);
		getStatistics(area, mean, min, max, std, histogram);
		Table.set("ROI", Table.size-1,i+1);
		Table.set("Area", Table.size-1,area);
		Table.update;
	}	
}
//=======================================================================================
function controlImg(){
	selectWindow("count");
	run("Subtract...", "value=255");
	run("Invert LUT");
	roiManager("Show All");
	roiManager("Fill");
	run("Green");
	saveAs("Tiff", in+ori+"_mask");
	run("Tile");
}
//=======================================================================================
function findOrCreateTable(name){
	winTitle=getList("window.titles");
	found=false;
	for(i=0; i<winTitle.length; i++){
		if(winTitle[i]==name){
			found=true;
		}
	}
	if(!found){
		Table.create(name);
	}
}
//=======================================================================================
