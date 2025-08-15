# scannertools
bash scripts to control a scanner device using the sane and imagemagick tools

## concept
<img width="2250" height="1940" alt="image" src="https://github.com/user-attachments/assets/c239eb55-9850-47d4-b68c-1f9fc5ea431c" />

## documentation
There are a lot of proprietary solutions for scanning media, out there. In
general, these media will be converted and saved e.g. in PDF format. Open
source and free CLI-based tools could be used as well. Unfortunately, the
latter ones often need to be installed and configured in order to be usable.
Those open source tools provide a much more individual and flexible way of
telling the scanner what to do. The static scripts presented here, are
"prototypes" of how to use those open source solutions:

- [`sane`](http://www.sane-project.org/) for scanning purposes and
- [`imagemagick`](https://imagemagick.org/) for file format conversions (and more)

The scripts provide fix configurations for the scan process:

- `resolution`
- `page size`
- `page orientation`
- `color settings`
- `dithering settings`
- `single or double-sided`
- ...

The implemented scan configuration is represented within the scan script name: e.g. `scan_feed_A4_200dpi_bw_ss_dark.sh`
