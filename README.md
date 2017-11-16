# Demo made for LEIA assembly

You will need the LEIA project for the assembly program and the simulator.

## Compile
First assemble the demo (the -r option is important)
`python asm.py -r demo/main.s`
Then, run it on the simulator:
`LEIA -f main.obj`

You can see below a gif of the demo (heavy, might take some time to load). The artifacts during the 3D scenes are present because of the small color palette a gif can encode:

![output](https://s1.gifyu.com/images/slowdown.gif)
