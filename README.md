# Atari's 1972 Pong

A FPGA implementation of Atari's 1972 arcade game, Pong. This implementation is packaged for running on the Analogue Pocket.

## Controls

Pong is a two player game that uses potentiometers (rotary dials) for control of each player's paddle. As the Pocket doesn't have rotary dials, we have to make due with its face buttons.

| Player 1      | Player 2                     |
|---------------|------------------------------|
| D Pad Up/Down | Face Button Top/Bottom (X/B) |

To insert a coin to start the game, press the button to the right of the Analogue button (considered to be the "Plus" button). Please note that the game will restart when an additional coin is inserted, so you can start a new game by pressing "Plus" at any time.

## Implementation

This is a gate-level implementation of Pong, derived from the original schematic. All bugs and oddities with the original hardware should be represented in the synthesized hardware (if you find something that isn't, please open an issue).

As Pong was implemented using 74-series TTL logic chips, driven in an asynchronous manner (outputs from one chip may clock another), certain steps had to be taken to ensure accurate synthesis.

1. In addition to the 7.159 MHz primary clock used by Pong, a 28.636 MHz clock (4x the primary clock) is used to synchronize the various async parts of the ciruit. We take advantage of the time it takes logic gates to stablize in the original ciruit to gate updating values until an edge (typically rising) of the 28 MHz clock. This makes the logic formally synchronous, and avoids a series of problems that may arise during synthesis (see [dc5953b](https://github.com/agg23/analogue-pong/commit/dc5953be54613d9eeb33aa888bffc915d3f99dce) for an example of how changing synthesis can make or break the operation of async logic).
2. Several instances of combinational logic are converted to be synchronous to prevent the creation of combinational loops. These are denoted with a comment. In `paddle.vhd` in particular, leaving the output of the NAND `a7b` as a combinational expression resulted in the undefined clocking of the paddle height counter, resulting in flickering graphics and strange functionality.
3. 555 timers are simulated as counters based off of the primary clock, with timing approximating those found in testing. Implementation based off of https://github.com/MiSTer-devel/Arcade-Pong_MiSTer/blob/master/rtl/paddle.v
4. Horizontal sync timing in the original ciruit relies on a long ripple counter, which has the odd effect of ending `h_blank` _after_ the next rising edge of the clock (count is incremented on falling edge, and `h_blank` doesn't fall until after the rising edge). This is solved for by using the inverted primary clock as the synchronization clock for `h_blank`.
5. Due to limitations in the Analogue Pocket framework, there are currently no provisions in the synthesized bitstream for configuring the 11 or 15 point win condition. The default implementation ends the game after 11 points, but this can be changed by updating the signal and synthesizing the bitstream yourself.

## References

* [Edwards 2012 - Reconstructing Pong on an FPGA](http://www1.cs.columbia.edu/~sedwards/papers/edwards2012reconstructing.pdf) - The primary explanations of Pong's circuitry, along with nicely reformated schematics.
* [Holden - Atari Pong E Circuit Analysis & Lawn Tennis](http://www.pong-story.com/LAWN_TENNIS.pdf) - Discussion about Pong's history, circuit explanation, and common defects/mistakes in the circuit.