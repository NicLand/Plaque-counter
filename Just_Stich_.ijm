// Variables globales et initialisation (ces variables sont définies également en dehors des fonctions qui les abritent)
var in="";
var out="";
var sigma=2;
var grid_x=16; //col
var grid_y=16; //row
var overlap=15; // do not change this value
var basename="";
var nom_image="";


//Corps du code
run("Clear Results");
run("Close All");
GUI();
setBatchMode(true);
correctAllFiles();
run("Grid/Collection stitching", "type=[Grid: column-by-column] order=[Down & Right                ] grid_size_x="+grid_x+" grid_size_y="+grid_y+" tile_overlap="+overlap+" first_file_index_i=1 directory=["+out+"] file_names=["+basename+"] output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 display_fusion computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
saveAs("Tiff", out + nom_image + "_Mosaic.tif");
setBatchMode("exit and display");
call("java.lang.System.gc"); // Garbage collector
//analyse();


//La fonction "GUI" permet d'ouvrir une boite de dialogue pour déterminer tous les éléments nécessaires
//à la poursuite de la macro, l'utilisateur fixe donc les différentes variables/paramètres
//--------------------------------------------------------------
function GUI(){
	Dialog.create("Mon interface graphique");
	Dialog.addDirectory("Où sont les données source ?", "");
	Dialog.addDirectory("Où sauver les données ?", "");
	
	Dialog.addMessage("------Pre-processing------");
	//Dialog.addNumber("Largeur du gaussien (pixels)", sigma);
	Dialog.addNumber("Grid X (nombre de colonnes 'col' dans le .scan)", grid_x);
	Dialog.addNumber("Grid Y (nombre de ligne 'row' dans le .scan))", grid_y);
	Dialog.addNumber("Overlap en pixels entre deux images", overlap);
	
	//Dialog.addMessage("------Analyse------");
	//Dialog.addNumber("Prominence", prominence);
	//Dialog.addNumber("Nb de prominence à faire (intervalle du pas= +0,02)", multipro);
	//Dialog.addNumber("Enlarge (rayon d'élargissement autour du maxima local)", enlarge);
	
	Dialog.show();
	
	in=Dialog.getString()+File.separator;
	out=Dialog.getString()+File.separator;
	//sigma=Dialog.getNumber();
	grid_x=Dialog.getNumber();
	grid_y=Dialog.getNumber();
	overlap=Dialog.getNumber();
	//prominence=Dialog.getNumber();
	//multipro=Dialog.getNumber();
	//enlarge=Dialog.getNumber();

}

//La fonction "correctAllFiles" permet de corriger le défaut de chaque image
//d'un répertoire (le film noir en bas à gauche de chaque image) lié au microscope
//--------------------------------------------------------------
function correctAllFiles(){
	files=getFileList(in);
	
	for(i=0; i<files.length; i++){
		if(endsWith(files[i], ".TIF")){
			if(basename==""){
				begin=substring(files[i], 0, lastIndexOf(files[i], "_s")+2);
				end=substring(files[i], lastIndexOf(files[i], "_t"));
				basename=begin+"{i}"+end;
				nom_image=begin+end;
				print(nom_image);
				print(basename);
			}
			open(in+files[i]);
			run("Duplicate...", "title=Corr");
			//run("Gaussian Blur...", "sigma="+sigma);
			//imageCalculator("Divide create 32-bit", files[i],"Corr");
			saveAs("Tiff", out+files[i]);
			run("Close All");
		}
	}
	call("java.lang.System.gc"); // Garbage collector
}