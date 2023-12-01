//Comptage des plaques
var in="";
var out="";
var minSize = 3500;
var maxSize = "Infinity";
var nWaves = 5;

prepareImage();
countPlaques();
controlImg();

function prepareImage(){
	ori=getTitle();
	File.getParent(in);
	print(in);
	print(ori);
	roiManager("Reset");
	setTool("oval");
	waitForUser("Faire la sélection de la zone à étudier avec Oval puis appuyer sur OK");
	
	// Vider autour de la selection 
	setBackgroundColor(0, 0, 0);
	run("Clear Outside");
	run("Crop");
	run("Select None");
	run("8-bit");
	saveAs("Tiff", ori+"8bits");
}

function countPlaques(){
	
run("Clear Results");
roiManager("reset");

setAutoThreshold("Otsu dark dark no-reset");
run("Threshold...");
waitForUser("1-Modify the threshold to highlight the plaque area\n2-PRESS APPLY !!!\n3-Once done, click Ok");

// Binary pour améliorer la détection
run("Erode");
for(i=0;i<nWaves;i++){
	run("Dilate");
}
run("Close-");
run("Fill Holes");
for(i=0;i<nWaves;i++){
	run("Erode");
}

run("Analyze Particles...", "size="+minSize+"-"+maxSize+" display clear summarize add");
getStatistics(area, mean, min, max, std, histogram);
}
function controlImg(){
	run("Duplicate...", " ");
	run("Subtract...", "value=255");
	run("Invert LUT");
	roiManager("Show All");
	roiManager("Fill");
	run("Green");
}
