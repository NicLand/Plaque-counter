# ImageJ Macro: Plaque Counter for 6-Well Plate Assay
**Author:** Nicolas Landrein - MFP - SpacVir 2024

---

## Overview
This macro automates the detection and quantification of plaques in a 6-well plate assay. It processes images to enhance contrast, apply filters, and count plaques based on user-defined parameters. The results are saved in a table, and a mask image is generated for visualization.

---

## Variables

| Variable      | Description                                                                 | Default Value       |
|---------------|-----------------------------------------------------------------------------|---------------------|
| `ori`         | Original name of the analyzed image.                                        | `""`                |
| `in`          | Input folder path where the image is located.                               | `""`                |
| `out`         | Output folder path for results.                                             | `""`                |
| `minSize`     | Minimum size (in pixels) for a region to be considered a plaque.             | `50`                |
| `maxSize`     | Maximum size (in pixels) for a region to be considered a plaque.            | `"Infinity"`        |
| `minCirc`     | Minimum circularity (0-1) for a region to be considered a plaque.          | `0`                 |
| `nWaves`      | Number of dilation/erosion cycles to improve plaque detection.              | `2`                 |
| `gaussBlur`   | Sigma value for Gaussian blur.                                              | `2`                 |
| `medFilt`     | Radius for median filter.                                                   | `10`                |
| `subBkgd`     | Rolling ball radius for background subtraction.                             | `50`                |
| `resize`      | Resize width/height (in pixels) for image processing.                        | `5000`              |
| `tableTitle`  | Title of the results table.                                                 | `"Plaques Area"`    |

---

## Functions

### 1. `process()`
**Purpose:** Orchestrates the entire workflow.
**Steps:**
- Prepares the image.
- Prepares plaques for detection.
- Counts plaques.
- Generates a control image.

---

### 2. `prepareImage()`
**Purpose:** Prepares the image for analysis.
**Steps:**
- Sets ImageJ options (iterations, count, black background).
- Retrieves the original image name and directory.
- Resets the ROI Manager.
- Enhances contrast.
- Resizes the image.
- Prompts the user to select the region of interest (ROI) using the oval tool.
- Clears the area outside the ROI and crops the image.
- Duplicates the image for counting.
- Tiles the original and processed images for comparison.

---

### 3. `preparePlaques()`
**Purpose:** Processes the image to highlight plaques.
**Steps:**
- Selects the "count" window.
- Clears previous results and resets the ROI Manager.
- Applies Gaussian blur, background subtraction, and median filter.
- Applies Otsu thresholding (user can adjust).
- Prompts the user to confirm the threshold.
- Applies erosion, dilation, and hole-filling to refine plaque detection.
- Analyzes particles based on size and circularity.
- Prompts the user to remove false positives.

---

### 4. `countPlaques()`
**Purpose:** Counts and records plaque statistics.
**Steps:**
- Finds or creates a results table.
- Selects the "count" window.
- For each ROI:
  - Records the image name, ROI number, and area in the table.

---

### 5. `controlImg()`
**Purpose:** Generates a control image for visualization.
**Steps:**
- Subtracts 255 from the "count" image.
- Inverts the LUT.
- Displays all ROIs and fills them.
- Colors the ROIs green.
- Saves the mask image.
- Tiles the original and mask images.

---

### 6. `findOrCreateTable(name)`
**Purpose:** Finds or creates a results table.
**Steps:**
- Checks if a table with the specified name exists.
- Creates a new table if it does not exist.

---

## Usage Instructions
1. **Open your image** in ImageJ.
2. **Run the macro**.
3. **Select the region of interest** using the oval tool when prompted.
4. **Adjust the threshold** to highlight plaques and confirm.
5. **Remove false positives** from the ROI Manager.
6. **Results** are saved in a table, and a mask image is generated.

---

## Outputs
- **Results Table:** Contains the image name, ROI number, and area for each plaque.
- **Mask Image:** Visual representation of detected plaques (saved as a TIFF file).

---

## Notes
- Adjust `minSize`, `maxSize`, and `minCirc` to fine-tune plaque detection.
- The macro assumes the input image is in the same directory as the macro.
