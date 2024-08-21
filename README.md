# BACHELOR THESIS

## Name
Synthesis of Minecraft Redstone Circuits

## Description
Minecraft, a sandbox game, is the best-selling video game as of July 2024.
Creating redstone circuits, the equivalent to traditional electrical circuits, is a big part of it.
Similar to the real world, planning them can become complex very quick. With the help of the synthesis tool Rosette, which is built on Racket, generating circuits can be automated.
Optimizing different cost factors can also be achieved.

## Examples
An excerpt of the bachelor thesis, showing multiple examples, can be found in [Examples.pdf](Examples.pdf).
The folder [Minecraft Examples](MinecraftExamples) contains the Minecraft world with the prebuilt examples and additionally notes and explanations for each example.

## Installation
- Download and install Racket (which includes DrRacket) from https://download.racket-lang.org.
- Open the Racket Folder, by default "C:\Program Files\Racket", which includes "raco.exe".
- Run these two commands to install the needed packages:
  - raco pkg install rosette
  - raco pkg install while-loop

## Usage
The main interaction with the program is done via adjusting the settings and adding new goals.
An excerpt of the bachelor thesis, which explains that thoroughly, can be found in [Usage.pdf](Usage.pdf).

## Roadmap
For future work, more redstone-related objects can be implemented.
This increases the likelihood of the synthesis finding a satisfiable assignment.
When expanding the algorithm to handle three-dimensional circuits, many new possibilities arise.
Implementing more than two time steps further increases the capabilities.

## Authors and acknowledgment
Deepest gratitude to my advisor DI Maximilian Heisinger. I am thankful that you suggested
the basic idea, which we then adapted together. It precisely reflects my interests and I can
call it the perfect bachelor thesis topic.
