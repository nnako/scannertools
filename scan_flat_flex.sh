#!/bin/bash




#
# check if at least two arguments are provided
#

# print out the help information if the user does not provide two parameters
# when calling this script

if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 \"<param> <param> ...\" <outfile>"
    echo ""
    echo "each <param> substring can contain the following parameters:"
    echo ""
    echo "  - o<orientation>    with <orientation>:"
    echo "                        0 -> portrait (DEFAULT)"
    echo "                        1 -> landscape"
    echo ""
    echo "  - t<type>           with <type>:"
    echo "                        0 -> bw (DEFAULT)"
    echo "                        1 -> bw dark"
    echo "                        2 -> color"
    echo "                        3 -> gray"
    echo "                        4 -> bw dithered"
    echo ""
    echo "  - r<resolution>     with <resolution> in dpi"
    echo "                        75"
    echo "                        100"
    echo "                        150"
    echo "                        200 (DEFAULT)"
    echo "                        300"
    echo ""
    echo "  - w<width>          with <width> as paper width in mm"
    echo "                        210 (DEFAULT)"
    echo ""
    echo "  - h<height>         with <height> as paper height in mm"
    echo "                        295 (DEFAULT)"
    echo ""
    echo "the <outfile> parameter contains the name of the output file (no extension)"
    echo ""
    echo "examples for <param>"
    echo ""
    echo "  t0r200w105h148      -> A6  B/W"
    echo "  t4r200w148h105      -> A6L B/W dithered"
    echo "  t4r100w115h170      -> regular card B/W dithered"
    exit 1
fi




#
# set basic parameters
#

input_string="$1"
filename="$2"




#
# set defaults for the 1st page
#

# black / white, no dithering
mode=Lineart

# resolution high (200 dpi)
resolution=200

# start file name
index=1

# A4 portrait page (in mm)
width=210
height=295

# orientation portrait
orientation=0




#
# Iterate over each space-separated parameter
#

# iterate over each parameter. each parameter relates to a single page to be
# scanned. all parameters are separated by a space character within a large
# string.

for param in $input_string; do




    #
    # use regex to find all tokens of the form <letter><number>
    #

    while [[ $param =~ ([a-zA-Z])([0-9]+) ]]; do

        # set the key and value
        key="${BASH_REMATCH[1]}"        # The alphabetic prefix
        value="${BASH_REMATCH[2]}"      # The numeric value

        # Assign value to a variable dynamically
        declare "$key=$value"




        #
        # evaluate each key
        #

        case $key in
            o)
                case $value in
                    0)
                        declare "orientation=0";;
                    1)
                        declare "orientation=270";;
                esac;;

            t)
                case $value in
                    0)
                        declare "mode=Lineart";;
                    1)
                        declare "mode=Lineart";;
                    2)
                        declare "mode=Color";;
                    3)
                        declare "mode=Gray";;
                    4)
                        declare "mode=Gray";;
                esac;;

            r)
                declare "resolution=$value";;

            w)
                declare "width=$w";;

            h)
                declare "height=$h";;

        esac




        #
        # move to next key within param string
        #

        # remove the matched part from the (possibly large) parameter string to
        # process the next token

        param=${param#${BASH_REMATCH[0]}}




    done




    #
    # scan image
    #

    # now, with the determined parameters for the current page, use the sane
    # framework to scan an appropriate image. then, convert the image from PNM
    # format to PNG format. possibly, applying some further functionalities
    # like dithering.

    # wait for user to place the document
    read -p "PLEASE PUT PAGE#$i ONTO THE FLATBED" -n1

    # exchange width and height
    #if [[ $o == 1 ]]; then
    #fi

    # scan original
    if [[ $t == 1 ]]; then
        scanimage --mode=$mode --resolution=$resolution --brightness=100 --contrast=300 -x $width -y $height >/home/pi/scan_$index.pnm
    else
        scanimage --mode=$mode --resolution=$resolution -x $width -y $height >/home/pi/scan_$index.pnm
    fi

    # convert to PNG
    if [[ $t == 4 ]]; then
        convert scan_$index.pnm -ordered-dither o8x8 scan_$index.png
    else
        convert scan_$index.pnm scan_$index.png
    fi

    # rotate 90 degrees clockwise
    if [[ $o == 1 ]]; then
        convert scan_$index.png -rotate $orientation scan_$index.png
    fi

    # remove original file
    rm scan_*.pnm




    #
    # increment parameter index
    #

    # increment the page index used for numbering the different image files
    # representing the original page images

    let index+=1




done




#
# convert and move image files
#

# the single files have to be gathered and stored within a PDF file. then,
# moved to an appropriate folder from where it can automatically be transferred
# to another server / service.

# convert to PDF
convert scan_*.png $filename.pdf
rm scan_*.png

# move into nextcloud
mv $filename.pdf ~/NEXTCLOUD/_scan/

