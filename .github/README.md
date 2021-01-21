# Assembly Solutions Directory


## Introduction
Welcome to this repository. It is a collection of assembly language lab solutions, which were primarily performed at FAST-NUCES. These lab sessions can be confusing and daunting for assembly language beginners, which is why a group of students have decided to create a searchable, indexed, and maintainable code directory.

## Objectives
This repository has an aim to be the single largest source of assembly language problems and their solutions under one umbrella. Most importantly, it is to guide and allow students to appreciate the craft of assembly programming.

## How to Run Programs

* Either select the desired solution file from ```lab_solutions``` directory or find it from the searchable directory (under development).
* Install [DOSBOX](https://www.dosbox.com/download.php?main=1).
* Paste the DOSBOX folder in ```C:\ ``` drive and navigate to ```DOSBOX.exe```.
* Run the following commands.

```bash
mount x: c:\Assembly
x:
```

* Finally, run these commands to run your program in the AFD.

```sh
nasm file_name.asm -o file_name.com -l file_name.lst
afd file_name.com
```

The searchable directory will be available online for usage in a short time.

## Fair Usage Policy
By using this repository or the associated web application, you are bound by the fair usage policy. You will not use these solutions for academic submissions or misconduct. These solutions will only be used for guidance and learning.

## Contributing
If you are enthusiastic about assembly language and want to contribute more solutions, you are free to do so. Just fork the repository and submit a pull request. Make sure to follow the contribution guidelines for quick incorporation.

You can also contact the following people if you are not familiar with GitHub.

* [Farhan Ali](mailto:l191236@lhr.nu.edu.pk)
* [Saqib Ali](mailto:l190939@lhr.nu.edu.pk)
* [Nabeel Ahmed](mailto:l190916@lhr.nu.edu.pk)

## Contribution Guidelines
* Make sure to always start your files with this format. Any file without this format will be immediately discarded.

```
; ************************************************
;                  Chapter #1(Q2)
; ************************************************
; Put the original problem statement here.
; If this is a custom problem, try to be as
; descriptive about the problem as you can.
; This allows the utility to index efficiently. 
; ************************************************
;                     SOLUTION
; ************************************************
; Start your solution here...
```
* For your convenience, you can also check the ```1A-Instructions.asm``` file in the ```lab_solutions``` directory.
* Poorly commented code will not be accepted.
* Once a pull request has been submitted, kindly get your code checked by at least 3 of your friends and ask them to comment under the pull request. (This saves a lot of time).
* Sit back and relax! If your code was good, it would be included in the repository soon.