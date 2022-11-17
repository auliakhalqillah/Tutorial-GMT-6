# Tutorial GMT 6

_Note: This tutorial, I write also in my blog [auliakhalqillah.com](https://auliakhalqillah.com/generate-a-simple-map-in-gmt-6/)_

## Introduction

Hi there. In this repository, we are going to learn how to generate a simple map by using GMT 6. Generic Mapping Tools (GMT) is the tool to generate a map or visual graphic based on code line. The GMT is an open-source tool and has been widely used in Earth, Ocean and Planetary fields. This tool can be used in Linux, Windows and Mac OS. For more information about this tool and how to install it to your own system, just visit https://www.generic-mapping-tools.org/download/.

In this case, the code has been tested in Linux system through the shell of csh. If you have not installed the csh yet, type the following command through the terminal

```
sudo apt-get install csh
```

## Plot a Map

<img align="center" width=458 height=550 src="https://github.com/auliakhalqillah/Tutorial-GMT-6/blob/main/Aceh.png">

The [tutorial_gmt.csh](https://github.com/auliakhalqillah/Tutorial-GMT-6/blob/main/tutorial_gmt.csh) is the script to create a map as shown in Figure 1 above.

## NOTE

To get information for each layer, you could add the `-V` attribute in each layer like `-K -O -V >> $output`

## SOURCES

1. Grid Image (SRTM) has been downloaded from http://dwtkns.com/srtm/
2. Earthquake data of Aceh area has been download from [USGS Earthquake Catalog](https://earthquake.usgs.gov/earthquakes/search/)
3. Fault line has been generated from grid image








