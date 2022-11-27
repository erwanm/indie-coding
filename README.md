
# indie-coding

## Collecting open-license images

### `scrape-photoSE.py`

Web scraper to collect the winner photos of the Photography StackExchange contest since 2010.

[Photography StackExchange](https://photo.stackexchange.com/) holds a [regular contest](https://photo.meta.stackexchange.com/questions/7109/new-photo-contest) in which particpants submit their best pictures on a theme. The best photos are listed in the ["Hall of Fame"](https://photo.meta.stackexchange.com/questions/708/image-of-the-week-hall-of-fame).

The photos are licensed under Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA 4.0) with attribution required ([source](https://photo.meta.stackexchange.com/questions/7109/new-photo-contest)).

The script stores each photo together with a text file containing the author, source and details.


### `collect-ubuntu-wallpapers.sh`

Collects every background image (wallpaper) available in any of the past Ubuntu wallpapers packages until now, provided the corresponding license is found.

This script requires an Ubuntu OS. It works by installing every relevant package, extracting the images and then uninstalling the package. Every image found `x.jpg` is copied in the target directory together with its corresponding license info in `x.jpg.license` (see below). 

The code relies on information found [here](https://askubuntu.com/questions/11447/where-can-i-find-all-the-wallpapers-ever-included), [here](https://askubuntu.com/questions/519233/what-license-are-the-ubuntu-wallpapers-distributed-under) and [there](https://askubuntu.com/questions/1438419/understanding-the-copyright-file-in-ubuntu-wallpapers). Based on this info, the license details are expected to be found as follows:

- If the filename of the image is found in the copyright file, then the license corresponding to the section where the filename is found is assigned (376 images).
- If the filename is not found in the copyright file, then the default license corresponding to the section containing the line `Files: *` in the copyright file (usuallly at the beginning) is assigned, and the attribution "Ubuntu community contributors" is added (471 images).
- If even the default case is not found (format not standard, etc.), then the image is not copied but the filename and package are listed in `licenses-not-found.txt` (92 images).

The number of cases indicated above is the one obtained in 2022 using Ubuntu 22.04.


