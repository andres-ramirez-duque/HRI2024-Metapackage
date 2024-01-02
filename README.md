# HRI2024-MetaPackage: A Lightweight Artificial Cognition Model for Socio-Affective Human-Robot Interaction
Short contribution and software submitted to HRI2024 conference 

### Prerequisites

- Ubuntu 18.04 LTS
- [ROS Melodic](http://wiki.ros.org/melodic/Installation/Ubuntu)

### Build the repository

The MetaPackage contain four catkin package.

On Jetson Nano, after install the prerequisites 

- JetPack 4.6 L4T 32.6.1 and ROS Melodic

Open a terminal and follow the instructions in jetson_deps_config file step by step. Then, clone the tobo_perception repository on catkin workspace, update the dependencies and build the packages:

    $ catkin_make -DCMAKE_BUILD_TYPE=Release
    $ source ./devel/setup.bash
    
On Raspberry, open a terminal and follow the instructions in rasp_deps_config file step by step. clone the tobo_planner, tobouk_core and tobouk_web_gui repositories on catkin workspace, update the dependencies and build the packages.

---

## License
[![CC BY-NC-SA 4.0][cc-by-nc-shield]][cc-by-nc]

This work is licensed under a
[Creative Commons Attribution-NonCommercial 4.0 International License][cc-by-nc].

[![CC BY-NC 4.0][cc-by-nc-image]][cc-by-nc]

[cc-by-nc]: http://creativecommons.org/licenses/by-nc/4.0/
[cc-by-nc-image]: https://licensebuttons.net/l/by-nc/4.0/88x31.png
[cc-by-nc-shield]: https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg
